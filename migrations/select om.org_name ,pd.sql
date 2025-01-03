-- query 1
select om.org_name as OrgName, od.goods_name as GoodsName, SUM(od.num) as TotalQuantity 
from order_main om join order_detail od on om.bill_no =od.bill_no 
where om.created_at > '2023-06-01'  and om.created_at <= '2025-01-01' and od.goods_id in ('G0000285476')
group  by om.org_name , od.goods_name ;

-- query 2
SELECT 
    om.org_name,
    pd.goods_name,
    COUNT(DISTINCT 
        CASE 
            WHEN pm.id_card IS NOT NULL THEN pm.id_card
            ELSE CONCAT(IFNULL(pm.contact, ''), IFNULL(pm.mobile, ''))
        END
    ) AS distinct_patient_count
FROM 
    pres_main pm 
JOIN 
    pres_detail pd ON pm.bill_no = pd.bill_no 
JOIN 
    order_main om ON om.cf_bill_no = pm.bill_no 
WHERE 
    pd.goods_id IN ('G0000285476') 
    AND om.created_at <= '2025-01-01' 
    AND om.created_at > '2023-06-01'
GROUP BY 
    om.org_name, 
    pd.goods_name;

//combined query
SELECT 
    om.org_name AS OrgName,
    od.goods_name AS GoodsName,
    SUM(od.num) AS TotalQuantity,
    COUNT(DISTINCT 
        CASE 
            WHEN pm.id_card IS NOT NULL THEN pm.id_card
            ELSE CONCAT(IFNULL(pm.contact, ''), IFNULL(pm.mobile, ''))
        END
    ) AS distinct_patient_count
FROM 
    order_main om 
JOIN 
    order_detail od ON om.bill_no = od.bill_no 
JOIN 
    pres_main pm ON om.cf_bill_no = pm.bill_no 
JOIN 
    pres_detail pd ON pm.bill_no = pd.bill_no AND pd.goods_id = od.goods_id
WHERE 
    od.goods_id IN ('G0000285476') 
    AND om.created_at <= '2025-01-01' 
    AND om.created_at > '2023-06-01'
GROUP BY 
    om.org_name, 
    od.goods_name;


-- revised combined query
SELECT 
    tq.OrgName,
    tq.GoodsName,
    tq.TotalQuantity,
    dp.distinct_patient_count
FROM 
    (SELECT 
        om.org_name AS OrgName,
        od.goods_name AS GoodsName,
        SUM(od.num) AS TotalQuantity
     FROM 
        order_main om 
     JOIN 
        order_detail od ON om.bill_no = od.bill_no 
     WHERE 
        om.created_at > '2023-06-01' 
        AND om.created_at <= '2025-01-01' 
        AND od.goods_id IN ('G0000285476')
     GROUP BY 
        om.org_name, 
        od.goods_name
    ) AS tq
JOIN 
    (SELECT 
        om.org_name,
        pd.goods_name,
        COUNT(DISTINCT 
            CASE 
                WHEN pm.id_card IS NOT NULL THEN pm.id_card
                ELSE CONCAT(IFNULL(pm.contact, ''), IFNULL(pm.mobile, ''))
            END
        ) AS distinct_patient_count
     FROM 
        pres_main pm 
     JOIN 
        pres_detail pd ON pm.bill_no = pd.bill_no 
     JOIN 
        order_main om ON om.cf_bill_no = pm.bill_no 
     WHERE 
        pd.goods_id IN ('G0000285476') 
        AND om.created_at <= '2025-01-01' 
        AND om.created_at > '2023-06-01'
     GROUP BY 
        om.org_name, 
        pd.goods_name
    ) AS dp
ON 
    tq.OrgName = dp.org_name 
    AND tq.GoodsName = dp.goods_name;


SELECT 
    StoreName,
    Year,
    Month,
    CumulativeSales AS SalesNum
