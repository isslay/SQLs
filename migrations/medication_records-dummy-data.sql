select * from medication_records mr ;


select * from pharmaceuticals p limit 10;


select * from dict limit 10;

declare @parentId int
select @parentId=id from dict where name='药品医保类型'


select id from dict where name='药品医保类型';


select id,name from dict where parent_id =1010 and state=0;


CREATE VIEW vw_teyaotong_insurance_status AS
select id,name from dict where parent_id =1010 and state=0;

drop view vw_teyaotong_insurance_status;

select * from vw_teyaotong_insurance;
select * from vw_teyaotong_form;

select version();


select * from vw_teyaotong_insurance;

drop table medical_guidance ;
drop table pharmaceuticals ;
drop table medication_records ;
select * from pharmaceuticals p limit 10;



-- Insert dummy data into medication_records table
INSERT INTO `medication_records` (`pharmaceutical_id`, `patient_id`, `doctor_id`, `medication_date`, `medication_quantity`, `disease`, `new_patient`, `remark`, `created_at`, `updated_at`, `is_active`, `last_operator`)
VALUES
(1, '000111d8-22c7-473c-8c04-657b68ba3680', 100844, '2023-10-01 10:00:00', 10, '疾病1', 0, 'Remark1', '2023-10-01 10:00:00', NULL, 1, 1001),
(2, '000512ca-9c15-43ca-ac3e-edbfa9092af4', 100844, '2023-10-02 11:00:00', 20, '疾病2', 0, 'Remark2', '2023-10-02 11:00:00', NULL, 1, 1002),
(3, '00051b07-2893-41f5-a0d6-7e886b4840c5', 100844, '2023-10-03 12:00:00', 15, '疾病3', 1, 'Remark3', '2023-10-03 12:00:00', NULL, 1, 1003),
(4, '0007a4dc-c2af-468a-9867-65c7b94147cb', 100844, '2023-10-04 13:00:00', 5, '疾病4', 0, 'Remark4', '2023-10-04 13:00:00', NULL, 1, 1004),
(5, '00082dff-3d88-4397-8257-73c9eeac18a5', 100844, '2023-10-05 14:00:00', 25, '疾病5', 0, 'Remark5', '2023-10-05 14:00:00', NULL, 0, 1005);