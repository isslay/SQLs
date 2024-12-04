CREATE VIEW vw_TeYaoTong_Doctors AS
select a.id, a.name, a.dept_name 
from sys_user a INNER JOIN sys_user_role b on a.id =b.user_id and a.state =0 and b.state =0 
where b.role_id=3025;