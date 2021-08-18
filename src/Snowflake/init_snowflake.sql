CREATE DATABASE IF NOT EXISTS  PROJECT1;
CREATE WAREHOUSE IF NOT EXISTS STAGE
WITH WAREHOUSE_SIZE = 'MEDIUM'
WAREHOUSE_TYPE = 'STANDARD' 
AUTO_SUSPEND = 600 
AUTO_RESUME = TRUE;
Create Schema IF NOT EXISTS  STAGE;  
Create Schema IF NOT EXISTS  NDS; 
Create Schema IF NOT EXISTS  MODEL; 

 

CREATE FILE FORMAT IF NOT EXISTS "PROJECT1"."STAGE".CSV_FILE 
TYPE = 'CSV' COMPRESSION = 'AUTO' FIELD_DELIMITER = ',' 
RECORD_DELIMITER = '\n' SKIP_HEADER = 0 FIELD_OPTIONALLY_ENCLOSED_BY = 'NONE' 
TRIM_SPACE = FALSE ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE ESCAPE = 'NONE' 
ESCAPE_UNENCLOSED_FIELD = '\134' DATE_FORMAT = 'AUTO' TIMESTAMP_FORMAT = 'AUTO' 
NULL_IF = ('\\N');

 


USE ROLE SYSADMIN;
USE DATABASE PROJECT1;   
USE WAREHOUSE STAGE;
USE SCHEMA STAGE;
select CURRENT_DATABASE(), CURRENT_SCHEMA(), CURRENT_WAREHOUSE();

 


  

 

--Schema stage--
--Schema stage--
--Schema stage--

 

 

CREATE TABLE IF NOT EXISTS STAGE.Datetime (
    TheDate Date not null primary key,
    TheDay  int not null,
    TheDayName  varchar(20) not null,
    TheWeek  int not null ,
    TheISOWeek int not null,
    TheDayOfWeek  int not null,
    TheMonth        int not null,
    TheMonthName    varchar(20) not null,
    TheQuarter      int not null,
    TheYear         int not null,
    TheFirstOfMonth date not null,
    TheLastOfYear   date not null,
    TheDayOfYear   int not null);

 

/****** Object: create Table Stagging.Customer    Script Date: 8/11/2021 5:55:21 PM ******/

 

CREATE TABLE IF NOT EXISTS STAGE.Customer(                             
    Customer_Na int NOT NULL primary key,
    name varchar(20) NOT NULL,
    username varchar(100) NOT NULL,
    sex varchar(1) NOT NULL,
    mail varchar(100) NOT NULL,
    birthdate Datetime NULL,
    Location_Na int NOT NULL,
    Phone varchar(15) not NUll);

 

/****** Object: create Table Stagging.LoCation    Script Date: 8/11/2021 5:55:21 PM ******/

 

CREATE TABLE IF NOT EXISTS STAGE.Location(
    Location_Na Int NOT NULL primary key,
    Address varchar(100) NOT NULL,
    Lat float NOT NULL,
    Long float NOT NULL,
    Post_Code int NOT NULL,
    City varchar(20) NOT NULL,
    Country_code varchar(2) NOT NULL,
    Country_name varchar(20) NOT NULL,
    States varchar(30) NOT NULL);

 

/****** Object:  Create Table Stagging.Product    Script Date: 8/11/2021 5:55:21 PM ******/

 

CREATE TABLE IF NOT EXISTS STAGE.Product(
    Warehouse_Na int NOT NULL,
    Product_Na int not NULL primary key,
    Product_Name varchar(50) NOT NULL,
    Product_SubCategory varchar(50) NULL,
    Product_Color varchar(20) NOt NULL,
    Standard_Cost float NOT NULL,
    General_Price float NOT NULL,
    Product_Number int NOT NULL,
    Sale_DateStart Datetime NULL,
    Sale_DateEnd Datetime NULL,
    Import_Flag Boolean NULL);

 

/****** Object:  Create Table Stagging.record    Script Date: 8/11/2021 5:55:21 PM ******/

 

CREATE TABLE IF NOT EXISTS Stage.Record(
    Order_Na int NOT NULL,
    Product_Na int not NULL,
    Customer_Na int not NULL,
    Product_Values float not NULL,
    General_Price float not NULL,
    Tax float not NULL,
    Total_Cost float not NULL,
    Date_Order date not NULL,
    Date_Ship date not NULL,
    Date_due date not NULL,
    Ship_Distance float not NULL,
    Ship_Cost float not NULL,
     CONSTRAINT PK_RECORD
    PRIMARY KEY (PRODUCT_Na,Customer_Na,Date_Order));

 

