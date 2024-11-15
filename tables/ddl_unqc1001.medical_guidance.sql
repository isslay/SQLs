USE unqc1001;
DROP TABLE IF EXISTS `medical_guidance`;

CREATE TABLE medical_guidance (
	id INT auto_increment NOT NULL COMMENT 'ID',
	product_id INT NOT NULL COMMENT '产品ID',
	type_id INT NOT NULL COMMENT '分类',
	content TEXT NULL COMMENT '内容',
	is_active BOOLEAN DEFAULT TRUE COMMENT 'True为有效，False为失效',
	create_time DATETIME DEFAULT CURRENT_TIMESTAMP NULL COMMENT '创建时间',
	update_time DATETIME NULL COMMENT '更新时间',
	latest_operator INT NULL COMMENT '操作者',
	PRIMARY KEY (id) 
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='医疗指导'
AUTO_INCREMENT=1;
CREATE UNIQUE INDEX uk_medical_guidance USING BTREE ON medical_guidance (product_id,type_id);
