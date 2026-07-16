USE FinSight_EDIP;
GO

/*=========================================================
1. Monthly Revenue
=========================================================*/
SELECT
    D.Year_Number,
    D.Month_Name,
    SUM(F.Transaction_Amount) AS Total_Revenue
FROM dbo.Fact_Transactions F
JOIN dbo.Dim_Date D
    ON F.Date_ID = D.Date_ID
WHERE F.Transaction_Status = 'Success'
GROUP BY D.Year_Number, D.Month_Number, D.Month_Name
ORDER BY D.Year_Number, D.Month_Number;
GO

/*=========================================================
2. Quarterly Revenue
=========================================================*/
SELECT
    D.Year_Number,
    D.Financial_Quarter,
    SUM(F.Transaction_Amount) AS Total_Revenue
FROM dbo.Fact_Transactions F
JOIN dbo.Dim_Date D
    ON F.Date_ID = D.Date_ID
WHERE F.Transaction_Status = 'Success'
GROUP BY D.Year_Number, D.Financial_Quarter
ORDER BY D.Year_Number, D.Financial_Quarter;
GO

/*=========================================================
3. Yearly Revenue
=========================================================*/
SELECT
    D.Year_Number,
    SUM(F.Transaction_Amount) AS Total_Revenue
FROM dbo.Fact_Transactions F
JOIN dbo.Dim_Date D
    ON F.Date_ID = D.Date_ID
WHERE F.Transaction_Status = 'Success'
GROUP BY D.Year_Number
ORDER BY D.Year_Number;
GO

/*=========================================================
4. Weekday vs Weekend Revenue
=========================================================*/
SELECT
    CASE
        WHEN D.Is_Weekend = 1 THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type,
    SUM(F.Transaction_Amount) AS Revenue
FROM dbo.Fact_Transactions F
JOIN dbo.Dim_Date D
    ON F.Date_ID = D.Date_ID
WHERE F.Transaction_Status = 'Success'
GROUP BY D.Is_Weekend;
GO

/*=========================================================
5. Daily Transaction Count
=========================================================*/
SELECT
    D.Full_Date,
    COUNT(*) AS Total_Transactions
FROM dbo.Fact_Transactions F
JOIN dbo.Dim_Date D
    ON F.Date_ID = D.Date_ID
GROUP BY D.Full_Date
ORDER BY D.Full_Date;
GO

/*=========================================================
6. Top 10 Highest Revenue Days
=========================================================*/
SELECT TOP 10
    D.Full_Date,
    SUM(F.Transaction_Amount) AS Revenue
FROM dbo.Fact_Transactions F
JOIN dbo.Dim_Date D
    ON F.Date_ID = D.Date_ID
WHERE F.Transaction_Status = 'Success'
GROUP BY D.Full_Date
ORDER BY Revenue DESC;
GO