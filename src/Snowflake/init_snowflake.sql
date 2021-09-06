USE ROLE SYSADMIN;
-- Create Warehouse
CREATE WAREHOUSE IF NOT EXISTS LOAD_WH
WITH WAREHOUSE_SIZE = 'SMALL'
WAREHOUSE_TYPE = 'STANDARD' 
AUTO_SUSPEND = 60 
AUTO_RESUME = TRUE;

CREATE WAREHOUSE IF NOT EXISTS PROJECT2_WH
WITH WAREHOUSE_SIZE = 'SMALL'
WAREHOUSE_TYPE = 'STANDARD' 
AUTO_SUSPEND = 60 
AUTO_RESUME = TRUE;

CREATE WAREHOUSE IF NOT EXISTS POWERBI_WH
WITH WAREHOUSE_SIZE = 'SMALL'
WAREHOUSE_TYPE = 'STANDARD' 
AUTO_SUSPEND = 60 
AUTO_RESUME = TRUE;

-- Create Database and Schema
CREATE OR REPLACE DATABASE PROJECT2;
USE DATABASE PROJECT2;

CREATE SCHEMA IF NOT EXISTS STAGE;  
CREATE SCHEMA IF NOT EXISTS NDS; 
CREATE SCHEMA IF NOT EXISTS MODEL; 

-- Create File format
USE SCHEMA STAGE;
CREATE FILE FORMAT IF NOT EXISTS STAGE.CSV_FILE 
TYPE = 'CSV' COMPRESSION = 'AUTO' FIELD_DELIMITER = ',' 
RECORD_DELIMITER = '\n' SKIP_HEADER = 0 FIELD_OPTIONALLY_ENCLOSED_BY = 'NONE' 
TRIM_SPACE = FALSE ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE ESCAPE = 'NONE' 
ESCAPE_UNENCLOSED_FIELD = '\134' DATE_FORMAT = 'AUTO' TIMESTAMP_FORMAT = 'AUTO' 
NULL_IF = ('\\N');

-- Create Table
USE SCHEMA STAGE;
CREATE TABLE Stage.Customer(
	Customer_ID int PRIMARY KEY,
	Name varchar(100) NOT NULL,
	Username varchar(50) NOT NULL,
	Sex varchar(1) NOT NULL,
	Mail varchar(100) NOT NULL,
	Birthdate Datetime NULL,
	Location_ID int NOT NULL,
	Phone varchar(50) NOT NULL,
	uuid varchar(50) NOT NULL,
	LastEditedBy nvarchar(64) NOT NULL,
	LastEditedWhen datetime NOT NULL
);

CREATE TABLE Stage.Location(
	Location_ID Int PRIMARY KEY,
	Address varchar(100) NOT NULL,
	Lat float NOT NULL,
	Long float NOT NULL,
	City varchar(50) NOT NULL,
	Country_code varchar(2) NOT NULL,
	Country_name varchar(50) NOT NULL,
	States varchar(50) NOT NULL,
	uuid varchar(50) NOT NULL,
	LastEditedBy nvarchar(64) NOT NULL,
	LastEditedWhen datetime NOT NULL
);

CREATE TABLE Stage.Product(
	Product_ID int PRIMARY KEY,
	Product_Name varchar(50) NOT NULL,
	Product_Category varchar(50) NULL,
	Product_Code int NOT NULL,
	Weight float NOT NULL,
	uuid varchar(50) NOT NULL,
	LastEditedBy nvarchar(64) NOT NULL,
	LastEditedWhen datetime NOT NULL
);

CREATE TABLE Stage.Export(
	Order_ID int PRIMARY KEY,
	Product_ID int NOT NULL,
	Customer_ID int NOT NULL,
	Quantity int NOT NULL,
	Date_Order date NOT NULL,
	Date_Ship date NOT NULL,
	Date_due date NOT NULL,
	Ship_Distance float NOT NULL,
	Ship_Cost float NOT NULL,
	uuid varchar(50) NOT NULL,
	LastEditedBy nvarchar(64) NOT NULL,
	LastEditedWhen datetime NOT NULL
);

CREATE TABLE Stage.Warehouse(
	Warehouse_ID int PRIMARY KEY,
	Warehouse_Name varchar(100) NOT NULL,
	Warehouse_cost float NOT NULL,
	Location_ID int NOT NULL,
	uuid varchar(50) NOT NULL,
	LastEditedBy nvarchar(64) NOT NULL,
	LastEditedWhen datetime NOT NULL
);

CREATE TABLE Stage.Storage(
	StorageID int PRIMARY KEY,
	Product_ID int NOT NULL,
	Warehouse_ID int NOT NULL,
	Capacity int NOT NULL,
	Quantity int NOT NULL,
	uuid varchar(50) NOT NULL,
	LastEditedBy nvarchar(64) NOT NULL,
	LastEditedWhen datetime NOT NULL
);

CREATE TABLE Stage.Supplier(
	Supplier_ID int PRIMARY KEY,
	Supplier_Name varchar(50) NOT NULL,
	Location_ID int NOT NULL,
	uuid varchar(50) NOT NULL,
	LastEditedBy nvarchar(64) NOT NULL,
	LastEditedWhen datetime NOT NULL
);

