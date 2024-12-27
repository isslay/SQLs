use wmdb_v2;
SET SESSION group_concat_max_len = 1000000;

create temporary table temp_table1 as
select di_drug_id, di.di_label as di_label ,GROUP_CONCAT(di.di_description ORDER BY di.di_description ASC 
            SEPARATOR ' ') as  di_description  from drug_instruction di group by di.di_drug_id, di.di_label ;

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
            CONCAT('<p>', di.di_label,'</p><p>',  di.di_description, '</p>') 
            ORDER BY di.di_label DESC 
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
insert into unqc1001.medical_guidance(title, product_name,generic_name,type_id,content,created_at,latest_operator)    
select '用药须知' as title,  temp_data.drug_name as product_name, temp_data.generic_name as generic_name, 10000157 as type_id, temp_data.content as content, current_time() as create_time, 100048 as latest_operator 
from temp_data where content is not null;

drop table temp_table1;
drop table temp_data;

update unqc1001.medical_guidance set generic_name=REPLACE(generic_name, '\n', ''), product_name =REPLACE(product_name, '\n', '');