CREATE TABLE IF NOT EXISTS STAGE.Warehouse(
    Warehouse_Na int not NULL primary key,
    Warehouse_Name varchar(100) not NULL,
    Warehouse_cost float not NULL,
    Location_Na int not NULL);

 


--Schema NDS--
--Schema NDS--
--Schema NDS--

 


/****** Object:  Create Table NDS.Warehouse    Script Date: 8/11/2021 5:55:21 PM ******/

  

CREATE TABLE IF NOT EXISTS NDS.Datetime (
    TheDate Date not null primary key,
    TheDay  int not null,
    TheDayName  varchar(20) not null,
    TheWeek  int not null ,
    TheISOWeek int not null,
    TheDayOfWeek  int not null,
    TheMonth        int not null,
    TheMonthName    varchar(20) not null,
    TheQuarter      int not null,
    TheYear         int not null,
    TheFirstOfMonth date not null,
    TheLastOfYear   date not null,
    TheDayOfYear   int not null);

 

/****** Object: create Table Stagging.Customer    Script Date: 8/11/2021 5:55:21 PM ******/

 

CREATE TABLE IF NOT EXISTS NDS.Customer(   
	Customer_ID int IDENTITY(1,1)  primary key,
    Customer_Na int NOT NULL,
    name varchar(20) NOT NULL,
    username varchar(100) NOT NULL,
    sex varchar(1) NOT NULL,
    mail varchar(100) NOT NULL,
    birthdate Datetime NULL,
    Location_Na int NOT NULL,
    Phone varchar(15) not NUll,
	Location_ID int NULL);


/****** Object: create Table Stagging.LoCation    Script Date: 8/11/2021 5:55:21 PM ******/

 

CREATE TABLE IF NOT EXISTS NDS.Location_Warehouse(
	Location_ID int IDENTITY(1,1)  primary key,
    Location_Na Int NOT NULL ,
    Address varchar(100) NOT NULL,
    Lat float NOT NULL,
    Long float NOT NULL,
    Post_Code int NOT NULL,
    City varchar(20) NOT NULL,
    Country_code varchar(2) NOT NULL,
    Country_name varchar(20) NOT NULL,
    States varchar(30) NOT NULL);

 
/****** Object: create Table Stagging.LoCation    Script Date: 8/11/2021 5:55:21 PM ******/

 

CREATE TABLE IF NOT EXISTS NDS.Location_Customer(
	Location_ID int IDENTITY(1,1)  primary key,
    Location_Na Int NOT NULL ,
    Address varchar(100) NOT NULL,
    Lat float NOT NULL,
    Long float NOT NULL,
    Post_Code int NOT NULL,
    City varchar(20) NOT NULL,
    Country_code varchar(2) NOT NULL,
    Country_name varchar(20) NOT NULL,
    States varchar(30) NOT NULL);
/****** Object:  Create Table Stagging.Product    Script Date: 8/11/2021 5:55:21 PM ******/

 

CREATE TABLE IF NOT EXISTS NDS.Product(
	Product_ID int IDENTITY(1,1)  primary key,
    Product_Na int not NULL,
    Product_Name varchar(50) NOT NULL,
    Product_SubCategory varchar(50) NULL,
    Product_Color varchar(20) NOt NULL,
    Standard_Cost float NOT NULL,
    General_Price float NOT NULL,
    Product_Number int NOT NULL,
    Sale_DateStart Datetime NULL,
    Sale_DateEnd Datetime NULL,
    Import_Flag Boolean NULL,
	Warehouse_Na int NOT NULL,
	Warehouse_ID int NULL);

 

/****** Object:  Create Table Stagging.record    Script Date: 8/11/2021 5:55:21 PM ******/

 

CREATE TABLE IF NOT EXISTS NDS.Record(
	Order_ID int IDENTITY(1,1)  primary key,
    Order_Na int NOT NULL,
    Product_Na int not NULL,
    Customer_Na int not NULL,
	Product_ID int  NULL,
    Customer_ID int  NULL,
    Product_Values float not NULL,
    General_Price float not NULL,
    Tax float not NULL,
    Total_Cost float not NULL,
    Date_Order date not NULL,
    Date_Ship date not NULL,
    Date_due date not NULL,
    Ship_Distance float not NULL,
    Ship_Cost float not NULL);

 