CREATE TABLE Stage.Import(
	Import_ID int PRIMARY KEY,
	Product_ID int NOT NULL,
	Warehouse_ID int NOT NULL,
	Supplier_ID int NOT NULL,
	Quantity int NOT NULL,
	Ship_Distance float NOT NULL,
	Ship_Cost float NOT NULL,
	Import_Date date NOT NULL,
	uuid varchar(50) NOT NULL,
	LastEditedBy nvarchar(64) NOT NULL,
	LastEditedWhen datetime NOT NULL
);

USE SCHEMA NDS;
CREATE TABLE NDS.Location(
	Location_ID int IDENTITY(1,1) PRIMARY KEY,
	Source_Location_ID int NOT NULL,
	Address varchar(100) NOT NULL,
	Lat float NOT NULL,
	Long float NOT NULL,
	City varchar(50) NOT NULL,
	Country_code varchar(2) NOT NULL,
	Country_name varchar(50) NOT NULL,
	States varchar(50) NOT NULL,
	uuid varchar(50) NOT NULL,
	LastEditedBy nvarchar(64) NOT NULL,
	LastEditedWhen datetime NOT NULL
);

CREATE TABLE NDS.Product(
	Product_ID int IDENTITY(1,1) PRIMARY KEY,
	Source_Product_ID int NOT NULL,
	Product_Name varchar(50) NOT NULL,
	Product_Category varchar(50) NULL,
	Product_Code int NOT NULL,
	Weight float NOT NULL,
	uuid varchar(50) NOT NULL,
	LastEditedBy nvarchar(64) NOT NULL,
	LastEditedWhen datetime NOT NULL
);

CREATE TABLE NDS.Customer(
	Customer_ID int IDENTITY(1,1) PRIMARY KEY,
	Source_Customer_ID int NOT NULL,
	Name varchar(100) NOT NULL,
	Username varchar(50) NOT NULL,
	Sex varchar(1) NOT NULL,
	Mail varchar(100) NOT NULL,
	Birthdate Datetime NULL,
	Location_ID int NOT NULL,
	Phone varchar(50) NOT NULL,
	uuid varchar(50) NOT NULL,
	LastEditedBy nvarchar(64) NOT NULL,
	LastEditedWhen datetime NOT NULL,
    FOREIGN KEY (Location_ID) REFERENCES NDS.Location(Location_ID)
);

CREATE TABLE NDS.Warehouse(
	Warehouse_ID int IDENTITY(1,1) PRIMARY KEY,
	Source_Warehouse_ID int NOT NULL,
	Warehouse_Name varchar(100) NOT NULL,
	Warehouse_cost float NOT NULL,
	Location_ID int NOT NULL,
	uuid varchar(50) NOT NULL,
	LastEditedBy nvarchar(64) NOT NULL,
	LastEditedWhen datetime NOT NULL,
    FOREIGN KEY (Location_ID) REFERENCES NDS.Location(Location_ID)
);

CREATE TABLE NDS.Storage(
	StorageID int IDENTITY(1,1) PRIMARY KEY,
	Source_StorageID int NOT NULL,
	Product_ID int NOT NULL,
	Warehouse_ID int NOT NULL,
	Capacity int NOT NULL,
	Quantity int NOT NULL,
	uuid varchar(50) NOT NULL,
	LastEditedBy nvarchar(64) NOT NULL,
	LastEditedWhen datetime NOT NULL,
    FOREIGN KEY (Product_ID) REFERENCES NDS.Product(Product_ID),
    FOREIGN KEY (Warehouse_ID) REFERENCES NDS.Warehouse(Warehouse_ID)
);

CREATE TABLE NDS.Supplier(
	Supplier_ID int IDENTITY(1,1) PRIMARY KEY,
	Source_Supplier_ID int NOT NULL,
	Supplier_Name varchar(50) NOT NULL,
	Location_ID int NOT NULL,
	uuid varchar(50) NOT NULL,
	LastEditedBy nvarchar(64) NOT NULL,
	LastEditedWhen datetime NOT NULL,
    FOREIGN KEY (Location_ID) REFERENCES NDS.Location(Location_ID)
);


CREATE TABLE NDS.Export(
	Order_ID int IDENTITY(1,1) PRIMARY KEY,
	Source_Order_ID int NOT NULL,
	Product_ID int NOT NULL,
	Customer_ID int NOT NULL,
	Quantity int NOT NULL,
	Date_Order date NOT NULL,
	Date_Ship date NOT NULL,
	Date_due date NOT NULL,
	Ship_Distance float NOT NULL,
	Ship_Cost float NOT NULL,
	uuid varchar(50) NOT NULL,
	LastEditedBy nvarchar(64) NOT NULL,
	LastEditedWhen datetime NOT NULL,
    FOREIGN KEY (Product_ID) REFERENCES NDS.Product(Product_ID),
    FOREIGN KEY (Customer_ID) REFERENCES NDS.Customer(Customer_ID)
);

