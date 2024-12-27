ALTER TABLE `erp_pres_main`
ADD COLUMN `indication_id` VARCHAR(20) DEFAULT NULL COMMENT 'Indication ID',
ADD COLUMN `indication_name` VARCHAR(255) DEFAULT NULL COMMENT 'Indication Name',
ADD COLUMN `follow_up` CHAR(1) DEFAULT NULL COMMENT 'Follow Up (Y/N)',
ADD COLUMN `soldier_family` CHAR(1) DEFAULT NULL COMMENT 'Soldier Family (Y/N)';