FROM (
    SELECT 
        am.StoreName,
        am.Year,
        am.Month,
        COALESCE(ms.SalesNum, 0) AS SalesNum,
        @running_total := @running_total + COALESCE(ms.SalesNum, 0) AS CumulativeSales
    FROM (
        SELECT 
            StoreName,
            YEAR(Date) AS Year,
            MONTH(Date) AS Month
        FROM (
            SELECT '2024-01-01' AS Date
            UNION ALL
            SELECT '2024-02-01' AS Date
            UNION ALL
            SELECT '2024-03-01' AS Date
            UNION ALL
            SELECT '2024-04-01' AS Date
            UNION ALL
            SELECT '2024-05-01' AS Date
            UNION ALL
            SELECT '2024-06-01' AS Date
            UNION ALL
            SELECT '2024-07-01' AS Date
            UNION ALL
            SELECT '2024-08-01' AS Date
            UNION ALL
            SELECT '2024-09-01' AS Date
            UNION ALL
            SELECT '2024-10-01' AS Date
            UNION ALL
            SELECT '2024-11-01' AS Date
            UNION ALL
            SELECT '2024-12-01' AS Date
            UNION ALL
            SELECT '2025-01-01' AS Date
            UNION ALL
            SELECT '2025-02-01' AS Date
            UNION ALL
            SELECT '2025-03-01' AS Date
            UNION ALL
            SELECT '2025-04-01' AS Date
            UNION ALL
            SELECT '2025-05-01' AS Date
            UNION ALL
            SELECT '2025-06-01' AS Date
            UNION ALL
            SELECT '2025-07-01' AS Date
            UNION ALL
            SELECT '2025-08-01' AS Date
            UNION ALL
            SELECT '2025-09-01' AS Date
            UNION ALL
            SELECT '2025-10-01' AS Date
            UNION ALL
            SELECT '2025-11-01' AS Date
            UNION ALL
            SELECT '2025-12-01' AS Date
        ) AS Calendar
        CROSS JOIN (
            SELECT DISTINCT om.org_name AS StoreName 
            FROM order_main om
        ) AS Stores
    ) AS am
    LEFT JOIN (
        SELECT 
            om.org_name AS StoreName,
            YEAR(om.created_at) AS Year,
            MONTH(om.created_at) AS Month,
            SUM(od.num) AS SalesNum
        FROM 
            order_main om 
        JOIN 
            order_detail od ON om.bill_no = od.bill_no
        WHERE
            om.created_at > '2023-06-01'
            AND (YEAR(om.created_at) = 2024 OR YEAR(om.created_at) = 2025)
        GROUP BY 
            om.org_name,
            YEAR(om.created_at), 
            MONTH(om.created_at)
    ) AS ms ON am.StoreName = ms.StoreName AND am.Year = ms.Year AND am.Month = ms.Month
    CROSS JOIN (SELECT @running_total := 0) AS vars
    ORDER BY 
        am.StoreName,
        am.Year, 
        am.Month
) AS result
ORDER BY 
    StoreName,
    Year, 
    Month;

SELECT 
    StoreName,
    Year,
    Month,
    CumulativeCount AS ConsumerCount
FROM (
    SELECT 
        am.StoreName,
        am.Year,
        am.Month,
        COALESCE(mcc.ConsumerCount, 0) AS ConsumerCount,
        @running_total := @running_total + COALESCE(mcc.ConsumerCount, 0) AS CumulativeCount
    FROM (
        SELECT 
            StoreName,
            YEAR(Date) AS Year,
            MONTH(Date) AS Month
        FROM (
            SELECT '2024-01-01' AS Date
            UNION ALL
            SELECT DATE_ADD(Date, INTERVAL 1 MONTH)
            FROM (
                SELECT '2024-01-01' AS Date
                UNION ALL
                SELECT '2024-02-01' AS Date
                UNION ALL
                SELECT '2024-03-01' AS Date
                UNION ALL
                SELECT '2024-04-01' AS Date
                UNION ALL
                SELECT '2024-05-01' AS Date
                UNION ALL
                SELECT '2024-06-01' AS Date
                UNION ALL
                SELECT '2024-07-01' AS Date
                UNION ALL
                SELECT '2024-08-01' AS Date
                UNION ALL
                SELECT '2024-09-01' AS Date
                UNION ALL
                SELECT '2024-10-01' AS Date
                UNION ALL
                SELECT '2024-11-01' AS Date
                UNION ALL
                SELECT '2024-12-01' AS Date
                UNION ALL
                SELECT '2025-01-01' AS Date
                UNION ALL
                SELECT '2025-02-01' AS Date
                UNION ALL
                SELECT '2025-03-01' AS Date
                UNION ALL
                SELECT '2025-04-01' AS Date
                UNION ALL
                SELECT '2025-05-01' AS Date
                UNION ALL
                SELECT '2025-06-01' AS Date
                UNION ALL
                SELECT '2025-07-01' AS Date
                UNION ALL
                SELECT '2025-08-01' AS Date
                UNION ALL
                SELECT '2025-09-01' AS Date
                UNION ALL
                SELECT '2025-10-01' AS Date
                UNION ALL
                SELECT '2025-11-01' AS Date
                UNION ALL
                SELECT '2025-12-01' AS Date
            ) AS Calendar
        ) AS Calendar
        CROSS JOIN (
            SELECT DISTINCT om.org_name AS StoreName 
            FROM order_main om
        ) AS Stores
    ) AS am
    LEFT JOIN (
        SELECT 
            om.org_name AS StoreName,
            YEAR(om.created_at) AS Year,
            MONTH(om.created_at) AS Month,
            COUNT(DISTINCT IFNULL(pm.contact, '-')) AS ConsumerCount
        FROM 
            pres_main pm 
        join pres_detail pd on pm.bill_no = pd.bill_no
        JOIN 
            order_main om ON om.cf_bill_no = pm.bill_no 
        WHERE 
            pd.goods_id IN ('G0000285476')
            and om.created_at >= '2023-06-01'
            AND om.created_at <= '2025-12-01'
        GROUP BY 
            om.org_name,
            YEAR(om.created_at), 
            MONTH(om.created_at)
    ) AS mcc ON am.StoreName = mcc.StoreName AND am.Year = mcc.Year AND am.Month = mcc.Month
    CROSS JOIN (SELECT @running_total := 0) AS vars
    ORDER BY 
        am.StoreName,
        am.Year, 
        am.Month
) AS result
ORDER BY 
    StoreName,
    Year, 
    Month;