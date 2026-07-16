USE FinSight_EDIP;
GO

USE FinSight_EDIP;
GO

/*==============================================================
  TABLE: Dim_Date
  PURPOSE: Stores calendar information for transaction analysis
==============================================================*/

CREATE TABLE dbo.Dim_Date
(
    Date_ID INT NOT NULL PRIMARY KEY,
    Full_Date DATE NOT NULL,
    Day_Number TINYINT NOT NULL,
    Month_Number TINYINT NOT NULL,
    Month_Name VARCHAR(20) NOT NULL,
    Quarter_Number TINYINT NOT NULL,
    Year_Number SMALLINT NOT NULL,
    Week_Number TINYINT NOT NULL,
    Day_Name VARCHAR(20) NOT NULL,
    Is_Weekend BIT NOT NULL,
    Financial_Quarter CHAR(2) NOT NULL,

    CONSTRAINT CK_Dim_Date_Day
        CHECK (Day_Number BETWEEN 1 AND 31),

    CONSTRAINT CK_Dim_Date_Month
        CHECK (Month_Number BETWEEN 1 AND 12),

    CONSTRAINT CK_Dim_Date_Quarter
        CHECK (Quarter_Number BETWEEN 1 AND 4)
);
GO

/*==============================================================
  TABLE: Dim_Location
  PURPOSE: Stores location information for analytics
==============================================================*/

CREATE TABLE dbo.Dim_Location
(
    Location_ID INT NOT NULL PRIMARY KEY,
    City VARCHAR(50) NOT NULL,
    State_Name VARCHAR(50) NOT NULL,
    Region VARCHAR(30) NOT NULL,
    Zone VARCHAR(20) NOT NULL,
    Country VARCHAR(30) NOT NULL DEFAULT 'India',
    Pincode CHAR(6) NOT NULL,

    CONSTRAINT UQ_Dim_Location
        UNIQUE (City, State_Name, Pincode)
);
GO

/*==============================================================
  TABLE: Dim_Payment_Method
  PURPOSE: Stores payment method information
==============================================================*/

CREATE TABLE dbo.Dim_Payment_Method
(
    Payment_Method_ID INT NOT NULL PRIMARY KEY,
    Payment_Method_Name VARCHAR(50) NOT NULL,
    Payment_Category VARCHAR(30) NOT NULL,

    CONSTRAINT UQ_Payment_Method_Name
        UNIQUE (Payment_Method_Name)
);
GO

/*==============================================================
  TABLE: Dim_Merchant_Category
  PURPOSE: Stores merchant category information
==============================================================*/

CREATE TABLE dbo.Dim_Merchant_Category
(
    Merchant_Category_ID INT NOT NULL PRIMARY KEY,
    Category_Name VARCHAR(50) NOT NULL,
    Category_Description VARCHAR(200) NULL,

    CONSTRAINT UQ_Merchant_Category_Name
        UNIQUE (Category_Name)
);
GO

/*==============================================================
  TABLE: Dim_Customer
  PURPOSE: Stores customer master information
==============================================================*/

CREATE TABLE dbo.Dim_Customer
(
    Customer_ID INT NOT NULL PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    Gender CHAR(1) NOT NULL,
    Date_of_Birth DATE NOT NULL,
    Mobile_Number VARCHAR(15) NOT NULL,
    Email_ID VARCHAR(100) NULL,
    Occupation VARCHAR(50) NULL,
    City VARCHAR(50) NOT NULL,
    State_Name VARCHAR(50) NOT NULL,
    Customer_Segment VARCHAR(30) NOT NULL,

    CONSTRAINT UQ_Customer_Mobile
        UNIQUE (Mobile_Number),

    CONSTRAINT UQ_Customer_Email
        UNIQUE (Email_ID),

    CONSTRAINT CK_Customer_Gender
        CHECK (Gender IN ('M','F','O')),

    CONSTRAINT CK_Customer_Segment
        CHECK (Customer_Segment IN ('Regular','Premium','VIP'))
);
GO

/*==============================================================
  TABLE: Dim_Merchant
  PURPOSE: Stores merchant master information
==============================================================*/

CREATE TABLE dbo.Dim_Merchant
(
    Merchant_ID INT NOT NULL PRIMARY KEY,
    Merchant_Name VARCHAR(100) NOT NULL,
    Merchant_Category_ID INT NOT NULL,
    Location_ID INT NOT NULL,
    GST_Number VARCHAR(20) NULL,

    CONSTRAINT UQ_Merchant_GST
        UNIQUE (GST_Number),

    CONSTRAINT FK_Merchant_Category
        FOREIGN KEY (Merchant_Category_ID)
        REFERENCES dbo.Dim_Merchant_Category(Merchant_Category_ID),

    CONSTRAINT FK_Merchant_Location
        FOREIGN KEY (Location_ID)
        REFERENCES dbo.Dim_Location(Location_ID)
);
GO

/*==============================================================
  TABLE: Fact_Transactions
  PURPOSE: Stores all digital payment transactions
==============================================================*/

CREATE TABLE dbo.Fact_Transactions
(
    Transaction_ID BIGINT NOT NULL PRIMARY KEY,

    Date_ID INT NOT NULL,
    Customer_ID INT NOT NULL,
    Merchant_ID INT NOT NULL,
    Payment_Method_ID INT NOT NULL,
    Location_ID INT NOT NULL,

    Transaction_Amount DECIMAL(12,2) NOT NULL,
    Transaction_Status VARCHAR(20) NOT NULL,
    Transaction_Reference VARCHAR(50) NOT NULL,

    CONSTRAINT CK_Transaction_Amount
        CHECK (Transaction_Amount > 0),

    CONSTRAINT CK_Transaction_Status
        CHECK (Transaction_Status IN 
        ('SUCCESS','FAILED','PENDING','REFUNDED')),

    CONSTRAINT UQ_Transaction_Reference
        UNIQUE (Transaction_Reference),

    CONSTRAINT FK_Transaction_Date
        FOREIGN KEY (Date_ID)
        REFERENCES dbo.Dim_Date(Date_ID),

    CONSTRAINT FK_Transaction_Customer
        FOREIGN KEY (Customer_ID)
        REFERENCES dbo.Dim_Customer(Customer_ID),

    CONSTRAINT FK_Transaction_Merchant
        FOREIGN KEY (Merchant_ID)
        REFERENCES dbo.Dim_Merchant(Merchant_ID),

    CONSTRAINT FK_Transaction_Payment
        FOREIGN KEY (Payment_Method_ID)
        REFERENCES dbo.Dim_Payment_Method(Payment_Method_ID),

    CONSTRAINT FK_Transaction_Location
        FOREIGN KEY (Location_ID)
        REFERENCES dbo.Dim_Location(Location_ID)
);
GO