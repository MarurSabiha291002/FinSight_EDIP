USE FinSight_EDIP;
GO


/*=========================================================
1. Customer Transaction Report
=========================================================*/

CREATE PROCEDURE sp_Customer_Transaction_Report
    @Customer_ID INT
AS
BEGIN

SELECT

    C.Customer_ID,
    C.Customer_Name,
    D.Full_Date,
    M.Merchant_Name,
    PM.Payment_Method_Name,
    F.Transaction_Amount,
    F.Transaction_Status,
    F.Transaction_Reference

FROM dbo.Fact_Transactions F

INNER JOIN dbo.Dim_Customer C
ON F.Customer_ID=C.Customer_ID

INNER JOIN dbo.Dim_Date D
ON F.Date_ID=D.Date_ID

INNER JOIN dbo.Dim_Merchant M
ON F.Merchant_ID=M.Merchant_ID

INNER JOIN dbo.Dim_Payment_Method PM
ON F.Payment_Method_ID=PM.Payment_Method_ID

WHERE C.Customer_ID=@Customer_ID;

END;

GO



/*=========================================================
2. Merchant Performance Report
=========================================================*/

CREATE PROCEDURE sp_Merchant_Performance_Report
    @Merchant_ID INT
AS
BEGIN

SELECT

    M.Merchant_ID,

    M.Merchant_Name,

    COUNT(F.Transaction_ID) AS Total_Transactions,

    SUM(
        CASE 
            WHEN F.Transaction_Status='Success'
            THEN F.Transaction_Amount
            ELSE 0
        END
    ) AS Total_Revenue,


    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN F.Transaction_Status='Success'
                THEN 1
                ELSE 0
            END
        )
        /
        COUNT(*),
        2
    ) AS Success_Rate


FROM dbo.Fact_Transactions F

INNER JOIN dbo.Dim_Merchant M

ON F.Merchant_ID=M.Merchant_ID

WHERE M.Merchant_ID=@Merchant_ID

GROUP BY

M.Merchant_ID,
M.Merchant_Name;

END;

GO



/*=========================================================
3. Date Range Revenue Report
=========================================================*/

CREATE PROCEDURE sp_Date_Range_Revenue_Report

    @Start_Date DATE,
    @End_Date DATE

AS
BEGIN

SELECT

    COUNT(F.Transaction_ID) AS Total_Transactions,

    SUM(F.Transaction_Amount) AS Total_Revenue,

    AVG(F.Transaction_Amount) AS Average_Transaction_Value


FROM dbo.Fact_Transactions F

INNER JOIN dbo.Dim_Date D

ON F.Date_ID=D.Date_ID


WHERE 

D.Full_Date BETWEEN @Start_Date AND @End_Date

AND F.Transaction_Status='Success';


END;

GO



/*=========================================================
4. Payment Method Report
=========================================================*/

CREATE PROCEDURE sp_Payment_Method_Report

    @Payment_Method_ID INT

AS
BEGIN

SELECT

    PM.Payment_Method_Name,

    COUNT(F.Transaction_ID) AS Total_Transactions,

    SUM(F.Transaction_Amount) AS Total_Revenue


FROM dbo.Fact_Transactions F

INNER JOIN dbo.Dim_Payment_Method PM

ON F.Payment_Method_ID=PM.Payment_Method_ID


WHERE PM.Payment_Method_ID=@Payment_Method_ID


GROUP BY

PM.Payment_Method_Name;


END;

GO



/*=========================================================
5. Customer Segment Report
=========================================================*/

CREATE PROCEDURE sp_Customer_Segment_Report

    @Segment VARCHAR(20)

AS
BEGIN


SELECT *

FROM vw_Customer_Performance

WHERE Customer_Segment=@Segment;


END;

GO