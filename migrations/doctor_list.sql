USE unqc1001;

DROP TABLE IF EXISTS doctor_list;

-- unqc1001.doctor_list definition

CREATE TABLE `doctor_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT 'sys_user.id 医生角色3025',
  `hospital_name` varchar(100) DEFAULT NULL COMMENT '所属医院名称，多个用:分割',
  `office_name` varchar(100) DEFAULT NULL,
  `state` tinyint(4) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `editable` tinyint(4) DEFAULT '0' COMMENT '1 不能编辑',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_doctor_list` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=536 DEFAULT CHARSET=utf8 COMMENT='医生表（sys_user医生角色的扩展表）';


create temporary table temp_doc as 
select distinct trim(a.name) as name, a.id as user_id, trim(a.hospital_name) as hospital_name,'' as office_name ,0 as state,current_timestamp() as created_at  ,current_timestamp() as updated_at ,1 as editable  
from sys_user a INNER JOIN sys_user_role b on a.id =b.user_id and a.state =0 and b.state =0 
where b.role_id=3025;


insert into doctor_list(user_id ,hospital_name ,office_name ,state,created_at,updated_at,editable)
select user_id,hospital_name,office_name,state,created_at,updated_at,editable from temp_doc;

update doctor_list set hospital_name='吉林大学第一医院'
where hospital_name ='吉林大学第一医院:吉林大学白求恩第一医院';

UPDATE doctor_list d
JOIN temp_doc t ON t.user_id = d.user_id
JOIN (
    SELECT p.open_phy_name, p.hospital_name, p.offices_name, p.dates
    FROM wmdb_v2.erp_pres_main p
    WHERE p.dates > '2024-08-04' AND p.offices_name IS NOT NULL
) p ON p.open_phy_name = t.name AND p.hospital_name = d.hospital_name
SET d.office_name = trim(p.offices_name);