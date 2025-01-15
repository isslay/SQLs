use wmdb_v2;
SET SESSION group_concat_max_len = 1000000;

create temporary table temp_table1 as
select di_drug_id, di.di_label as di_label ,GROUP_CONCAT(di.di_description ORDER BY di.di_description ASC 
            SEPARATOR ' ') as  di_description  from drug_instruction di where di.di_label is not null group by di.di_drug_id, di.di_label ;

CREATE TABLE temp_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    drug_name VARCHAR(255),
    generic_name VARCHAR(255),
    content TEXT
);
-- pull data
INSERT INTO temp_data (drug_name, generic_name, content)
SELECT 
    dl.dl_drug_name AS drug_name, 
    dl.dl_trade_name AS generic_name, 
    (
        SELECT GROUP_CONCAT(
            CONCAT('<p class="mg_tag">', di.di_label,'</p><p>',  di.di_description, '</p>') 
            ORDER BY FIELD(di.di_label, '适应症', '用法用量', '不良反应', '不良反应对症处理','用药注意事项', '药物相互作用','禁忌症','月均用量及费用')
            SEPARATOR ''
        )
        FROM temp_table1 di 
        WHERE dl.dl_id = di.di_drug_id
    ) AS content
FROM 
    drug_list dl 
WHERE  
    dl.dl_status = 0 
GROUP BY 
    dl.dl_id, 
    dl.dl_drug_name, 
    dl.dl_trade_name;


-- remove duplicate 1
CREATE TEMPORARY TABLE RankedData AS
SELECT 
    t1.id
FROM 
    temp_data t1
JOIN 
    temp_data t2
ON 
    t1.generic_name = t2.generic_name 
    AND t1.drug_name = t2.drug_name
    AND t1.content < t2.content;
DELETE FROM temp_data WHERE id IN (SELECT id FROM RankedData);

DROP TABLE RankedData;
   
-- remove duplicate 2
CREATE TEMPORARY TABLE temp_unique AS
SELECT MIN(id) AS id, drug_name, generic_name, content
FROM temp_data
GROUP BY drug_name, generic_name, content;

DELETE FROM temp_data;

INSERT INTO temp_data (id, drug_name, generic_name, content)
SELECT id, drug_name, generic_name, content
FROM temp_unique;

DROP TABLE temp_unique;



-- import data	
insert into unqc1001.medical_guidance(title, product_name,generic_name,type_id,content,created_at,latest_operator,non_spec_med_id,spec_med_id)    
select '用药须知' as title,  temp_data.drug_name as product_name, temp_data.generic_name as generic_name, 30001267 as type_id, temp_data.content as content, current_time() as create_time, 100048 as latest_operator,0,0 
from temp_data where content is not null;

drop table temp_table1;
drop table temp_data;

update unqc1001.medical_guidance set generic_name=replace (REPLACE(generic_name, '\n', ''),'\r',''), product_name =replace(REPLACE(product_name, '\n', ''),'\r','');

UPDATE unqc1001.medical_guidance m
JOIN unqc1001.medications b ON TRIM( m.product_name)  = trim(b.name) and trim(m.generic_name) =trim(b.generic_name) and b.state =0
SET m.non_spec_med_id  = b.id;


UPDATE unqc1001.medical_guidance m
JOIN (
    SELECT 
        p.product_name,
        p.generic_name,
        MIN(p.id) AS min_id
    FROM 
        unqc1001.pharmaceuticals p
    WHERE 
        p.is_active = 1
    GROUP BY 
        p.product_name, 
        p.generic_name
) AS subquery ON m.product_name = subquery.product_name 
              AND m.generic_name = subquery.generic_name
SET m.spec_med_id = subquery.min_id, updated_at =CURRENT_TIMESTAMP() ;


