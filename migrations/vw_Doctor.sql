CREATE VIEW vw_teyaotong_products AS
select distinct id, product_name, manufacturer, generic_name,specification  from medication_info; 

CREATE VIEW vw_teyaotong_doctors AS
select a.id, a.name, a.dept_name 
from sys_user a INNER JOIN sys_user_role b on a.id =b.user_id and a.state =0 and b.state =0 
where b.role_id=3025;


CREATE VIEW vw_teyaotong_insurance AS
select id,name from dict where parent_id =1010 and state=0;


CREATE VIEW vw_teyaotong_form AS
select id,name from dict where parent_id =1027 and state=0;


CREATE VIEW vw_teyaotong_groups AS
SELECT 
    doctor_id,
    GROUP_CONCAT(group_id ORDER BY group_id SEPARATOR ',') AS group_ids
FROM 
    doctor_group_member
WHERE 
    state = 0
GROUP BY 
    doctor_id;

