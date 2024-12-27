
-- Step 1, 重建medications' index。去掉 drug_list 中的换行符
ALTER TABLE unqc1001.medications DROP INDEX uk_medications;
CREATE UNIQUE INDEX medications_name_IDX USING BTREE ON unqc1001.medications (name,generic_name,manufacturer_id,state);
update wmdb_v2.drug_list set dl_drug_name=REPLACE (REPLACE (dl_drug_name,'\n',''),'\r',''),dl_trade_name =REPLACE (REPLACE (dl_trade_name,'\n',''),'\r','')

-- Step 2, 根据drug_list， 补充供应商表 392 rows
insert into manufacturers(org_id,name,short_name,state,created_at,updated_at)
select distinct '2SE04XzvbYRzVlcK' as org_id,d.dl_manufacturer as name, d.dl_manufacturer as short_name, 0 as state , CURRENT_TIMESTAMP() as created_at, CURRENT_TIMESTAMP() as updated_at  
from wmdb_v2.drug_list d left join manufacturers m on d.dl_manufacturer LIKE CONCAT('%', m.short_name, '%')
WHERE m.name IS NULL AND d.dl_manufacturer IS NOT NULL and d.dl_status =0;

-- Step 3, 根据drug_list表，补充medications 缺失数据. 1119 rows
-- select dl_drug_name ,dl_manufacturer ,count(dl_id) from wmdb_v2.drug_list dl group by dl_drug_name,dl_manufacturer  having count(dl_id)>1;
insert into unqc1001.medications (org_id ,name,generic_name,manufacturer_id,created_at,updated_at ,remark)
select distinct '2SE04XzvbYRzVlcK' as org_id , d.dl_drug_name as name, d.dl_trade_name as generic_name,m2.id as manufacturer_id, CURRENT_TIMESTAMP() as created_at,CURRENT_TIMESTAMP() as updated_at  ,'dev manual import' as remark  
from wmdb_v2.drug_list d left join unqc1001.medications m on d.dl_drug_name=m.name and d.dl_trade_name =m.generic_name 
				left join unqc1001.manufacturers m2  ON d.dl_manufacturer LIKE CONCAT('%', m2.name, '%') 
where m.id is null and d.dl_status =0;

-- Step 4, update null manufacturer_id in medications, 3 rows
UPDATE unqc1001.medications m
JOIN wmdb_v2.drug_list dl ON dl.dl_drug_name = m.name and dl.dl_trade_name =m.generic_name  and dl.dl_status =0
JOIN  unqc1001.manufacturers mf ON  dl.dl_manufacturer LIKE CONCAT('%', mf.name , '%') and dl.dl_status =0
SET m.manufacturer_id = mf.id
WHERE m.manufacturer_id IS NULL;

-- Step 5, 导入pharmaceuticals, rows 1769
truncate table pharmaceuticals ;

INSERT INTO unqc1001.pharmaceuticals (product_name, generic_name, specification, form_id, price, manufacturer, storage_conditions, insurance_status, insurance_code, marketing_authorization_holder, is_active, created_at , updated_at , latest_operator,med_id)
SELECT 
    d.dl_drug_name AS product_name,
    d.dl_trade_name AS generic_name,
    dl_spec AS specification,
    dl_dosage_form_id AS form_id,
    dl_price AS price,
    dl_manufacturer AS manufacturer,
    dl_storage_condition AS storage_conditions,
    dl_is_medicare AS insurance_status,
    dl_medicare_id AS insurance_code,
    '' AS marketing_authorization_holder,
    1 AS is_active, -- Assuming all imported records are active
    NOW() AS create_time,
    NOW() AS update_time,
    100048 AS latest_operator,
    m2.id as med_id 

FROM wmdb_v2.drug_list d join medications m2  on d.dl_drug_name =m2.name and d.dl_trade_name =m2.generic_name 
WHERE dl_status = 0;