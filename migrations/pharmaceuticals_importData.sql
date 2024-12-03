select * from wmdb_v2.erp_goods_info egi limit 10;


select distinct goods_id, goods_name,goods_spec  from wmdb_v2.erp_goods_info;


select * from pharmaceuticals;
SELECT dl_drug_name '商品名', dl_trade_name '通用名',
dl_spec '规格',dl_dosage_form '剂型', dl_price '价格',
dl_dosage_form_id '剂型ID',dl_manufacturer '生产企业', 
dl_storage_condition '存储条件',dl_is_medicare '医保情况',
 dl_medicare_id '医保编码','' as '上市许可持有人'  from wmdb_v2.drug_list where dl_status=0 and dl_manufacturer is null;
 
select * from medication_records mr ;


select distinct id from pharmaceuticals ;



select * from patient_list pl  limit 10;
select * from doctor_list dl  limit 10;




INSERT INTO pharmaceuticals (product_name, generic_name, specification, form_id, price, manufacturer, storage_conditions, insurance_status, insurance_code, marketing_authorization_holder, is_active, create_time, update_time, latest_operator)
SELECT 
    dl_drug_name AS product_name,
    dl_trade_name AS generic_name,
    dl_spec AS specification,
    dl_dosage_form_id AS form_id,
    dl_price AS price,
    
    dl_manufacturer AS manufacturer,
    dl_storage_condition AS storage_conditions,
    dl_is_medicare AS insurance_status,
    dl_medicare_id AS insurance_code,
    '' AS marketing_authorization_holder,
    1 AS is_active, -- Assuming all imported records are active
    NOW() AS create_time,
    null AS update_time,
    null AS latest_operator
FROM wmdb_v2.drug_list
WHERE dl_status = 0;


select version();
select * from pharmaceuticals where id=1;

select * from medical_guidance limit 10;
drop table medication_records;
drop table medical_guidance;
drop table pharmaceuticals;

delete from __EFMigrationsHistory;

select version ();




CREATE TABLE IF NOT EXISTS `__EFMigrationsHistory` (
    `MigrationId` varchar(150) CHARACTER SET utf8mb4 NOT NULL,
    `ProductVersion` varchar(32) CHARACTER SET utf8mb4 NOT NULL,
    CONSTRAINT `PK___EFMigrationsHistory` PRIMARY KEY (`MigrationId`)
) CHARACTER SET=utf8mb4;

START TRANSACTION;

ALTER DATABASE CHARACTER SET utf8mb4;

CREATE TABLE `medical_guidance` (
    `Id` int NOT NULL COMMENT 'ID' AUTO_INCREMENT,
    `product_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    `generic_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    `type_id` INT NOT NULL COMMENT '分类',
    `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '内容',
    `create_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NULL COMMENT '更新时间',
    `is_active` tinyint(1) NOT NULL DEFAULT TRUE COMMENT 'True为有效，False为失效',
    `latest_operator` INT NOT NULL COMMENT '操作者',
    CONSTRAINT `PK_medical_guidance` PRIMARY KEY (`Id`)
) CHARACTER SET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='医疗指导';

CREATE TABLE `pharmaceuticals` (
    `id` int NOT NULL COMMENT 'ID' AUTO_INCREMENT,
    `product_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    `manufacturer` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
    `generic_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    `specification` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    `form_id` INT NOT NULL COMMENT '药品剂型',
    `marketing_authorization_holder` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '上市许可持有人',
    `price` decimal(10,2) NULL COMMENT '价格',
    `storage_conditions` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '存储条件',
    `insurance_status` INT NOT NULL COMMENT '医保情况 dict.name=''药品医保类型''',
    `insurance_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '医保编码',
    `is_active` tinyint(1) NOT NULL DEFAULT TRUE COMMENT 'True为有效，False为失效',
    `create_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NULL COMMENT '修改时间',
    `latest_operator` INT NULL COMMENT '操作者',
    CONSTRAINT `PRIMARY` PRIMARY KEY (`id`)
) CHARACTER SET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='特药通药品信息表';

