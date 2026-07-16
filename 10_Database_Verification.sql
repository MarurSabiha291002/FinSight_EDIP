USE FinSight_EDIP;
GO

SELECT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO

SELECT 
    OBJECT_NAME(parent_object_id) AS Table_Name,
    name AS Foreign_Key_Name
FROM sys.foreign_keys;
GO

SELECT 
    OBJECT_NAME(object_id) AS Table_Name,
    name AS Index_Name
FROM sys.indexes
WHERE name IS NOT NULL
ORDER BY Table_Name;

USE FinSight_EDIP;
GO

SELECT *
FROM dbo.Dim_Payment_Method;
GO

SELECT *
FROM dbo.Dim_Merchant_Category;

USE FinSight_EDIP;
GO

SELECT *
FROM dbo.Dim_Location;

SELECT COUNT(*) AS Total_Dates
FROM dbo.Dim_Date;

USE FinSight_EDIP;
GO

SELECT TOP 5 *
FROM dbo.Dim_Date
ORDER BY Full_Date;

SELECT TOP 5 *
FROM dbo.Dim_Date
ORDER BY Full_Date DESC;

USE FinSight_EDIP;
GO

SELECT TOP 5 *
FROM dbo.Dim_Customer;

USE FinSight_EDIP;
GO

SELECT COUNT(*) AS Customer_Count
FROM dbo.Dim_Customer;

USE FinSight_EDIP;
GO

sp_help 'dbo.Dim_Customer';




USE FinSight_EDIP;
GO

SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Dim_Customer'
ORDER BY ORDINAL_POSITION;

USE FinSight_EDIP;
GO

SELECT COUNT(*) AS Customer_Count
FROM dbo.Dim_Customer;



SELECT TOP 10 *
FROM dbo.Dim_Customer;





USE FinSight_EDIP;
GO

SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Dim_Merchant'
ORDER BY ORDINAL_POSITION;





USE FinSight_EDIP;
GO

DELETE FROM dbo.Dim_Merchant;
GO

SELECT COUNT(*) AS Merchant_Count
FROM dbo.Dim_Merchant;



USE FinSight_EDIP;
GO

SELECT COUNT(*) AS Merchant_Count
FROM dbo.Dim_Merchant;

SELECT TOP 10 *
FROM dbo.Dim_Merchant;


USE FinSight_EDIP;
GO

DELETE FROM dbo.Dim_Merchant;
GO

SELECT COUNT(*) AS Merchant_Count
FROM dbo.Dim_Merchant;




SELECT COUNT(*) AS Merchant_Count
FROM dbo.Dim_Merchant;

SELECT
    @@SERVERNAME AS ServerName,
    DB_NAME() AS DatabaseName;










    USE FinSight_EDIP;
GO

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Fact_Transactions'
ORDER BY ORDINAL_POSITION;








USE FinSight_EDIP;
GO

SELECT
    MIN(Date_ID) AS Min_ID,
    MAX(Date_ID) AS Max_ID,
    COUNT(*) AS Total_Rows
FROM dbo.Dim_Date;




SELECT TOP 10 *
FROM dbo.Dim_Date;











USE FinSight_EDIP;
GO

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Dim_Date'
ORDER BY ORDINAL_POSITION;




SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Dim_Merchant_Category';


SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Dim_Payment_Method';


SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Dim_Location';

SELECT *
FROM vw_Sales_Summary;

SELECT TOP 10 *
FROM vw_Customer_Performance
ORDER BY Total_Spending DESC;


SELECT TOP 10 *
FROM vw_Merchant_Performance
ORDER BY Total_Revenue DESC;


SELECT *
FROM vw_Payment_Performance
ORDER BY Total_Revenue DESC;


SELECT TOP 10 *
FROM vw_Location_Performance
ORDER BY Total_Revenue DESC;


SELECT *
FROM vw_Monthly_Revenue
ORDER BY Year_Number, Month_Number;

SELECT name
FROM sys.procedures;