CREATE TABLE NDS.Import(
	ImportID int IDENTITY(1,1) PRIMARY KEY,
	Source_Import_ID int NOT NULL,
	Product_ID int NOT NULL,
	Warehouse_ID int NOT NULL,
	Supplier_ID int NOT NULL,
	Quantity int NOT NULL,
	Ship_Distance float NOT NULL,
	Ship_Cost float NOT NULL,
	Import_Date date NOT NULL,
	uuid varchar(50) NOT NULL,
	LastEditedBy nvarchar(64) NOT NULL,
	LastEditedWhen datetime NOT NULL,
    FOREIGN KEY (Product_ID) REFERENCES NDS.Product(Product_ID),
    FOREIGN KEY (Warehouse_ID) REFERENCES NDS.Warehouse(Warehouse_ID),
    FOREIGN KEY (Supplier_ID) REFERENCES NDS.Supplier(Supplier_ID)
);

USE SCHEMA MODEL;

CREATE TABLE IF NOT EXISTS MODEL.DimDate (
    Date Date not null primary key,
    Day int not null,
    Week int not null ,
    DayOfWeek int not null,
    Month int not null,
    MonthName varchar(50) not null,
    Quarter int not null,
    Year int not null)
AS
  WITH CTE_DATE AS (
    SELECT DATEADD(DAY, SEQ4(), '2010-01-01') AS Date
      FROM TABLE(GENERATOR(ROWCOUNT=>10000))  -- Number of days after reference date in previous line
  )
  SELECT Date, DAY(Date), WEEKOFYEAR(Date), DAYOFWEEK(Date), MONTH(Date), MONTHNAME(Date), QUARTER(Date), YEAR(Date) FROM CTE_DATE;
  
CREATE TABLE IF NOT EXISTS MODEL.DimLocation (
    LocationKey int IDENTITY(1,1) PRIMARY KEY,
    Location_ID int NOT NULL,
	Lat float NOT NULL,
	Long float NOT NULL,
    Address varchar(100) NOT NULL,
	City varchar(50) NOT NULL,
	Country_code varchar(2) NOT NULL,
	Country_name varchar(50) NOT NULL,
	States varchar(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS MODEL.DimWarehouse (
	WarehouseKey int IDENTITY(1,1) PRIMARY KEY,
	Warehouse_ID int NOT NULL,
	Warehouse_Name varchar(100) NOT NULL,
	Warehouse_Cost float NOT NULL,
	Lat float NOT NULL,
	Long float NOT NULL
);

CREATE TABLE IF NOT EXISTS MODEL.DimProduct (
    ProductKey int IDENTITY(1,1) PRIMARY KEY,
	Product_ID int NOT NULL,
	Product_Name varchar(50) NOT NULL,
	Product_Category varchar(50) NULL,
	Product_Code int NOT NULL,
	Weight float NOT NULL,
    Currently int NOT NULL
);

CREATE TABLE IF NOT EXISTS MODEL.FactImport (
    ImportKey int IDENTITY(1,1) PRIMARY KEY,
    ImportDate Date NOT NULL,
    DepartureLocationKey int NOT NULL,
    ArrivalLocationKey int NOT NULL,
    WarehouseKey int NOT NULL,
    ProductKey int NOT NULL,
    Quantity int NOT NULL,
    TotalWeight float NOT NULL,
    ShipDistance float NOT NULL,
    ShipCost float NOT NULL,
    FOREIGN KEY (ImportDate) REFERENCES Model.DimDate(Date),
    FOREIGN KEY (DepartureLocationKey) REFERENCES Model.DimLocation(LocationKey),
    FOREIGN KEY (ArrivalLocationKey) REFERENCES Model.DimLocation(LocationKey),
    FOREIGN KEY (WarehouseKey) REFERENCES Model.DimWarehouse(WarehouseKey),
    FOREIGN KEY (ProductKey) REFERENCES Model.DimProduct(ProductKey)
);

CREATE TABLE IF NOT EXISTS MODEL.FactExport (
    ExportKey int IDENTITY(1,1) PRIMARY KEY,
    ExportDate Date NOT NULL,
    DepartureLocationKey int NOT NULL,
    ArrivalLocationKey int NOT NULL,
    WarehouseKey int NOT NULL,
    ProductKey int NOT NULL,
    ShipLate int NOT NULL,
    Quantity int NOT NULL,
    TotalWeight float NOT NULL,
    ShipDistance float NOT NULL,
    ShipCost float NOT NULL,
    FOREIGN KEY (ExportDate) REFERENCES Model.DimDate(Date),
    FOREIGN KEY (DepartureLocationKey) REFERENCES Model.DimLocation(LocationKey),
    FOREIGN KEY (ArrivalLocationKey) REFERENCES Model.DimLocation(LocationKey),
    FOREIGN KEY (WarehouseKey) REFERENCES Model.DimWarehouse(WarehouseKey),
    FOREIGN KEY (ProductKey) REFERENCES Model.DimProduct(ProductKey)
);