CREATE TABLE `medication_records` (
    `Id` int NOT NULL COMMENT 'ID' AUTO_INCREMENT,
    `pharmaceutical_id` int NOT NULL COMMENT '药品ID',
    `patient_id` char(36) COLLATE ascii_general_ci NOT NULL COMMENT '患者ID',
    `doctor_id` char(36) COLLATE ascii_general_ci NOT NULL COMMENT '医生ID',
    `medication_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '用药日期',
    `medication_quantity` INT NOT NULL DEFAULT 0 COMMENT '用药数量',
    `disease` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '所患疾病',
    `new_patient` tinyint(1) NOT NULL DEFAULT FALSE COMMENT '是否新患',
    `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '备注',
    `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime NULL COMMENT '更新时间',
    `is_active` tinyint(1) NOT NULL DEFAULT TRUE COMMENT '是否有效',
    `last_operator` INT NOT NULL COMMENT '更新者',
    CONSTRAINT `PK_medication_records` PRIMARY KEY (`Id`),
    CONSTRAINT `FK_medication_records_pharmaceuticals_pharmaceutical_id` FOREIGN KEY (`pharmaceutical_id`) REFERENCES `pharmaceuticals` (`id`) ON DELETE CASCADE
) CHARACTER SET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用药记录';

CREATE UNIQUE INDEX `uk_medical_guidance` ON `medical_guidance` (`product_name`, `generic_name`, `type_id`, `is_active`);

CREATE INDEX `IX_medication_records_doctor_id` ON `medication_records` (`doctor_id`);

CREATE INDEX `IX_medication_records_patient_id` ON `medication_records` (`patient_id`);

CREATE INDEX `IX_medication_records_pharmaceutical_id` ON `medication_records` (`pharmaceutical_id`);

CREATE UNIQUE INDEX `uk_pharmaceuticals` ON `pharmaceuticals` (`id`, `insurance_code`, `is_active`);

INSERT INTO `__EFMigrationsHistory` (`MigrationId`, `ProductVersion`)
VALUES ('20241203063905_InitialCreate', '8.0.10');

COMMIT;



-- Insert dummy data into medication_records table
INSERT INTO `medication_records` (`pharmaceutical_id`, `patient_id`, `doctor_id`, `medication_date`, `medication_quantity`, `disease`, `new_patient`, `remark`, `created_at`, `updated_at`, `is_active`, `last_operator`)
VALUES
(1, '000111d8-22c7-473c-8c04-657b68ba3680', '0074b9a8-badd-465a-a612-3e7e9b3bcee5', '2023-10-01 10:00:00', 10, '疾病1', 0, 'Remark1', '2023-10-01 10:00:00', NULL, 1, 1001),
(2, '000512ca-9c15-43ca-ac3e-edbfa9092af4', '0132c530-2878-4df9-b4fc-f347030b5504', '2023-10-02 11:00:00', 20, '疾病2', 0, 'Remark2', '2023-10-02 11:00:00', NULL, 1, 1002),
(3, '00051b07-2893-41f5-a0d6-7e886b4840c5', '01dceecf-944b-44b6-b489-8621dd2c78b4', '2023-10-03 12:00:00', 15, '疾病3', 1, 'Remark3', '2023-10-03 12:00:00', NULL, 1, 1003),
(4, '0007a4dc-c2af-468a-9867-65c7b94147cb', '0211d2e5-0613-4972-bbdd-7dca01546202', '2023-10-04 13:00:00', 5, '疾病4', 0, 'Remark4', '2023-10-04 13:00:00', NULL, 1, 1004),
(5, '00082dff-3d88-4397-8257-73c9eeac18a5', '031a5181-6888-47da-8918-fa302b37957e', '2023-10-05 14:00:00', 25, '疾病5', 0, 'Remark5', '2023-10-05 14:00:00', NULL, 0, 1005);



