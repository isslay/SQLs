truncate table unqc1001.subscribe_list;

insert into unqc1001.subscribe_list(open_id,channel_id,event_date,event_type)
select openid, channel,date,event_type  from wmdb_v2.subscribe_list where channel<>'其他';