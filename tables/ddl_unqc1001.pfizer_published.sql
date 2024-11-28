CREATE TABLE unqc1001.pfizer_publish_history (
	hfid char(36) NOT NULL,
	companyid varchar(10) NOT NULL,
	publish_time DATETIME DEFAULT CURRENT_TIMESTAMP NULL
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci;
