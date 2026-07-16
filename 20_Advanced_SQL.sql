USE FinSight_EDIP;
GO


/*=========================================================
1. Customer Revenue Ranking
=========================================================*/

SELECT

    C.Customer_ID,
    C.Customer_Name,

    SUM(F.Transaction_Amount) AS Total_Revenue,

    RANK() OVER(
        ORDER BY SUM(F.Transaction_Amount) DESC
    ) AS Revenue_Rank

FROM dbo.Fact_Transactions F

INNER JOIN dbo.Dim_Customer C
ON F.Customer_ID = C.Customer_ID

WHERE F.Transaction_Status='Success'

GROUP BY
    C.Customer_ID,
    C.Customer_Name

ORDER BY
    Revenue_Rank;

GO


/*=========================================================
2. Running Revenue Total
=========================================================*/

WITH Customer_Revenue AS
(
    SELECT

        C.Customer_Name,

        SUM(F.Transaction_Amount) AS Revenue

    FROM dbo.Fact_Transactions F

    INNER JOIN dbo.Dim_Customer C
    ON F.Customer_ID=C.Customer_ID

    WHERE F.Transaction_Status='Success'

    GROUP BY
        C.Customer_Name
)

SELECT

    Customer_Name,

    Revenue,

    SUM(Revenue) OVER(
        ORDER BY Revenue DESC
    ) AS Running_Total_Revenue

FROM Customer_Revenue

ORDER BY Revenue DESC;

GO


/*=========================================================
3. Repeat Customers
=========================================================*/

SELECT

    C.Customer_ID,

    C.Customer_Name,

    COUNT(F.Transaction_ID) AS Transaction_Count

FROM dbo.Fact_Transactions F

INNER JOIN dbo.Dim_Customer C

ON F.Customer_ID=C.Customer_ID

GROUP BY

    C.Customer_ID,
    C.Customer_Name

HAVING COUNT(F.Transaction_ID)>1

ORDER BY Transaction_Count DESC;

GO


/*=========================================================
4. Customer Lifetime Value
=========================================================*/

SELECT

    C.Customer_ID,

    C.Customer_Name,

    COUNT(F.Transaction_ID) AS Total_Transactions,

    SUM(F.Transaction_Amount) AS Lifetime_Value

FROM dbo.Fact_Transactions F

INNER JOIN dbo.Dim_Customer C

ON F.Customer_ID=C.Customer_ID

WHERE F.Transaction_Status='Success'

GROUP BY

    C.Customer_ID,
    C.Customer_Name

ORDER BY Lifetime_Value DESC;

GO


/*=========================================================
5. Monthly Revenue Trend
=========================================================*/

SELECT

    D.Year_Number,

    D.Month_Number,

    D.Month_Name,

    SUM(F.Transaction_Amount) AS Monthly_Revenue

FROM dbo.Fact_Transactions F

INNER JOIN dbo.Dim_Date D

ON F.Date_ID = D.Date_ID

WHERE F.Transaction_Status='Success'

GROUP BY

    D.Year_Number,
    D.Month_Number,
    D.Month_Name

ORDER BY

    D.Year_Number,
    D.Month_Number;

GO


/*=========================================================
6. Month-over-Month Revenue Growth
=========================================================*/

WITH Monthly_Revenue AS
(
    SELECT

        D.Year_Number,

        D.Month_Number,

        SUM(F.Transaction_Amount) AS Revenue

    FROM dbo.Fact_Transactions F

    INNER JOIN dbo.Dim_Date D

    ON F.Date_ID=D.Date_ID

    WHERE F.Transaction_Status='Success'

    GROUP BY

        D.Year_Number,
        D.Month_Number
)

SELECT

    Year_Number,

    Month_Number,

    Revenue,

    LAG(Revenue) OVER(
        ORDER BY Year_Number, Month_Number
    ) AS Previous_Month_Revenue,


    Revenue -
    LAG(Revenue) OVER(
        ORDER BY Year_Number, Month_Number
    ) AS Revenue_Growth


