USE FinSight_EDIP;
GO


/*=========================================================
VIEW 1 : Sales Summary View
=========================================================*/


CREATE VIEW vw_Sales_Summary
AS

SELECT

    COUNT(F.Transaction_ID) AS Total_Transactions,


    SUM(
        CASE 
            WHEN F.Transaction_Status='Success'
            THEN F.Transaction_Amount
            ELSE 0
        END
    ) AS Total_Revenue,


    AVG(F.Transaction_Amount) AS Average_Transaction_Value,


    SUM(
        CASE
            WHEN F.Transaction_Status='Success'
            THEN 1
            ELSE 0
        END
    ) AS Successful_Transactions,


    SUM(
        CASE
            WHEN F.Transaction_Status='Failed'
            THEN 1
            ELSE 0
        END
    ) AS Failed_Transactions


FROM dbo.Fact_Transactions F;

GO

/*=========================================================
VIEW 2 : Customer Performance View
=========================================================*/


CREATE VIEW vw_Customer_Performance
AS

SELECT

    C.Customer_ID,

    C.Customer_Name,

    C.Gender,

    C.Occupation,

    C.City,

    C.State_Name,


    COUNT(F.Transaction_ID) AS Total_Transactions,


    SUM(
        CASE
            WHEN F.Transaction_Status='Success'
            THEN F.Transaction_Amount
            ELSE 0
        END
    ) AS Total_Spending,


    AVG(
        CASE
            WHEN F.Transaction_Status='Success'
            THEN F.Transaction_Amount
        END
    ) AS Average_Transaction_Value,


    CASE

        WHEN SUM(
            CASE
                WHEN F.Transaction_Status='Success'
                THEN F.Transaction_Amount
                ELSE 0
            END
        ) >= 100000
        THEN 'Premium'


        WHEN SUM(
            CASE
                WHEN F.Transaction_Status='Success'
                THEN F.Transaction_Amount
                ELSE 0
            END
        ) >= 50000
        THEN 'Regular'


        ELSE 'Low Value'

    END AS Customer_Segment


FROM dbo.Dim_Customer C

LEFT JOIN dbo.Fact_Transactions F

ON C.Customer_ID = F.Customer_ID


GROUP BY

    C.Customer_ID,

    C.Customer_Name,

    C.Gender,

    C.Occupation,

    C.City,

    C.State_Name;

GO


/*=========================================================
VIEW 3 : Merchant Performance View
=========================================================*/


CREATE VIEW vw_Merchant_Performance
AS

SELECT

    M.Merchant_ID,

    M.Merchant_Name,

    MC.Category_Name,


    COUNT(F.Transaction_ID) AS Total_Transactions,


    SUM(
        CASE
            WHEN F.Transaction_Status='Success'
            THEN F.Transaction_Amount
            ELSE 0
        END
    ) AS Total_Revenue,


    AVG(
        CASE
            WHEN F.Transaction_Status='Success'
            THEN F.Transaction_Amount
        END
    ) AS Average_Transaction_Value,


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
        COUNT(F.Transaction_ID),
        2
    ) AS Success_Rate


FROM dbo.Dim_Merchant M

LEFT JOIN dbo.Fact_Transactions F

ON M.Merchant_ID = F.Merchant_ID


LEFT JOIN dbo.Dim_Merchant_Category MC

ON M.Merchant_Category_ID = MC.Merchant_Category_ID


GROUP BY

    M.Merchant_ID,

    M.Merchant_Name,

    MC.Category_Name;

GO


/*=========================================================
VIEW 4 : Payment Performance View
=========================================================*/


CREATE VIEW vw_Payment_Performance
AS

SELECT

    PM.Payment_Method_ID,

    PM.Payment_Method_Name,

    PM.Payment_Category,


    COUNT(F.Transaction_ID) AS Total_Transactions,


    SUM(
        CASE
            WHEN F.Transaction_Status='Success'
            THEN F.Transaction_Amount
            ELSE 0
        END
    ) AS Total_Revenue,


    AVG(
        CASE
            WHEN F.Transaction_Status='Success'
            THEN F.Transaction_Amount
        END
    ) AS Average_Transaction_Value,


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
        COUNT(F.Transaction_ID),
        2
    ) AS Success_Rate


FROM dbo.Dim_Payment_Method PM


LEFT JOIN dbo.Fact_Transactions F

ON PM.Payment_Method_ID = F.Payment_Method_ID


GROUP BY

    PM.Payment_Method_ID,

    PM.Payment_Method_Name,

    PM.Payment_Category;

GO


/*=========================================================
VIEW 5 : Location Performance View
=========================================================*/


CREATE VIEW vw_Location_Performance
AS

SELECT

    L.Location_ID,

    L.City,

    L.State_Name,

    L.Region,

    L.Zone,

    L.Country,


    COUNT(F.Transaction_ID) AS Total_Transactions,


    SUM(
        CASE
            WHEN F.Transaction_Status='Success'
            THEN F.Transaction_Amount
            ELSE 0
        END
    ) AS Total_Revenue,


    AVG(
        CASE
            WHEN F.Transaction_Status='Success'
            THEN F.Transaction_Amount
        END
    ) AS Average_Transaction_Value,


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
        COUNT(F.Transaction_ID),
        2
    ) AS Success_Rate


FROM dbo.Dim_Location L


LEFT JOIN dbo.Fact_Transactions F

ON L.Location_ID = F.Location_ID


GROUP BY

    L.Location_ID,

    L.City,

    L.State_Name,

    L.Region,

    L.Zone,

    L.Country;

GO


/*=========================================================
VIEW 6 : Monthly Revenue View
=========================================================*/


CREATE VIEW vw_Monthly_Revenue
AS

SELECT

    D.Year_Number,

    D.Month_Number,

    D.Month_Name,

    D.Financial_Quarter,


    COUNT(F.Transaction_ID) AS Total_Transactions,


    SUM(
        CASE
            WHEN F.Transaction_Status='Success'
            THEN F.Transaction_Amount
            ELSE 0
        END
    ) AS Total_Revenue,


    AVG(
        CASE
            WHEN F.Transaction_Status='Success'
            THEN F.Transaction_Amount
        END
    ) AS Average_Transaction_Value


FROM dbo.Dim_Date D


LEFT JOIN dbo.Fact_Transactions F

ON D.Date_ID = F.Date_ID


GROUP BY

    D.Year_Number,

    D.Month_Number,

    D.Month_Name,

    D.Financial_Quarter;

GO