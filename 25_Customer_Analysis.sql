USE FinSight_EDIP;
GO

/*=========================================================
1. Top 10 Customers by Revenue
=========================================================*/
SELECT TOP 10
    C.Customer_ID,
    C.Customer_Name,
    SUM(F.Transaction_Amount) AS Total_Revenue
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Customer C
    ON F.Customer_ID = C.Customer_ID
WHERE F.Transaction_Status = 'Success'
GROUP BY
    C.Customer_ID,
    C.Customer_Name
ORDER BY Total_Revenue DESC;
GO


/*=========================================================
2. Top 10 Customers by Number of Transactions
=========================================================*/
SELECT TOP 10
    C.Customer_ID,
    C.Customer_Name,
    COUNT(*) AS Total_Transactions
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Customer C
    ON F.Customer_ID = C.Customer_ID
GROUP BY
    C.Customer_ID,
    C.Customer_Name
ORDER BY Total_Transactions DESC;
GO


/*=========================================================
3. Revenue by Customer Segment
=========================================================*/
SELECT
    C.Customer_Segment,
    SUM(F.Transaction_Amount) AS Total_Revenue
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Customer C
    ON F.Customer_ID = C.Customer_ID
WHERE F.Transaction_Status = 'Success'
GROUP BY
    C.Customer_Segment
ORDER BY Total_Revenue DESC;
GO


/*=========================================================
4. Transactions by Customer Segment
=========================================================*/
SELECT
    C.Customer_Segment,
    COUNT(*) AS Total_Transactions
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Customer C
    ON F.Customer_ID = C.Customer_ID
GROUP BY
    C.Customer_Segment
ORDER BY Total_Transactions DESC;
GO


/*=========================================================
5. Average Spend Per Customer
=========================================================*/
SELECT
    C.Customer_ID,
    C.Customer_Name,
    ROUND(AVG(F.Transaction_Amount),2) AS Average_Spend
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Customer C
    ON F.Customer_ID = C.Customer_ID
WHERE F.Transaction_Status='Success'
GROUP BY
    C.Customer_ID,
    C.Customer_Name
ORDER BY Average_Spend DESC;
GO


/*=========================================================
6. Revenue by Gender
=========================================================*/
SELECT
    C.Gender,
    SUM(F.Transaction_Amount) AS Total_Revenue
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Customer C
    ON F.Customer_ID = C.Customer_ID
WHERE F.Transaction_Status='Success'
GROUP BY
    C.Gender
ORDER BY Total_Revenue DESC;
GO


/*=========================================================
7. Revenue by Occupation
=========================================================*/
SELECT
    C.Occupation,
    SUM(F.Transaction_Amount) AS Total_Revenue
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Customer C
    ON F.Customer_ID = C.Customer_ID
WHERE F.Transaction_Status='Success'
GROUP BY
    C.Occupation
ORDER BY Total_Revenue DESC;
GO


/*=========================================================
8. Revenue by State
=========================================================*/
SELECT
    C.State_Name,
    SUM(F.Transaction_Amount) AS Total_Revenue
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Customer C
    ON F.Customer_ID = C.Customer_ID
WHERE F.Transaction_Status='Success'
GROUP BY
    C.State_Name
ORDER BY Total_Revenue DESC;
GO


/*=========================================================
9. Top 10 Cities by Revenue
=========================================================*/
SELECT TOP 10
    C.City,
    SUM(F.Transaction_Amount) AS Total_Revenue
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Customer C
    ON F.Customer_ID = C.Customer_ID
WHERE F.Transaction_Status='Success'
GROUP BY
    C.City
ORDER BY Total_Revenue DESC;
GO


/*=========================================================
10. Customer-wise Success Rate
=========================================================*/
SELECT
    C.Customer_ID,
    C.Customer_Name,
    COUNT(*) AS Total_Transactions,
    SUM(CASE WHEN F.Transaction_Status='Success' THEN 1 ELSE 0 END) AS Successful_Transactions,
    ROUND(
        100.0 *
        SUM(CASE WHEN F.Transaction_Status='Success' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS Success_Rate_Percentage
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Customer C
    ON F.Customer_ID = C.Customer_ID
GROUP BY
    C.Customer_ID,
    C.Customer_Name
ORDER BY Success_Rate_Percentage DESC;
GO