FROM Monthly_Revenue;

GO


/*=========================================================
7. Quarterly Revenue Analysis
=========================================================*/

SELECT

    D.Year_Number,

    D.Financial_Quarter,

    SUM(F.Transaction_Amount) AS Quarter_Revenue

FROM dbo.Fact_Transactions F

INNER JOIN dbo.Dim_Date D

ON F.Date_ID=D.Date_ID

WHERE F.Transaction_Status='Success'

GROUP BY

    D.Year_Number,
    D.Financial_Quarter

ORDER BY

    Year_Number,
    Quarter_Revenue DESC;

GO


/*=========================================================
8. Merchant Revenue Ranking
=========================================================*/

SELECT

    M.Merchant_Name,

    SUM(F.Transaction_Amount) AS Revenue,

    DENSE_RANK() OVER(
        ORDER BY SUM(F.Transaction_Amount) DESC
    ) AS Merchant_Rank


FROM dbo.Fact_Transactions F

INNER JOIN dbo.Dim_Merchant M

ON F.Merchant_ID=M.Merchant_ID


WHERE F.Transaction_Status='Success'


GROUP BY

    M.Merchant_Name

ORDER BY Merchant_Rank;

GO


/*=========================================================
9. Customer Segmentation
=========================================================*/

WITH Customer_Value AS
(
    SELECT

        C.Customer_ID,

        C.Customer_Name,

        SUM(F.Transaction_Amount) AS Total_Spend

    FROM dbo.Fact_Transactions F

    INNER JOIN dbo.Dim_Customer C

    ON F.Customer_ID=C.Customer_ID

    WHERE F.Transaction_Status='Success'

    GROUP BY

        C.Customer_ID,
        C.Customer_Name
)

SELECT

    Customer_ID,

    Customer_Name,

    Total_Spend,

    CASE

        WHEN Total_Spend >= 100000
            THEN 'Premium'

        WHEN Total_Spend >= 50000
            THEN 'Regular'

        ELSE 'Low Value'

    END AS Customer_Segment

FROM Customer_Value

ORDER BY Total_Spend DESC;

GO

/*=========================================================
10. High Value Customers
=========================================================*/

SELECT TOP 20

    C.Customer_ID,

    C.Customer_Name,

    SUM(F.Transaction_Amount) AS Total_Spend


FROM dbo.Fact_Transactions F

INNER JOIN dbo.Dim_Customer C

ON F.Customer_ID=C.Customer_ID


WHERE F.Transaction_Status='Success'


GROUP BY

    C.Customer_ID,

    C.Customer_Name


ORDER BY Total_Spend DESC;

GO


/*=========================================================
11. Customer Revenue Contribution
=========================================================*/

WITH Customer_Revenue AS
(
    SELECT

        C.Customer_Name,

        SUM(F.Transaction_Amount) AS Revenue

    FROM dbo.Fact_Transactions F

    INNER JOIN dbo.Dim_Customer C

    ON F.Customer_ID=C.Customer_ID


    WHERE F.Transaction_Status='Success'


    GROUP BY

        C.Customer_Name
)


SELECT

    Customer_Name,

    Revenue,

    SUM(Revenue) OVER(
        ORDER BY Revenue DESC
    ) AS Running_Revenue,


    ROUND(

        100.0 *

        SUM(Revenue) OVER(
            ORDER BY Revenue DESC
        )

        /

        SUM(Revenue) OVER(),

        2

    ) AS Cumulative_Percentage


FROM Customer_Revenue

ORDER BY Revenue DESC;

GO


/*=========================================================
12. Failed Transaction Analysis
=========================================================*/

SELECT

    F.Transaction_Status,

    COUNT(*) AS Total_Count,

    SUM(F.Transaction_Amount) AS Amount


FROM dbo.Fact_Transactions F


GROUP BY

    F.Transaction_Status;

GO