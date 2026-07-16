USE FinSight_EDIP;
GO


/*=========================================================
1. Revenue by State
Business Question:
Which states generate the highest revenue?
=========================================================*/

SELECT
    L.State_Name,
    SUM(F.Transaction_Amount) AS Total_Revenue
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Location L
    ON F.Location_ID = L.Location_ID
WHERE F.Transaction_Status='Success'
GROUP BY
    L.State_Name
ORDER BY
    Total_Revenue DESC;
GO



/*=========================================================
2. Transaction Count by State
Business Question:
Which states have the highest transaction activity?
=========================================================*/

SELECT
    L.State_Name,
    COUNT(*) AS Total_Transactions
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Location L
    ON F.Location_ID = L.Location_ID
GROUP BY
    L.State_Name
ORDER BY
    Total_Transactions DESC;
GO



/*=========================================================
3. Revenue by City
Business Question:
Which cities contribute maximum revenue?
=========================================================*/

SELECT TOP 10
    L.City,
    SUM(F.Transaction_Amount) AS Total_Revenue
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Location L
    ON F.Location_ID = L.Location_ID
WHERE F.Transaction_Status='Success'
GROUP BY
    L.City
ORDER BY
    Total_Revenue DESC;
GO



/*=========================================================
4. Transactions by City
=========================================================*/

SELECT TOP 10
    L.City,
    COUNT(*) AS Total_Transactions
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Location L
    ON F.Location_ID = L.Location_ID
GROUP BY
    L.City
ORDER BY
    Total_Transactions DESC;
GO



/*=========================================================
5. Revenue by Region
Business Question:
Which regions perform better?
=========================================================*/

SELECT
    L.Region,
    SUM(F.Transaction_Amount) AS Total_Revenue
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Location L
    ON F.Location_ID = L.Location_ID
WHERE F.Transaction_Status='Success'
GROUP BY
    L.Region
ORDER BY
    Total_Revenue DESC;
GO



/*=========================================================
6. Revenue by Zone
=========================================================*/

SELECT
    L.Zone,
    SUM(F.Transaction_Amount) AS Total_Revenue
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Location L
    ON F.Location_ID=L.Location_ID
WHERE F.Transaction_Status='Success'
GROUP BY
    L.Zone
ORDER BY
    Total_Revenue DESC;
GO



/*=========================================================
7. Country-wise Revenue
=========================================================*/

SELECT
    L.Country,
    SUM(F.Transaction_Amount) AS Total_Revenue
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Location L
    ON F.Location_ID=L.Location_ID
WHERE F.Transaction_Status='Success'
GROUP BY
    L.Country
ORDER BY
    Total_Revenue DESC;
GO



/*=========================================================
8. Location Success Rate
=========================================================*/

SELECT
    L.City,

    COUNT(*) AS Total_Transactions,

    SUM(
        CASE 
            WHEN F.Transaction_Status='Success'
            THEN 1 ELSE 0
        END
    ) AS Successful_Transactions,

    ROUND(
        100.0 *
        SUM(
            CASE 
                WHEN F.Transaction_Status='Success'
                THEN 1 ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS Success_Rate

FROM dbo.Fact_Transactions F

INNER JOIN dbo.Dim_Location L
ON F.Location_ID=L.Location_ID

GROUP BY
    L.City

ORDER BY
    Success_Rate DESC;
GO



/*=========================================================
9. Top Performing Locations
=========================================================*/

SELECT TOP 10

    L.City,
    L.State_Name,

    SUM(F.Transaction_Amount) AS Revenue

FROM dbo.Fact_Transactions F

INNER JOIN dbo.Dim_Location L
ON F.Location_ID=L.Location_ID

WHERE F.Transaction_Status='Success'

GROUP BY
    L.City,
    L.State_Name

ORDER BY
    Revenue DESC;

GO



/*=========================================================
10. Revenue Contribution Percentage by State
=========================================================*/

SELECT

    L.State_Name,

    SUM(F.Transaction_Amount) AS Revenue,

    ROUND(
        100.0 *
        SUM(F.Transaction_Amount)
        /
        SUM(SUM(F.Transaction_Amount)) OVER(),
        2
    ) AS Revenue_Percentage

FROM dbo.Fact_Transactions F

INNER JOIN dbo.Dim_Location L
ON F.Location_ID=L.Location_ID

WHERE F.Transaction_Status='Success'

GROUP BY
    L.State_Name

ORDER BY
    Revenue_Percentage DESC;

GO