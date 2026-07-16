USE FinSight_EDIP;
GO


/*=========================================================
1. Revenue by Payment Method
Business Question:
Which payment methods generate the highest revenue?
=========================================================*/

SELECT
    PM.Payment_Method_Name,
    SUM(F.Transaction_Amount) AS Total_Revenue
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Payment_Method PM
    ON F.Payment_Method_ID = PM.Payment_Method_ID
WHERE F.Transaction_Status = 'Success'
GROUP BY
    PM.Payment_Method_Name
ORDER BY
    Total_Revenue DESC;
GO


/*=========================================================
2. Transaction Count by Payment Method
=========================================================*/

SELECT
    PM.Payment_Method_Name,
    COUNT(*) AS Total_Transactions
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Payment_Method PM
    ON F.Payment_Method_ID = PM.Payment_Method_ID
GROUP BY
    PM.Payment_Method_Name
ORDER BY
    Total_Transactions DESC;
GO

/*=========================================================
3. Revenue by Payment Category
=========================================================*/

SELECT
    PM.Payment_Category,
    SUM(F.Transaction_Amount) AS Total_Revenue
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Payment_Method PM
    ON F.Payment_Method_ID = PM.Payment_Method_ID
WHERE F.Transaction_Status='Success'
GROUP BY
    PM.Payment_Category
ORDER BY
    Total_Revenue DESC;
GO


/*=========================================================
4. Payment Method Success Rate
=========================================================*/

SELECT
    PM.Payment_Method_Name,

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
    ) AS Success_Rate_Percentage

FROM dbo.Fact_Transactions F

INNER JOIN dbo.Dim_Payment_Method PM
ON F.Payment_Method_ID = PM.Payment_Method_ID

GROUP BY
    PM.Payment_Method_Name

ORDER BY
    Success_Rate_Percentage DESC;

GO


/*=========================================================
5. Failed Transactions Analysis
=========================================================*/

SELECT
    PM.Payment_Method_Name,
    COUNT(*) AS Failed_Transactions
FROM dbo.Fact_Transactions F
INNER JOIN dbo.Dim_Payment_Method PM
ON F.Payment_Method_ID = PM.Payment_Method_ID

WHERE F.Transaction_Status='Failed'

GROUP BY
    PM.Payment_Method_Name

ORDER BY
    Failed_Transactions DESC;

GO

