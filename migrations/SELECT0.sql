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