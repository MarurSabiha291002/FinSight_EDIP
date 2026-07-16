USE FinSight_EDIP;
GO

/*=========================================================
1. Total Revenue
=========================================================*/
SELECT
    SUM(Transaction_Amount) AS Total_Revenue
FROM dbo.Fact_Transactions
WHERE Transaction_Status='Success';
GO

/*=========================================================
2. Total Transactions
=========================================================*/
SELECT
    COUNT(*) AS Total_Transactions
FROM dbo.Fact_Transactions;
GO

/*=========================================================
3. Successful Transactions
=========================================================*/
SELECT
    COUNT(*) AS Successful_Transactions
FROM dbo.Fact_Transactions
WHERE Transaction_Status='Success';
GO

/*=========================================================
4. Failed Transactions
=========================================================*/
SELECT
    COUNT(*) AS Failed_Transactions
FROM dbo.Fact_Transactions
WHERE Transaction_Status='Failed';
GO

/*=========================================================
5. Refunded Transactions
=========================================================*/
SELECT
    COUNT(*) AS Refunded_Transactions
FROM dbo.Fact_Transactions
WHERE Transaction_Status='Refunded';
GO

/*=========================================================
6. Average Transaction Amount
=========================================================*/
SELECT
    ROUND(AVG(Transaction_Amount),2) AS Average_Transaction_Value
FROM dbo.Fact_Transactions
WHERE Transaction_Status='Success';
GO

/*=========================================================
7. Highest Transaction
=========================================================*/
SELECT
    MAX(Transaction_Amount) AS Highest_Transaction
FROM dbo.Fact_Transactions;
GO

/*=========================================================
8. Lowest Transaction
=========================================================*/
SELECT
    MIN(Transaction_Amount) AS Lowest_Transaction
FROM dbo.Fact_Transactions;
GO