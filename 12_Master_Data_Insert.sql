USE FinSight_EDIP;
GO

/*==============================================================
  MASTER DATA: Payment Methods
==============================================================*/

INSERT INTO dbo.Dim_Payment_Method
(
    Payment_Method_ID,
    Payment_Method_Name,
    Payment_Category
)
VALUES
(1,'UPI','Digital'),
(2,'Credit Card','Card'),
(3,'Debit Card','Card'),
(4,'Net Banking','Digital'),
(5,'Wallet','Digital'),
(6,'Cash','Offline');
GO

/*==============================================================
  MASTER DATA: Merchant Categories
==============================================================*/

INSERT INTO dbo.Dim_Merchant_Category
(
    Merchant_Category_ID,
    Category_Name,
    Category_Description
)
VALUES
(1,'Grocery','Daily household purchases'),
(2,'Electronics','Electronic devices and accessories'),
(3,'Healthcare','Medical and pharmacy transactions'),
(4,'Food & Beverage','Restaurants and food services'),
(5,'Travel','Travel and transportation services'),
(6,'Entertainment','Movies, gaming and subscriptions'),
(7,'Shopping','Retail shopping transactions');
GO

/*==============================================================
  MASTER DATA: Locations
==============================================================*/

INSERT INTO dbo.Dim_Location
(
    Location_ID,
    City,
    State_Name,
    Region,
    Zone,
    Country,
    Pincode
)
VALUES
(1,'Bengaluru','Karnataka','South','South India','India','560001'),
(2,'Hyderabad','Telangana','South','South India','India','500001'),
(3,'Chennai','Tamil Nadu','South','South India','India','600001'),
(4,'Mumbai','Maharashtra','West','West India','India','400001'),
(5,'Pune','Maharashtra','West','West India','India','411001'),
(6,'Delhi','Delhi','North','North India','India','110001'),
(7,'Kolkata','West Bengal','East','East India','India','700001'),
(8,'Ahmedabad','Gujarat','West','West India','India','380001'),
(9,'Jaipur','Rajasthan','North','North India','India','302001'),
(10,'Visakhapatnam','Andhra Pradesh','South','South India','India','530001');
GO