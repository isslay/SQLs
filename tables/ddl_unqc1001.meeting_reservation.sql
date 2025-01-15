USE unqc1001;

CREATE TABLE `meeting_reservation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `room_id` int(11) DEFAULT NULL COMMENT '会议室ID',
  `meet_date` date DEFAULT NULL COMMENT '日期 yyyy-mm-dd',
  `meet_begin` time DEFAULT NULL COMMENT '开始时间 hh:mm',
  `meet_end` time DEFAULT NULL COMMENT '结束时间 hh:mm',
  `meet_title` varchar(255) DEFAULT NULL COMMENT '会议内容',
  `meet_remark` varchar(255) DEFAULT NULL COMMENT '其他',
  `book_person` varchar(50) DEFAULT NULL COMMENT '预约人',
  `book_department` varchar(50) DEFAULT NULL COMMENT '预约部门',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `latest_operator` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='会议室预定';

CREATE TABLE `dict_meeting_room` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `room_name` varchar(255) DEFAULT NULL COMMENT '名称',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `latest_operator` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='会议室设置';
ALTER TABLE meeting_reservation AUTO_INCREMENT = 1;

insert into unqc1001.dict_meeting_room (id,room_name)
select id, room_name from wmdb_v2.jd_meeting_dict;
insert into unqc1001.meeting_reservation (room_id,meet_date,meet_begin,meet_end,meet_title,meet_remark,book_person,book_department)
select room_id ,meet_date ,begin_time, end_time,meet_title ,meet_remark ,order_person,order_department from wmdb_v2.jd_meeting_reservation;
