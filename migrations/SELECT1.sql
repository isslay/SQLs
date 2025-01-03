-- Initialize the running total variable
SET @running_total := 0;

-- Create a temporary table for the initial consumer count
CREATE TEMPORARY TABLE InitialConsumerCount AS
SELECT 
    om.org_name AS StoreName,
    2024 AS Year,
    1 AS Month,
    COUNT(DISTINCT IFNULL(pm.contact, '-')) AS ConsumerCount
FROM 
    pres_main pm 
JOIN 
    pres_detail pd ON pm.bill_no = pd.bill_no
JOIN 
    order_main om ON om.cf_bill_no = pm.bill_no 
WHERE 
    pd.goods_id IN ('G0000285476')
    AND om.dates >= '2023-06-01'
    AND om.dates <= '2024-01-31'
GROUP BY 
    om.org_name;

-- Create the main query
SELECT 
    StoreName,
    Year,
    Month,
    CumulativeConsumerCount AS ConsumerCount
FROM (
    SELECT 
        am.StoreName,
        am.Year,
        am.Month,
        COALESCE(ic.ConsumerCount, 0) + COALESCE(mcc.ConsumerCount, 0) AS ConsumerCount,
        @running_total := @running_total + COALESCE(ic.ConsumerCount, 0) + COALESCE(mcc.ConsumerCount, 0) AS CumulativeConsumerCount
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
            YEAR(om.dates) AS Year,
            MONTH(om.dates) AS Month,
            COUNT(DISTINCT IFNULL(pm.contact, '-')) AS ConsumerCount
        FROM 
            pres_main pm 
        JOIN 
            pres_detail pd ON pm.bill_no = pd.bill_no
        JOIN 
            order_main om ON om.cf_bill_no = pm.bill_no 
        WHERE 
            pd.goods_id IN ('G0000285476')
            AND om.dates >= '2023-06-01'
            AND om.dates <= '2025-12-31'
        GROUP BY 
            om.org_name,
            YEAR(om.dates), 
            MONTH(om.dates)
    ) AS mcc ON am.StoreName = mcc.StoreName AND am.Year = mcc.Year AND am.Month = mcc.Month
    LEFT JOIN InitialConsumerCount ic ON am.StoreName = ic.StoreName AND am.Year = ic.Year AND am.Month = ic.Month
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

-- Drop the temporary table
DROP TEMPORARY TABLE InitialConsumerCount;