truncate table subscribe_list ;


insert into unqc1001.subscribe_list(event_type,open_id,channel_id,event_date)
select event_type,openid,channel,date  from wmdb_v2.subscribe_list;