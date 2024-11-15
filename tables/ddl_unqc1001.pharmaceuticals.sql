USE unqc1001;
DROP TABLE IF EXISTS `pharmaceuticals`;
CREATE TABLE pharmaceuticals (
	id INT auto_increment NOT NULL COMMENT 'ID',
	product_id INT NOT NULL COMMENT '产品ID',
	specification varchar(100) NULL COMMENT '规格',
	form INT NULL COMMENT '剂型ID dict.name=''药品剂型''',
	marketing_authorization_holder varchar(20) NULL COMMENT '上市许可持有人', 
	price DECIMAL NULL COMMENT '价格',
	storage_conditions varchar(100) NULL COMMENT '存储条件',
	insurance_status INT NULL COMMENT '医保情况 dict.name=''药品医保类型''',
	insurance_code varchar(20) NULL COMMENT '医保编码',
	is_active BOOLEAN DEFAULT TRUE COMMENT 'True为有效，False为失效',
	create_time DATETIME DEFAULT CURRENT_TIMESTAMP NULL COMMENT '创建时间',
	update_time DATETIME NULL COMMENT '修改时间',
	latest_operator INT NULL COMMENT '操作者',
	PRIMARY KEY (id)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci
COMMENT='特药通药品信息表'
AUTO_INCREMENT=1;
CREATE UNIQUE INDEX uk_pharmaceuticals USING BTREE ON pharmaceuticals (id,specification,insurance_code);
