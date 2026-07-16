USE FinSight_EDIP;
GO

/*==============================================================
  MASTER DATA: Date Dimension
  PURPOSE: Calendar table for analytics
==============================================================*/

DECLARE @StartDate DATE = '2024-01-01';
DECLARE @EndDate DATE = '2026-12-31';

WHILE @StartDate <= @EndDate
BEGIN

    INSERT INTO dbo.Dim_Date
    (
        Date_ID,
        Full_Date,
        Day_Number,
        Month_Number,
        Month_Name,
        Quarter_Number,
        Year_Number,
        Week_Number,
        Day_Name,
        Is_Weekend,
        Financial_Quarter
    )
    VALUES
    (
        CONVERT(INT, FORMAT(@StartDate,'yyyyMMdd')),
        @StartDate,
        DAY(@StartDate),
        MONTH(@StartDate),
        DATENAME(MONTH,@StartDate),
        DATEPART(QUARTER,@StartDate),
        YEAR(@StartDate),
        DATEPART(WEEK,@StartDate),
        DATENAME(WEEKDAY,@StartDate),
        CASE 
            WHEN DATEPART(WEEKDAY,@StartDate) IN (1,7)
            THEN 1
            ELSE 0
        END,
        'Q' + CAST(DATEPART(QUARTER,@StartDate) AS VARCHAR)
    );

    SET @StartDate = DATEADD(DAY,1,@StartDate);

END;
GO