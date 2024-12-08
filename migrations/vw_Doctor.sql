CREATE VIEW vw_teyaotong_products AS
select DISTINCT id FROM pharma

CREATE VIEW vw_teyaotong_doctors AS
select a.id, a.name, a.dept_name 
from sys_user a INNER JOIN sys_user_role b on a.id =b.user_id and a.state =0 and b.state =0 
where b.role_id=3025;


CREATE VIEW vw_teyaotong_insurance AS
select id,name from dict where parent_id =1010 and state=0;


CREATE VIEW vw_teyaotong_form AS
select id,name from dict where parent_id =1027 and state=0;

