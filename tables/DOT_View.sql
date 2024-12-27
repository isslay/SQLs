select `d`.`bill_no` AS `bill_no`,`d`.`bill_sn` AS `bill_sn`,
`d`.`goods_code` AS `goods_code`,`d`.`goods_id` AS `goods_id`,
`d`.`goods_name` AS `goods_name`,`d`.`approval_no` AS `approval_no`,
`d`.`goods_spec` AS `goods_spec`,`d`.`manufacturer` AS `manufacturer`,
`d`.`unit` AS `unit`,`d`.`num` AS `num`,`d`.`retail_p` AS `retail_p`,
`d`.`tra_price` AS `tra_price`,`d`.`rec_amt` AS `rec_amt`,
`d`.`paid_in_amt` AS `paid_in_amt`,`d`.`amount` AS `amount`,
`d`.`batch_Code` AS `batch_Code`,`d`.`produce_date` AS `produce_date`,
`d`.`val_date` AS `val_date`,`d`.`place` AS `place`,`d`.`batch_no` AS `batch_no`,
`d`.`tax` AS `tax`,`d`.`ded_rate` AS `ded_rate`,`d`.`rate` AS `rate`,
`d`.`in_tax_rate` AS `in_tax_rate`,`d`.`out_tax_rate` AS `out_tax_rate`,
`d`.`cost` AS `cost`,`d`.`cost_amt` AS `cost_amt`,`d`.`profit` AS `profit`,
`d`.`profit_rate` AS `profit_rate`,`d`.`tax_price` AS `tax_price`,
`d`.`tax_cost_amt` AS `tax_cost_amt`,`d`.`tax_profit` AS `tax_profit`,
`d`.`tax_profit_rate` AS `tax_profit_rate`,`d`.`sale_man_name` AS `sale_man_name`,
`d`.`is_pres` AS `is_pres`,`d`.`recipe_type` AS `recipe_type`,
`d`.`business_code` AS `business_code`,`d`.`business_name` AS `business_name`,
`d`.`san_zz` AS `san_zz`,`d`.`cgsx` AS `cgsx`,`d`.`sale_lb` AS `sale_lb`,
`d`.`jgfl` AS `jgfl`,`d`.`merchant_discount` AS `merchant_discount`,
`d`.`platform_discount` AS `platform_discount`,`d`.`freight_discount` AS `freight_discount`,
`d`.`freight_discount_business` AS `freight_discount_business`,
`d`.`freight_discount_platform` AS `freight_discount_platform`,
`d`.`platform_fee` AS `platform_fee`,`d`.`agreement_fee` AS `agreement_fee`,
`d`.`pay_fee` AS `pay_fee`,`d`.`call_delivery_fee` AS `call_delivery_fee`,
`d`.`call_tip_fee` AS `call_tip_fee`,`d`.`angle_id` AS `angle_id`,
`d`.`spfl_a` AS `spfl_a`,`d`.`spfl_b` AS `spfl_b`,
`d`.`spfl_c` AS `spfl_c`,`d`.`spfl_d` AS `spfl_d`,`d`.`order_channel` AS `order_channel`,
`d`.`order_source` AS `order_source`,`d`.`g_category` AS `g_category`,
`d`.`q_category` AS `q_category`,`m`.`dates` AS `dates`,`m`.`org_name` AS `org_name`,
`m`.`bill_code` AS `bill_code`,`m`.`org_id` AS `org_id`,`p`.`bill_code` AS `pres_bill_code`,
`p`.`contact` AS `contact`,`p`.`mobile` AS `mobile`,`p`.`hospital_name` AS `hospital_name`,
`p`.`hospital_code` AS `hospital_code`,`p`.`open_phy_name` AS `open_phy_name`,
`p`.`open_phy_code` AS `open_phy_code`,`p`.`offices_name` AS `offices_name`,
`p`.`offices_code` AS `offices_code`,`p`.`age` AS `age`,`p`.`gender` AS `gender`,
`p`.`suffer_dis` AS `suffer_dis`,`p`.`is_new` AS `is_new`,`p`.`id_card` AS `id_card`,
`p`.`bill_no` AS `pres_bill_no`,`m`.`created_at` AS `created_at`,`m`.`updated_at` AS `updated_at`,
`m`.`coupon_date` AS `coupon_date`,`m`.`busi_type` AS `busi_type`,`m`.`re_bill_code` AS `re_bill_code`,
`p`.`remark` AS `remark` 
from ((`erp_order_detail` `d` join `erp_order_main` `m` on((`d`.`bill_no` = `m`.`bill_no`))) 
left join `erp_pres_main` `p` on((`p`.`bill_no` = `m`.`cf_bill_no`))) order by `m`.`dates` desc