select * from medical_guidance mg ;

update medical_guidance set type_id=30001193 where type_id=10000157;
update medical_guidance set  product_name=REPLACE (REPLACE(product_name, '\n', ''),'\r',''),generic_name =REPLACE (REPLACE(generic_name , '\n', ''),'\r','');
UPDATE medical_guidance m
JOIN medications b ON TRIM( m.product_name)  = trim(b.name) and trim(m.generic_name) =trim(b.generic_name) and b.state =0
SET m.non_spec_med_id  = b.id;


UPDATE medical_guidance m
JOIN (
    SELECT 
        p.product_name,
        p.generic_name,
        MIN(p.id) AS min_id
    FROM 
        pharmaceuticals p
    WHERE 
        p.is_active = 1
    GROUP BY 
        p.product_name, 
        p.generic_name
) AS subquery ON m.product_name = subquery.product_name 
              AND m.generic_name = subquery.generic_name
SET m.spec_med_id = subquery.min_id, updated_at =CURRENT_TIMESTAMP() ;