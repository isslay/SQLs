USE unqc1001;

CREATE TABLE `mdt_news` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `news_type` int(6) DEFAULT NULL COMMENT '资讯类型 如科普专栏',
  `news_title` varchar(255) DEFAULT NULL COMMENT '标题',
  `news_pic` varchar(255) DEFAULT NULL COMMENT '图片',
  `news_remark` varchar(255) DEFAULT NULL COMMENT '说明',
  `news_category` varchar(10) DEFAULT NULL COMMENT '分类(富文本,PDF,公众号文章,视频)',
  `news_media` varchar(255) DEFAULT NULL COMMENT '视频地址',
  `news_pdf` varchar(255) DEFAULT NULL COMMENT 'PDF地址',
  `news_content` text DEFAULT NULL COMMENT '内容',
  `news_url` varchar(255) DEFAULT NULL COMMENT '链接',
  `order_date` date DEFAULT NULL COMMENT '排序日期',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `latest_operator` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='资讯表';



CREATE TABLE `mdt_news_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_name` varchar(255) DEFAULT NULL COMMENT '类型名称',
  `type_remark` varchar(255) DEFAULT NULL COMMENT '类型说明',
  `status` tinyint(1) DEFAULT 0 COMMENT '状态(0开1关)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='协作类型表';


insert into unqc1001.mdt_news(news_type,news_title,news_pic,news_remark,news_category,news_media,news_content,news_url,order_date,created_at,updated_at,latest_operator)
select news_type,news_title ,news_pic ,news_remark ,news_audiotype,news_audio,news_content,news_web,order_date,create_time, update_time, create_user from wmdb_v2.jd_news;

update mdt_news set news_category ='富文本' where news_url is null;
update mdt_news set news_category ='公众号文章' where news_url is not null;

insert into unqc1001.mdt_news_type (type_name,type_remark,status)
select type_name,type_remark,status from wmdb_v2.jd_news_type ;