CREATE TABLE IF NOT EXISTS NDS.Warehouse(
	Warehouse_ID int IDENTITY(1,1)  primary key,
    Warehouse_Na int not NULL,
    Warehouse_Name varchar(100) not NULL,
    Warehouse_cost float not NULL,
	Location_ID int  NULL,
    Location_Na int not NULL);
    
    
    
    


 

	ALTER TABLE NDS.Warehouse
	ADD CONSTRAINT FK_warehouse
	FOREIGN KEY (Location_ID) REFERENCES NDS.Location_Warehouse(Location_ID);

 
     ALTER TABLE NDS.Customer
	ADD CONSTRAINT FK_Customers
	FOREIGN KEY (Location_ID) REFERENCES NDS.Location_Customer(Location_ID);
    
	ALTER TABLE NDS.Product
	ADD CONSTRAINT FK_Product
	FOREIGN KEY (Warehouse_ID) REFERENCES NDS.Warehouse(Warehouse_ID);

 

	ALTER TABLE NDS.Record
	ADD CONSTRAINT FK_record_product
	FOREIGN KEY (Product_ID) REFERENCES NDS.Product(Product_ID);

 

	ALTER TABLE NDS.Record
	ADD CONSTRAINT FK_record_Customer
	FOREIGN KEY (Customer_ID) REFERENCES NDS.Customer(Customer_ID);

 

	ALTER TABLE NDS.Record
	ADD CONSTRAINT FK_record_Date_Order
	FOREIGN KEY (Date_Order) REFERENCES NDS.Datetime(TheDate);

 

	ALTER TABLE NDS.Record
	ADD CONSTRAINT FK_record_Date_due
	FOREIGN KEY (Date_due) REFERENCES NDS.Datetime(TheDate);

 

	ALTER TABLE NDS.Record
	ADD CONSTRAINT FK_record_Date_Ship
	FOREIGN KEY (Date_Ship) REFERENCES NDS.Datetime(TheDate);
 
 
 
 
 
 
 --Schema SCHEMA--
--Schema SCHEMA--
--Schema SCHEMA--
 
 
 
 
 
 
 
 
  

CREATE TABLE IF NOT EXISTS MODEL.DIMDATE (
    TheDate Date not null primary key,
    TheDay  int not null,
    TheDayName  varchar(20) not null,
    TheWeek  int not null ,
    TheISOWeek int not null,
    TheDayOfWeek  int not null,
    TheMonth        int not null,
    TheMonthName    varchar(20) not null,
    TheQuarter      int not null,
    TheYear         int not null,
    TheFirstOfMonth date not null,
    TheLastOfYear   date not null,
    TheDayOfYear   int not null);

 

/****** Object: create Table Stagging.DIMCUSTOMER    Script Date: 8/11/2021 5:55:21 PM ******/

 

CREATE TABLE IF NOT EXISTS MODEL.DIMCUSTOMER(   
	Customer_ID int NULL primary key,
    name varchar(20) NOT NULL,
    username varchar(100) NOT NULL,
    sex varchar(1) NOT NULL,
    mail varchar(100) NOT NULL,
    birthdate Datetime NULL,
    Phone varchar(15) not NUll,
	Location_ID int NOT NULL);


/****** Object: create Table Stagging.DIMLOCATION    Script Date: 8/11/2021 5:55:21 PM ******/

 

CREATE TABLE IF NOT EXISTS MODEL.DIMLOCATION_CUSTOMER(
	Location_ID int NULL primary key,
    Address varchar(100) NOT NULL,
    Lat float NOT NULL,
    Long float NOT NULL,
    Post_Code int NOT NULL,
    City varchar(20) NOT NULL,
    Country_code varchar(2) NOT NULL,
    Country_name varchar(20) NOT NULL,
    States varchar(30) NOT NULL);

/****** Object: create Table Stagging.DIMLOCATION    Script Date: 8/11/2021 5:55:21 PM ******/

 

