-- wmdb_v2.erp_pres_detail definition

CREATE TABLE `pres_detail` (
  `bill_no` varchar(30) NOT NULL COMMENT '处方主键',
  `bill_sn` varchar(5) NOT NULL COMMENT '处方明细序号',
  `goods_code` varchar(30) DEFAULT NULL COMMENT '商品编号',
  `goods_name` varchar(255) DEFAULT NULL COMMENT '商品名称',
  `goods_spec` varchar(255) DEFAULT NULL COMMENT '规格型号',
  `manufacturer` varchar(255) DEFAULT NULL COMMENT '生产厂商',
  `unit` varchar(50) DEFAULT NULL COMMENT '单位',
  `num` decimal(10,2) DEFAULT NULL COMMENT '数量',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `goods_id` varchar(30) DEFAULT NULL COMMENT '商品ID',
  `formula` varchar(50) DEFAULT NULL COMMENT '剂型',
  PRIMARY KEY (`bill_no`,`bill_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='处方明细表';