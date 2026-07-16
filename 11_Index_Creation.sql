USE FinSight_EDIP;
GO

/*==============================================================
  INDEXES: Dim_Merchant
==============================================================*/

CREATE INDEX IX_Dim_Merchant_Category_ID
ON dbo.Dim_Merchant(Merchant_Category_ID);
GO


CREATE INDEX IX_Dim_Merchant_Location_ID
ON dbo.Dim_Merchant(Location_ID);
GO


/*==============================================================
  INDEXES: Fact_Transactions
==============================================================*/

CREATE INDEX IX_Fact_Transactions_Date_ID
ON dbo.Fact_Transactions(Date_ID);
GO


CREATE INDEX IX_Fact_Transactions_Customer_ID
ON dbo.Fact_Transactions(Customer_ID);
GO


CREATE INDEX IX_Fact_Transactions_Merchant_ID
ON dbo.Fact_Transactions(Merchant_ID);
GO


CREATE INDEX IX_Fact_Transactions_Payment_Method_ID
ON dbo.Fact_Transactions(Payment_Method_ID);
GO


CREATE INDEX IX_Fact_Transactions_Location_ID
ON dbo.Fact_Transactions(Location_ID);
GO


CREATE INDEX IX_Fact_Transactions_Status
ON dbo.Fact_Transactions(Transaction_Status);
GO