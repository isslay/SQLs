
CREATE TABLE `mdt_doctors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `main_id` int(11) DEFAULT NULL,
  `dr_name` varchar(50) DEFAULT NULL,
  `dr_introduction` text,
  `dr_status` int(1) DEFAULT '0',
  `dr_avatar_url` varchar(255) DEFAULT NULL,
  `dr_rank` varchar(50) DEFAULT NULL,
  `dr_dept` varchar(50) DEFAULT NULL,
  `dr_sort` tinyint(2) DEFAULT '0',
  `dr_hospital` varchar(255) DEFAULT NULL,
  `dr_genius` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='医生简介';


insert into unqc1001.mdt_doctors(`main_id`,`dr_name`,`dr_introduction`,`dr_status`,`dr_avatar_url`,`dr_rank`,`dr_dept`,`dr_sort`,`dr_hospital`,`dr_genius`)
select null as main_id,dr_name,dr_introduction,dr_status,dr_avatar_url,dr_rank,dr_dept,dr_sort,dr_hospital,dr_genius  from wmdb_v2.wio_doctor where dr_status=0




