DROP PROCEDURE IF EXISTS GetPfizerFollowUpRecords;

DELIMITER //

CREATE PROCEDURE GetPfizerFollowUpRecords()
BEGIN
    -- 药品列表
    CREATE TEMPORARY TABLE tmptable AS
        SELECT DISTINCT goods_id, goods_name, general_name, goods_spec 
        FROM wmdb_v2.erp_goods_info 
        WHERE goods_name LIKE '%希必可%'
        UNION 
        SELECT DISTINCT goods_id, goods_name, general_name, goods_spec 
        FROM wmdb_v2.erp_goods_info 
        WHERE goods_name LIKE '%乐复诺%'
        UNION 
        SELECT DISTINCT goods_id, goods_name, general_name, goods_spec 
        FROM wmdb_v2.erp_goods_info 
        WHERE goods_name LIKE '%乐泰可%'
        UNION 
        SELECT DISTINCT goods_id, goods_name, general_name, goods_spec 
        FROM wmdb_v2.erp_goods_info 
        WHERE goods_name LIKE '%择捷美%'
        UNION 
        SELECT DISTINCT goods_id, goods_name, general_name, goods_spec 
        FROM wmdb_v2.erp_goods_info 
        WHERE goods_name LIKE '%博瑞纳%';

    -- 回访记录
    SELECT 
        fur.id AS hfid,
		-- 连锁编码
		CASE 
        WHEN fur.pharmacy = 'YXO00000212' THEN '4730'
        WHEN fur.pharmacy = 'YXO00000122' THEN '4730'
		WHEN fur.pharmacy = 'YXO00000032' THEN '4207'
		WHEN fur.pharmacy = 'YXO00000072' THEN '4730'
		WHEN fur.pharmacy = 'YXO00000310' THEN '4207'
        -- Add more conditions as needed
        ELSE 'ERROR DATA' 
		END AS companyid,
		-- 门店编码
		CASE 
		-- 平治店
        WHEN fur.pharmacy = 'YXO00000212' THEN '0000000991'
		-- 东盛店		
        WHEN fur.pharmacy = 'YXO00000122' THEN '0000000989'
		-- 红旗店		
        WHEN fur.pharmacy = 'YXO00000032' THEN '0000001000' 
		-- 南湖店		
        WHEN fur.pharmacy = 'YXO00000072' THEN '0000000998' 
		-- 吉林店		
        WHEN fur.pharmacy = 'YXO00000310' THEN '0000001001' 
        -- Add more conditions as needed
        ELSE 'ERROR DATA' 
		END AS shopid,
        fur.pharmacy_text AS shopname,
        fur.patient_id AS memberId,
        fur.pres_patient_tel AS memberphone,
        fur.pres_patient_name AS membername,
        tmp.goods_id AS goodsid,
        SUBSTRING_INDEX(SUBSTRING_INDEX(tmp.goods_name, '(', -1), ')', 1) AS goodsname,
        TRIM(REPLACE(tmp.goods_name, CONCAT('(', SUBSTRING_INDEX(SUBSTRING_INDEX(tmp.goods_name, '(', -1), ')', 1), ')'), '')) AS currencyname,
        tmp.goods_spec AS unit,
        fur.indication_text AS symptom,
        UNIX_TIMESTAMP(fur.opr_date) AS hftime
    FROM unqc1001.follow_up_record fur 
    JOIN tmptable tmp ON FIND_IN_SET(tmp.goods_id, REPLACE(fur.drug_ids, ':', ','))
    WHERE fur.opr_date >= '2023-12-01' 
      AND fur.state = 0
	  -- Exclude published records
      AND NOT EXISTS (
          SELECT 1 
          FROM unqc1001.pfizer_publish_history pph 
          WHERE pph.hfid = fur.id
      )
	  -- Current pharmacy list: 东盛，平治
	  AND
	  fur.pharmacy in (
						'YXO00000212',  -- 平治
						'YXO00000122',  -- 东盛
						'YXO00000032',  -- 红旗
						'YXO00000072',  -- 南湖
						'YXO00000310'   -- 吉林
						)
	  -- Exclude noise data
	  AND fur.pharmacy_text is not null and fur.pharmacy_text<>''
    ORDER BY fur.created_at DESC;

    -- Drop the temporary table
    DROP TABLE tmptable;
END //

DELIMITER ;