CREATE TABLE IF NOT EXISTS MODEL.DIMLOCATION_WAREHOUSE(
	Location_ID int NULL primary key,
    Address varchar(100) NOT NULL,
    Lat float NOT NULL,
    Long float NOT NULL,
    Post_Code int NOT NULL,
    City varchar(20) NOT NULL,
    Country_code varchar(2) NOT NULL,
    Country_name varchar(20) NOT NULL,
    States varchar(30) NOT NULL);

/****** Object:  Create Table Stagging.DIMPRODUCT    Script Date: 8/11/2021 5:55:21 PM ******/

 

CREATE TABLE IF NOT EXISTS MODEL.DIMPRODUCT(
	Product_ID int NULL primary key,
    Product_Name varchar(50) NOT NULL,
    Product_SubCategory varchar(50) NULL,
    Product_Color varchar(20) NOt NULL,
    Standard_Cost float NOT NULL,
    General_Price float NOT NULL,
    Product_Number int NOT NULL,
    Sale_DateStart Datetime NULL,
    Sale_DateEnd Datetime NULL,
    Import_Flag Boolean NULL,
	Warehouse_ID int NOT NULL);

 

/****** Object:  Create Table Stagging.FACTRECORD    Script Date: 8/11/2021 5:55:21 PM ******/

 

CREATE TABLE IF NOT EXISTS MODEL.FACTRECORD(
	Order_ID int NULL primary key,
	Product_ID int not NULL,
    Customer_ID int not NULL,
    Product_Values float not NULL,
    General_Price float not NULL,
    Tax float not NULL,
    Total_Cost float not NULL,
    Date_Order date not NULL,
    Date_Ship date not NULL,
    Date_due date not NULL,
    Ship_Distance float not NULL,
    Ship_Cost float not NULL);

 

CREATE TABLE IF NOT EXISTS MODEL.DIMWAREHOUSE(
	Warehouse_ID int  NULL primary key,
    Warehouse_Name varchar(100) not NULL,
    Warehouse_cost float not NULL,
	Location_ID int not NULL);
    
   

	ALTER TABLE MODEL.DIMWAREHOUSE
	ADD CONSTRAINT FK_warehouse
	FOREIGN KEY (Location_ID) REFERENCES MODEL.DIMLOCATION_WAREHOUSE(Location_ID);

 
     ALTER TABLE MODEL.DIMCUSTOMER
	ADD CONSTRAINT FK_Customers
	FOREIGN KEY (Location_ID) REFERENCES MODEL.DIMLOCATION_CUSTOMER(Location_ID);
    
	ALTER TABLE MODEL.DIMPRODUCT
	ADD CONSTRAINT FK_Product
	FOREIGN KEY (Warehouse_ID) REFERENCES MODEL.DIMWAREHOUSE(Warehouse_ID);

 

	ALTER TABLE MODEL.FACTRECORD
	ADD CONSTRAINT FK_record_product
	FOREIGN KEY (Product_ID) REFERENCES MODEL.DIMPRODUCT(Product_ID);

 

	ALTER TABLE MODEL.FACTRECORD
	ADD CONSTRAINT FK_record_Customer
	FOREIGN KEY (Customer_ID) REFERENCES MODEL.DIMCUSTOMER(Customer_ID);

 

	ALTER TABLE MODEL.FACTRECORD
	ADD CONSTRAINT FK_record_Date_Order
	FOREIGN KEY (Date_Order) REFERENCES MODEL.DIMDATE(TheDate);

 

	ALTER TABLE MODEL.FACTRECORD
	ADD CONSTRAINT FK_record_Date_due
	FOREIGN KEY (Date_due) REFERENCES MODEL.DIMDATE(TheDate);

 

	ALTER TABLE MODEL.FACTRECORD
	ADD CONSTRAINT FK_record_Date_Ship
	FOREIGN KEY (Date_Ship) REFERENCES MODEL.DIMDATE(TheDate);
    
--set up data to model to download--
CREATE FILE FORMAT "PROJECT1"."MODEL".CSV_FILE
TYPE = 'CSV' COMPRESSION = 'AUTO' FIELD_DELIMITER = ','
RECORD_DELIMITER = '\n' SKIP_HEADER = 0 FIELD_OPTIONALLY_ENCLOSED_BY = 'NONE'
TRIM_SPACE = FALSE ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE ESCAPE = 'NONE'
ESCAPE_UNENCLOSED_FIELD = '\134' DATE_FORMAT = 'AUTO' TIMESTAMP_FORMAT = 'AUTO'
NULL_IF = ('\\N');