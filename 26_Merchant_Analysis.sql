USE FinSight_EDIP;
GO

/*=========================================================
1. Top 10 Merchants by Revenue
=========================================================*/

SELECT TOP 10
    M.Merchant_ID,
    M.Merchant_Name,
    SUM(F.Transaction_Amount) AS Total_Revenue
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Merchant M
    ON F.Merchant_ID = M.Merchant_ID
WHERE F.Transaction_Status = 'Success'
GROUP BY
    M.Merchant_ID,
    M.Merchant_Name
ORDER BY Total_Revenue DESC;
GO




/*=========================================================
2. Top 10 Merchants by Transactions
=========================================================*/

SELECT TOP 10
    M.Merchant_ID,
    M.Merchant_Name,
    COUNT(*) AS Total_Transactions
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Merchant M
    ON F.Merchant_ID = M.Merchant_ID
GROUP BY
    M.Merchant_ID,
    M.Merchant_Name
ORDER BY Total_Transactions DESC;
GO


/*=========================================================
3. Revenue by Merchant Category
=========================================================*/

SELECT
    MC.Category_Name,
    SUM(F.Transaction_Amount) AS Total_Revenue
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Merchant M
    ON F.Merchant_ID = M.Merchant_ID
INNER JOIN dbo.Dim_Merchant_Category MC
    ON M.Merchant_Category_ID = MC.Merchant_Category_ID
WHERE F.Transaction_Status='Success'
GROUP BY
    MC.Category_Name
ORDER BY
    Total_Revenue DESC;
GO


/*=========================================================
4. Transactions by Merchant Category
=========================================================*/

SELECT
    MC.Category_Name,
    COUNT(*) AS Total_Transactions
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Merchant M
    ON F.Merchant_ID = M.Merchant_ID
INNER JOIN dbo.Dim_Merchant_Category MC
    ON M.Merchant_Category_ID = MC.Merchant_Category_ID
GROUP BY
    MC.Category_Name
ORDER BY
    Total_Transactions DESC;
GO


/*=========================================================
5. Average Transaction Amount by Merchant
=========================================================*/

SELECT
    M.Merchant_Name,
    ROUND(AVG(F.Transaction_Amount),2) AS Average_Transaction
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Merchant M
    ON F.Merchant_ID=M.Merchant_ID
WHERE F.Transaction_Status='Success'
GROUP BY
    M.Merchant_Name
ORDER BY
    Average_Transaction DESC;
GO


/*=========================================================
6. Merchant Success Rate
=========================================================*/

SELECT
    M.Merchant_Name,
    COUNT(*) AS Total_Transactions,
    SUM(CASE WHEN F.Transaction_Status='Success' THEN 1 ELSE 0 END) AS Successful_Transactions,
    ROUND(
        100.0*
        SUM(CASE WHEN F.Transaction_Status='Success' THEN 1 ELSE 0 END)
        /COUNT(*),2
    ) AS Success_Rate
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Merchant M
ON F.Merchant_ID=M.Merchant_ID
GROUP BY
    M.Merchant_Name
ORDER BY
    Success_Rate DESC;
GO


/*=========================================================
7. Failed Transactions by Merchant
=========================================================*/

SELECT
    M.Merchant_Name,
    COUNT(*) AS Failed_Transactions
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Merchant M
ON F.Merchant_ID=M.Merchant_ID
WHERE F.Transaction_Status='Failed'
GROUP BY
    M.Merchant_Name
ORDER BY
    Failed_Transactions DESC;
GO


/*=========================================================
9. Merchant Revenue Ranking
=========================================================*/

SELECT
    RANK() OVER(
        ORDER BY SUM(F.Transaction_Amount) DESC
    ) AS Merchant_Rank,

    M.Merchant_Name,

    SUM(F.Transaction_Amount) AS Revenue

FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Merchant M
ON F.Merchant_ID=M.Merchant_ID

WHERE F.Transaction_Status='Success'

GROUP BY
    M.Merchant_Name;
GO



/*=========================================================
10. Top Merchant Categories
=========================================================*/

SELECT TOP 5
    MC.Category_Name,
    SUM(F.Transaction_Amount) AS Revenue
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Merchant M
ON F.Merchant_ID=M.Merchant_ID
INNER JOIN dbo.Dim_Merchant_Category MC
ON M.Merchant_Category_ID=MC.Merchant_Category_ID
WHERE F.Transaction_Status='Success'
GROUP BY
    MC.Category_Name
ORDER BY
    Revenue DESC;
GO