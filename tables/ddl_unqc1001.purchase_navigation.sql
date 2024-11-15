USE unqc1001;
DROP TABLE IF EXISTS `purchase_navigation`;
CREATE TABLE purchase_navigation (
	id INT auto_increment NOT NULL COMMENT 'ID',
	pharmaceutical_id INT NOT NULL COMMENT '药品ID',
	main_id varchar(50) NOT NULL COMMENT 'sys_dept.id',
	is_active BOOLEAN DEFAULT TRUE COMMENT 'True为有效，False为失效',
	primary key(id)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci
COMMENT='购药导航'
AUTO_INCREMENT=1;
CREATE UNIQUE INDEX uk_purchase_navigation USING BTREE ON unqc1001.purchase_navigation (pharmaceutical_id,main_id);
