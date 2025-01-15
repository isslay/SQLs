CREATE VIEW vw_quanchengtong_indication AS
select distinct indication_id,indication_name from pres_main pm where indication_id is not null and indication_name is not null;
