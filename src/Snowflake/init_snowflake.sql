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

CREATE OR REPLACE SCHEMA UTILS;
CREATE OR REPLACE TABLE UTILS.error_log (
    TimeStamp Datetime DEFAULT CURRENT_TIMESTAMP(),
    Error_task string,    
    Error_code number,
    Error_state string,
    Error_message string,
    Stack_trace string);

-- Create Stored Procedure
USE SCHEMA UTILS;
create or replace procedure data_into_nds_location()
returns string
language javascript
as
$$ 
    var sql_command_getmax_id = `select max(t.LOCATION_ID) maxid from nds.location t`;
    var statement_getmax_id = snowflake.createStatement( {sqlText: sql_command_getmax_id});
    var maxid_result_set = statement_getmax_id.execute();
    maxid_result_set.next();
    if (maxid_result_set.getColumnValue(1)===null)
    {
    maxid = 0;
    }
    else
    {
    maxid = maxid_result_set.getColumnValue(1);
    }
    try {
    var sql_command_merge_nds_location = `merge into nds.location
        using (select row_number() over (order by 1) rn,* from stage.location) t 
        on nds.location.uuid=t.uuid
        when matched then
        update set ADDRESS=t.ADDRESS,LAT=t.LAT,LONG=t.LONG,
                    CITY=t.CITY,COUNTRY_CODE=t.COUNTRY_CODE,COUNTRY_NAME=t.COUNTRY_NAME,STATES=t.STATES,LASTEDITEDBY=t.LASTEDITEDBY,LASTEDITEDWHEN=CURRENT_TIMESTAMP()
        when not matched then
        insert (LOCATION_ID,SOURCE_LOCATION_ID,ADDRESS,LAT,LONG,CITY,COUNTRY_CODE,COUNTRY_NAME,STATES,UUID,LASTEDITEDBY,LASTEDITEDWHEN)
                values (t.rn+:1,t.LOCATION_ID,t.ADDRESS,t.LAT,t.LONG,t.CITY,t.COUNTRY_CODE,t.COUNTRY_NAME,t.STATES,t.UUID,t.LASTEDITEDBY,CURRENT_TIMESTAMP())`
                
    var statement_merge_nds_location = snowflake.createStatement({sqlText: sql_command_merge_nds_location,binds:[maxid]});
    var number_row_result = statement_merge_nds_location.execute();
    number_row_result.next();
    result = "Number of rows affected: " + number_row_result.getColumnValue(1);
    }
    catch (err)  {
        result = "Failed";
        snowflake.execute({
        sqlText: `insert into UTILS.Error_log VALUES (CURRENT_TIMESTAMP(),'data_into_nds_location',?,?,?,?)`
        ,binds: [err.code, err.state, err.message, err.stackTraceTxt]});
    }
    return(result);
$$;

create or replace procedure data_into_nds_product()
returns string
language javascript
as
$$ 
    var sql_command_getmax_id = `select max(t.PRODUCT_ID) maxid from nds.product t`;
    var statement_getmax_id = snowflake.createStatement({sqlText: sql_command_getmax_id});
    var maxid_result_set = statement_getmax_id.execute();
    maxid_result_set.next();
    if (maxid_result_set.getColumnValue(1)===null)
    {
    maxid = 0;
    }
    else
    {
    maxid = maxid_result_set.getColumnValue(1);
    }
    try {
    var sql_command_merge_nds_product = `merge into nds.product
        using (select row_number() over (order by 1) rn,* from stage.product) t 
        on nds.product.uuid=t.uuid
        when matched then
        update set PRODUCT_NAME=t.PRODUCT_NAME,PRODUCT_CATEGORY=t.PRODUCT_CATEGORY,PRODUCT_CODE=t.PRODUCT_CODE,
                    WEIGHT=t.WEIGHT,LASTEDITEDBY=t.LASTEDITEDBY,LASTEDITEDWHEN=CURRENT_TIMESTAMP()
        when not matched then
        insert (PRODUCT_ID,SOURCE_PRODUCT_ID,PRODUCT_NAME,PRODUCT_CATEGORY,PRODUCT_CODE,WEIGHT,UUID,LASTEDITEDBY,LASTEDITEDWHEN)
                values (t.rn+:1,t.PRODUCT_ID,t.PRODUCT_NAME,t.PRODUCT_CATEGORY,t.PRODUCT_CODE,t.WEIGHT,t.UUID,t.LASTEDITEDBY,CURRENT_TIMESTAMP())`
    var statement_merge_nds_product = snowflake.createStatement({sqlText: sql_command_merge_nds_product,binds:[maxid]});
    var number_row_result = statement_merge_nds_product.execute();
    number_row_result.next();
    result = "Number of rows affected: " + number_row_result.getColumnValue(1);
    }
    catch (err)  {
        result = "Failed";
        snowflake.execute({
        sqlText: `insert into UTILS.Error_log VALUES (CURRENT_TIMESTAMP(),'data_into_nds_product',?,?,?,?)`
        ,binds: [err.code, err.state, err.message, err.stackTraceTxt]});
    }
    return(result);
$$;

create or replace procedure data_into_nds_customer()
returns string
language javascript
as
$$ 
    var sql_command_getmax_id = `select max(t.PRODUCT_ID) maxid from nds.product t`;
    var statement_getmax_id = snowflake.createStatement({sqlText: sql_command_getmax_id});
    var maxid_result_set = statement_getmax_id.execute();
    maxid_result_set.next();
    if (maxid_result_set.getColumnValue(1)===null)
    {
    maxid = 0;
    }
    else
    {
    maxid = maxid_result_set.getColumnValue(1);
    }
    try {
    var sql_command_merge_nds_customer= `merge into nds.customer
        using (select row_number() over (order by 1) rn,sc.*,nl.LOCATION_ID n_locationid from stage.customer sc 
               inner join nds.location nl on nl.Source_Location_ID=sc.Location_ID) t 
        on nds.customer.uuid=t.uuid
        when matched then
        update set NAME=t.NAME,USERNAME=t.USERNAME,SEX=t.SEX,
                    MAIL=t.MAIL,BIRTHDATE=t.BIRTHDATE,LOCATION_ID=t.n_locationid,PHONE=t.PHONE,LASTEDITEDBY=t.LASTEDITEDBY,LASTEDITEDWHEN=CURRENT_TIMESTAMP()
        when not matched then
        insert (CUSTOMER_ID,SOURCE_CUSTOMER_ID,NAME,USERNAME,SEX,MAIL,BIRTHDATE,LOCATION_ID,PHONE,UUID,LASTEDITEDBY,LASTEDITEDWHEN)
                values (t.rn+:1,t.CUSTOMER_ID,t.NAME,t.USERNAME,t.SEX,t.MAIL,t.BIRTHDATE,t.n_locationid,t.PHONE,t.UUID,t.LASTEDITEDBY,CURRENT_TIMESTAMP())`
    var statement_merge_nds_customer = snowflake.createStatement({sqlText: sql_command_merge_nds_customer,binds:[maxid]});
    var number_row_result = statement_merge_nds_customer.execute();
    number_row_result.next();
    result = "Number of rows affected: " + number_row_result.getColumnValue(1);
    }
    catch (err)  {
        result = "Failed";
        snowflake.execute({
        sqlText: `insert into UTILS.Error_log VALUES (CURRENT_TIMESTAMP(),'data_into_nds_customer',?,?,?,?)`
        ,binds: [err.code, err.state, err.message, err.stackTraceTxt]});
    }
    return(result);
$$;

create or replace procedure data_into_nds_supplier()
returns string
language javascript
as
$$ 
    var sql_command_getmax_id = `select max(t.PRODUCT_ID) maxid from nds.product t`;
    var statement_getmax_id = snowflake.createStatement({sqlText: sql_command_getmax_id});
    var maxid_result_set = statement_getmax_id.execute();
    maxid_result_set.next();
    if (maxid_result_set.getColumnValue(1)===null)
    {
    maxid = 0;
    }
    else
    {
    maxid = maxid_result_set.getColumnValue(1);
    }
    try {
    var sql_command_merge_nds_supplier = `merge into nds.supplier
        using (select row_number() over (order by 1) rn,ss.*,nl.LOCATION_ID n_locationid from stage.supplier ss 
              inner join nds.location nl on ss.LOCATION_ID = nl.SOURCE_LOCATION_ID) t 
        on nds.supplier.uuid=t.uuid
        when matched then
        update set SUPPLIER_NAME=t.SUPPLIER_NAME,LOCATION_ID=t.n_locationid,LASTEDITEDBY=t.LASTEDITEDBY,LASTEDITEDWHEN=CURRENT_TIMESTAMP()
        when not matched then
        insert (SUPPLIER_ID,SOURCE_SUPPLIER_ID,SUPPLIER_NAME,LOCATION_ID,UUID,LASTEDITEDBY,LASTEDITEDWHEN)
                values (t.rn+:1,t.SUPPLIER_ID,t.SUPPLIER_NAME,t.n_locationid,t.UUID,t.LASTEDITEDBY,CURRENT_TIMESTAMP())`
    var statement_merge_nds_supplier = snowflake.createStatement({sqlText: sql_command_merge_nds_supplier,binds:[maxid]});
    var number_row_result = statement_merge_nds_supplier.execute();
    number_row_result.next();
    result = "Number of rows affected: " + number_row_result.getColumnValue(1);
    }
    catch (err)  {
        result = "Failed";
        snowflake.execute({
        sqlText: `insert into UTILS.Error_log VALUES (CURRENT_TIMESTAMP(),'data_into_nds_supplier',?,?,?,?)`
        ,binds: [err.code, err.state, err.message, err.stackTraceTxt]});
    }
    return(result);
$$;

create or replace procedure data_into_nds_warehouse()
returns string
language javascript
as
$$ 
    var sql_command_getmax_id = `select max(t.PRODUCT_ID) maxid from nds.product t`;
    var statement_getmax_id = snowflake.createStatement({sqlText: sql_command_getmax_id});
    var maxid_result_set = statement_getmax_id.execute();
    maxid_result_set.next();
    if (maxid_result_set.getColumnValue(1)===null)
    {
    maxid = 0;
    }
    else
    {
    maxid = maxid_result_set.getColumnValue(1);
    }
    try {
    var sql_command_merge_nds_warehouse = `merge into nds.warehouse
        using (select row_number() over (order by 1) rn,sw.*,nl.LOCATION_ID n_locationid from stage.warehouse sw
              inner join nds.location nl on sw.LOCATION_ID=nl.SOURCE_LOCATION_ID) t 
        on nds.warehouse.uuid=t.uuid
        when matched then
        update set WAREHOUSE_NAME=t.WAREHOUSE_NAME,WAREHOUSE_COST=t.WAREHOUSE_COST,LOCATION_ID=t.n_locationid,LASTEDITEDBY=t.LASTEDITEDBY,LASTEDITEDWHEN=CURRENT_TIMESTAMP()
        when not matched then
        insert (WAREHOUSE_ID,SOURCE_WAREHOUSE_ID,WAREHOUSE_NAME,WAREHOUSE_COST,LOCATION_ID,UUID,LASTEDITEDBY,LASTEDITEDWHEN)
                values (t.rn+:1,t.WAREHOUSE_ID,t.WAREHOUSE_NAME,t.WAREHOUSE_COST,t.n_locationid,t.UUID,t.LASTEDITEDBY,CURRENT_TIMESTAMP())`
    var statement_merge_nds_warehouse = snowflake.createStatement({sqlText: sql_command_merge_nds_warehouse,binds:[maxid]});
    var number_row_result = statement_merge_nds_warehouse.execute();
    number_row_result.next();
    result = "Number of rows affected: " + number_row_result.getColumnValue(1);
    }
    catch (err)  {
        result = "Failed";
        snowflake.execute({
        sqlText: `insert into UTILS.Error_log VALUES (CURRENT_TIMESTAMP(),'data_into_nds_warehouse',?,?,?,?)`
        ,binds: [err.code, err.state, err.message, err.stackTraceTxt]});
    }
    return(result);
$$;

create or replace procedure data_into_nds_storage()
returns string
language javascript
as
$$ 
    var sql_command_getmax_id = `select max(t.PRODUCT_ID) maxid from nds.product t`;
    var statement_getmax_id = snowflake.createStatement({sqlText: sql_command_getmax_id});
    var maxid_result_set = statement_getmax_id.execute();
    maxid_result_set.next();
    if (maxid_result_set.getColumnValue(1)===null)
    {
    maxid = 0;
    }
    else
    {
    maxid = maxid_result_set.getColumnValue(1);
    }
    try {
    var sql_command_merge_nds_storage = `merge into nds.storage
        using (select row_number() over (order by 1) rn,ss.*,np.product_id n_product_id,nw.WAREHOUSE_ID n_WAREHOUSE_ID from stage.storage ss
              inner join nds.product np on np.Source_Product_ID=ss.Product_ID
              inner join nds.warehouse nw on nw.Source_Warehouse_ID=ss.Warehouse_ID) t
        on nds.storage.uuid=t.uuid
        when matched then
        update set PRODUCT_ID=t.n_product_id,WAREHOUSE_ID=t.n_WAREHOUSE_ID,CAPACITY=t.CAPACITY,QUANTITY=t.QUANTITY,LASTEDITEDBY=t.LASTEDITEDBY,LASTEDITEDWHEN=CURRENT_TIMESTAMP()
        when not matched then
        insert (STORAGEID,SOURCE_STORAGEID,PRODUCT_ID,WAREHOUSE_ID,CAPACITY,QUANTITY,UUID,LASTEDITEDBY,LASTEDITEDWHEN)
                values (t.rn+:1,t.StorageID,t.n_product_id,t.n_WAREHOUSE_ID,t.CAPACITY,t.QUANTITY,t.UUID,t.LASTEDITEDBY,CURRENT_TIMESTAMP())`
    var statement_merge_nds_storage = snowflake.createStatement({sqlText: sql_command_merge_nds_storage,binds:[maxid]});
    var number_row_result = statement_merge_nds_storage.execute();
    number_row_result.next();
    result = "Number of rows affected: " + number_row_result.getColumnValue(1);
    }
    catch (err)  {
        result = "Failed";
        snowflake.execute({
        sqlText: `insert into UTILS.Error_log VALUES (CURRENT_TIMESTAMP(),'data_into_nds_storage',?,?,?,?)`
        ,binds: [err.code, err.state, err.message, err.stackTraceTxt]});
    }
    return(result);
$$;

create or replace procedure data_into_nds_export()
returns string
language javascript
as
$$ 
    var sql_command_getmax_id = `select max(t.PRODUCT_ID) maxid from nds.product t`;
    var statement_getmax_id = snowflake.createStatement({sqlText: sql_command_getmax_id});
    var maxid_result_set = statement_getmax_id.execute();
    maxid_result_set.next();
    if (maxid_result_set.getColumnValue(1)===null)
    {
    maxid = 0;
    }
    else
    {
    maxid = maxid_result_set.getColumnValue(1);
    }
    try {
    var sql_command_merge_nds_export = `merge into nds.export
        using (select row_number() over (order by 1) rn,se.*,np.product_id n_product_id,nc.CUSTOMER_ID n_CUSTOMER_ID from stage.export se
              inner join nds.product np on np.Source_Product_ID=se.Product_ID
              inner join nds.customer nc on nc.Source_Customer_ID=se.CUSTOMER_ID) as t
        on nds.export.uuid=t.uuid
        when matched then
        update set PRODUCT_ID=t.n_product_id,CUSTOMER_ID=t.n_CUSTOMER_ID,QUANTITY=t.QUANTITY,DATE_ORDER=t.DATE_ORDER,DATE_SHIP=t.DATE_SHIP,DATE_DUE=t.DATE_DUE,SHIP_DISTANCE=t.SHIP_DISTANCE,SHIP_COST=t.SHIP_COST,
                LASTEDITEDBY=t.LASTEDITEDBY,LASTEDITEDWHEN=CURRENT_TIMESTAMP()
        when not matched then
        insert (ORDER_ID,SOURCE_ORDER_ID,PRODUCT_ID,CUSTOMER_ID,QUANTITY,DATE_ORDER,DATE_SHIP,DATE_DUE,SHIP_DISTANCE,SHIP_COST,UUID,LASTEDITEDBY,LASTEDITEDWHEN)
                values (t.rn+:1,t.ORDER_ID,t.n_product_id,t.n_CUSTOMER_ID,t.QUANTITY,t.DATE_ORDER,t.DATE_SHIP,t.DATE_DUE,t.SHIP_DISTANCE,t.SHIP_COST,t.UUID,t.LASTEDITEDBY,CURRENT_TIMESTAMP())`
    var statement_merge_nds_export = snowflake.createStatement({sqlText: sql_command_merge_nds_export,binds:[maxid]});
    var number_row_result = statement_merge_nds_export.execute();
    number_row_result.next();
    result = "Number of rows affected: " + number_row_result.getColumnValue(1);
    }
    catch (err)  {
        result = "Failed";
        snowflake.execute({
        sqlText: `insert into UTILS.Error_log VALUES (CURRENT_TIMESTAMP(),'data_into_nds_export',?,?,?,?)`
        ,binds: [err.code, err.state, err.message, err.stackTraceTxt]});
    }
    return(result);
$$;

create or replace procedure data_into_nds_import()
returns string
language javascript
as
$$ 
    var sql_command_getmax_id = `select max(t.PRODUCT_ID) maxid from nds.product t`;
    var statement_getmax_id = snowflake.createStatement({sqlText: sql_command_getmax_id});
    var maxid_result_set = statement_getmax_id.execute();
    maxid_result_set.next();
    if (maxid_result_set.getColumnValue(1)===null)
    {
    maxid = 0;
    }
    else
    {
    maxid = maxid_result_set.getColumnValue(1);
    }
    try {
    var sql_command_merge_nds_import = `merge into nds.import
        using (select row_number() over (order by 1) rn,si.*,np.product_id n_product_id,nw.WAREHOUSE_ID n_WAREHOUSE_ID,ns.SUPPLIER_ID n_SUPPLIER_ID from stage.import si
              inner join nds.WAREHOUSE nw on nw.Source_Warehouse_ID=si.WAREHOUSE_ID
              inner join nds.PRODUCT np on np.Source_Product_ID=si.PRODUCT_ID
              inner join nds.SUPPLIER ns on ns.Source_Supplier_ID=si.SUPPLIER_ID) t 
        on nds.import.uuid=t.uuid
        when matched then
        update set PRODUCT_ID=t.n_product_id,WAREHOUSE_ID=t.n_WAREHOUSE_ID,SUPPLIER_ID=t.n_SUPPLIER_ID,QUANTITY=t.QUANTITY,SHIP_DISTANCE=t.SHIP_DISTANCE,SHIP_COST=t.SHIP_COST,IMPORT_DATE=t.IMPORT_DATE,
                LASTEDITEDBY=t.LASTEDITEDBY,LASTEDITEDWHEN=CURRENT_TIMESTAMP()
        when not matched then
        insert (IMPORTID,SOURCE_IMPORT_ID,PRODUCT_ID,WAREHOUSE_ID,SUPPLIER_ID,QUANTITY,SHIP_DISTANCE,SHIP_COST,IMPORT_DATE,UUID,LASTEDITEDBY,LASTEDITEDWHEN)
                values (t.rn+:1,t.Import_ID,t.n_product_id,t.n_WAREHOUSE_ID,t.n_SUPPLIER_ID,t.QUANTITY,t.SHIP_DISTANCE,t.SHIP_COST,t.IMPORT_DATE,t.UUID,t.LASTEDITEDBY,CURRENT_TIMESTAMP())`
    var statement_merge_nds_import = snowflake.createStatement({sqlText: sql_command_merge_nds_import,binds:[maxid]});
    var number_row_result = statement_merge_nds_import.execute();
    number_row_result.next();
    result = "Number of rows affected: " + number_row_result.getColumnValue(1);
    }
    catch (err)  {
        result = "Failed";
        snowflake.execute({
        sqlText: `insert into UTILS.Error_log VALUES (CURRENT_TIMESTAMP(),'data_into_nds_import',?,?,?,?)`
        ,binds: [err.code, err.state, err.message, err.stackTraceTxt]});
    }
    return(result);
$$;

CREATE OR REPLACE PROCEDURE procDimLocation()
  RETURNS string
  LANGUAGE javascript
  AS
  $$
  var result;
  var sql_command_merge_dim_location = 
  `MERGE INTO Model.DimLocation t
    USING (SELECT l.Location_ID,l.Lat,l.Long,l.Address,l.City,l.States,l.Country_code,l.Country_name
           FROM Stage.Location sl
           JOIN NDS.Location l
           ON sl.Location_ID = l.Source_Location_ID) as s
    ON t.Location_ID = s.Location_ID
    WHEN MATCHED
        THEN 
            UPDATE SET t.Address = s.Address, t.City = s.City, t.States = s.States,
            t.Country_code = s.Country_code , t.Country_name = s.Country_name
    WHEN NOT MATCHED
        THEN
            INSERT (Location_ID,Lat,Long,Address,City,States,Country_code,Country_name)
            VALUES (s.Location_ID,s.Lat,s.Long,s.Address,s.City,s.States,s.Country_code,s.Country_name);`;
  try {
        snowflake.execute ({sqlText: sql_command_merge_dim_location});     
        result = "Succeeded";
        }
    catch (err)  {
        result = "Failed";
        snowflake.execute({
        sqlText: `insert into UTILS.Error_log VALUES (CURRENT_TIMESTAMP(),'procDimLocation',?,?,?,?)`
        ,binds: [err.code, err.state, err.message, err.stackTraceTxt]});
    }
    return(result);
$$;

CREATE OR REPLACE PROCEDURE procDimProduct()
  RETURNS string
  LANGUAGE javascript
  AS
  $$
  var result;
  var sql_command_change_old_dim_product = 
  `MERGE INTO Model.DimProduct as t
    USING (SELECT p.Product_ID,p.Product_Code,p.Product_Name,p.Product_Category,p.Weight
           FROM Stage.Product sp
           JOIN NDS.Product p
           ON sp.Product_ID = p.Source_Product_ID) as s
    ON t.Product_ID = s.Product_ID
    WHEN MATCHED AND Currently = 1
        THEN 
            UPDATE SET t.Currently = 0;`;
  var sql_command_insert_new_dim_product =
  `INSERT INTO Model.DimProduct (Product_ID,Product_Code,Product_Name,Product_Category,Weight,Currently)
    (SELECT p.Product_ID,p.Product_Code,p.Product_Name,p.Product_Category,p.Weight,1 
     FROM Stage.Product sp
     JOIN NDS.Product p
     ON sp.Product_ID = p.Source_Product_ID);`;
  try {
        snowflake.execute({sqlText: sql_command_change_old_dim_product});
        snowflake.execute({sqlText: sql_command_insert_new_dim_product});
        result = "Succeeded";
        }
    catch (err)  {
        result = "Failed";
        snowflake.execute({
        sqlText: `insert into UTILS.Error_log VALUES (CURRENT_TIMESTAMP(),'procDimProduct',?,?,?,?)`
        ,binds: [err.code, err.state, err.message, err.stackTraceTxt]});
    }
    return(result);
$$;

CREATE OR REPLACE PROCEDURE procDimWarehouse()
  RETURNS string
  LANGUAGE javascript
  AS
  $$
  var result;
  var sql_command_merge_dim_warehouse = 
  `MERGE INTO Model.DimWarehouse t
    USING (SELECT w.Warehouse_ID, w.Warehouse_name, w.Warehouse_cost, l.Lat, l.Long 
           FROM Stage.Warehouse sw
           JOIN NDS.WAREHOUSE w
           ON sw.Warehouse_ID = w.Source_Warehouse_ID
           JOIN NDS.Location l
           ON w.Location_ID = l.Location_ID) s
    ON t.Warehouse_ID = s.Warehouse_ID
    WHEN MATCHED
        THEN 
            UPDATE SET t.Warehouse_name = s.Warehouse_name, t.Warehouse_cost = s.Warehouse_cost
    WHEN NOT MATCHED
        THEN
            INSERT (Warehouse_ID,Warehouse_name,Warehouse_cost,Lat,Long)
            VALUES (s.Warehouse_ID,s.Warehouse_name,s.Warehouse_cost,s.Lat,s.Long);`;
  try {
        snowflake.execute ({sqlText: sql_command_merge_dim_warehouse});     
        result = "Succeeded";
        }
    catch (err)  {
        result = "Failed";
        snowflake.execute({
        sqlText: `insert into UTILS.Error_log VALUES (CURRENT_TIMESTAMP(),'procDimWarehouse',?,?,?,?)`
        ,binds: [err.code, err.state, err.message, err.stackTraceTxt]});
    }
    return(result);
$$;

CREATE OR REPLACE PROCEDURE procFactImport()
  RETURNS string
  LANGUAGE javascript
  AS
  $$
  var result;
  var sql_command_insert_fact_import = 
  `INSERT INTO Model.FactImport (ImportDate, DepartureLocationKey, ArrivalLocationKey, WarehouseKey, ProductKey, Quantity, TotalWeight, ShipDistance, ShipCost)
    (SELECT i.Import_Date, ls.LocationKey as DepartureLocationKey, lw.LocationKey as ArrivalLocationKey, w.WarehouseKey, p.ProductKey,
            i.Quantity, i.Quantity * p.Weight as TotalWeight, i.Ship_Distance, i.Ship_Cost
    FROM Stage.Import si
    JOIN NDS.Import i
    ON si.Import_ID = i.Source_Import_ID
    JOIN Model.DimProduct p
    ON i.Product_ID = p.Product_ID
    JOIN Model.DimWarehouse w
    ON i.Warehouse_ID = w.Warehouse_ID
    JOIN NDS.Supplier s
    ON i.Supplier_ID = s.Supplier_ID
    JOIN Model.DimLocation ls
    ON ls.Location_ID = s.Location_ID
    JOIN NDS.Warehouse nw
    ON i.Warehouse_ID = nw.Warehouse_ID
    JOIN Model.DimLocation lw
    ON nw.Location_ID = lw.Location_ID
    WHERE p.Currently = 1);`;
  try {
        snowflake.execute ({sqlText: sql_command_insert_fact_import});     
        result = "Succeeded";
        }
    catch (err)  {
        result = "Failed";
        snowflake.execute({
        sqlText: `insert into UTILS.Error_log VALUES (CURRENT_TIMESTAMP(),'procFactImport',?,?,?,?)`
        ,binds: [err.code, err.state, err.message, err.stackTraceTxt]});
    }
    return(result);
$$;

CREATE OR REPLACE PROCEDURE procFactExport()
  RETURNS string
  LANGUAGE javascript
  AS
  $$
  var result;
  var sql_command_insert_fact_export = 
  `INSERT INTO Model.FactExport (ExportDate, DepartureLocationKey, ArrivalLocationKey, WarehouseKey, ProductKey, ShipLate, Quantity, TotalWeight, ShipDistance, ShipCost)
    (SELECT e.Date_ship, lw.LocationKey as DepartureLocationKey, lc.LocationKey as ArrivalLocationKey, w.WarehouseKey, p.ProductKey,
            GREATEST(0,DATEDIFF(day,e.Date_Due, e.Date_ship)) as ShipLate, e.Quantity, e.Quantity * p.Weight as TotalWeight, e.Ship_Distance, e.Ship_Cost
    FROM Stage.Export se
    JOIN NDS.Export e
    ON se.Order_ID = e.Source_Order_ID 
    JOIN Model.DimProduct p
    ON e.Product_ID = p.Product_ID
    JOIN NDS.Storage st
    ON e.Product_ID = st.Product_ID
    JOIN Model.DimWarehouse w
    ON st.Warehouse_ID = w.Warehouse_ID
    JOIN NDS.Customer c
    ON e.Customer_ID = c.Customer_ID
    JOIN Model.DimLocation lc
    ON c.Location_ID = lc.Location_ID
    JOIN NDS.Warehouse nw
    ON st.Warehouse_ID = nw.Warehouse_ID
    JOIN Model.DimLocation lw
    ON nw.Location_ID = lw.Location_ID
    WHERE p.Currently = 1);`;
  try {
        snowflake.execute ({sqlText: sql_command_insert_fact_export});     
        result = "Succeeded";
        }
    catch (err)  {
        result = "Failed";
        snowflake.execute({
        sqlText: `insert into UTILS.Error_log VALUES (CURRENT_TIMESTAMP(),'procFactExport',?,?,?,?)`
        ,binds: [err.code, err.state, err.message, err.stackTraceTxt]});
    }
    return(result);
$$;

CREATE OR REPLACE PROCEDURE CleanUp()
    RETURNS string
    LANGUAGE JavaScript
AS
$$
  var result;
  var sql_cleanup_cmd = `select 'TRUNCATE TABLE ' || TABLE_CATALOG || '.' || TABLE_SCHEMA || '.' || table_name || ';' SQL_COMMAND
              from information_schema.tables 
              where TABLE_CATALOG = 'PROJECT2' and TABLE_SCHEMA='STAGE'`
  sql_cleanup_cmd_dict = {sqlText: sql_cleanup_cmd};
  cleanup_statement = snowflake.createStatement(sql_cleanup_cmd_dict);
  var flush_import_stream = "insert into Stage.Import select Import_ID, Product_ID, Warehouse_ID, Supplier_ID,\
                        Quantity, Ship_Distance, Ship_Cost, Import_Date, uuid, LastEditedBy, LastEditedWhen from import_stream where false;";
  var flush_export_stream = "insert into Stage.Export select Order_ID, Product_ID, Customer_ID, Quantity,\
                        Date_Order, Date_Ship, Date_due, Ship_Distance, Ship_Cost, uuid, LastEditedBy, LastEditedWhen from export_stream where false;";
  var resume_master_task = "ALTER TASK TASK_MASTER RESUME;";
  try {
        results = cleanup_statement.execute();
        while (results.next())  {
            exec_cleanup_cmt_dict = {sqlText: results.getColumnValue("SQL_COMMAND")};
            execute_cleanup_statement = snowflake.createStatement(exec_cleanup_cmt_dict);
            execute_cleanup_statement.execute();
            }
        snowflake.execute ({sqlText: flush_import_stream});
        snowflake.execute ({sqlText: flush_export_stream});       
        snowflake.execute ({sqlText: resume_master_task});       
        result = "Succeeded";
        }
    catch (err)  {
        result = "Failed";
        snowflake.execute({
        sqlText: `insert into UTILS.Error_log VALUES (CURRENT_TIMESTAMP(),'CleanUp',?,?,?,?)`
        ,binds: [err.code, err.state, err.message, err.stackTraceTxt]});
    }
    return(result);
$$;

-- Create stream
USE SCHEMA UTILS;
CREATE OR REPLACE STREAM export_stream
ON TABLE PROJECT2.STAGE.EXPORT;

CREATE OR REPLACE STREAM import_stream
ON TABLE PROJECT2.STAGE.IMPORT;


-- Create Taskadmin
use role securityadmin;

create or replace role taskadmin;

-- set the active role to ACCOUNTADMIN before granting the EXECUTE TASK privilege to the new role
use role accountadmin;

grant execute task on account to role taskadmin;

-- set the active role to SECURITYADMIN to show that this role can grant a role to another role
use role securityadmin;

grant role taskadmin to role sysadmin;

-- Create Task
USE ROLE SYSADMIN;
USE SCHEMA UTILS;
CREATE OR REPLACE TASK task_master
warehouse = Project2_wh
--schedule = 'USING CRON 30 0 * * * Asia/Ho_Chi_Minh'
schedule = '1 MINUTE'
WHEN
    SYSTEM$STREAM_HAS_DATA('export_stream') OR SYSTEM$STREAM_HAS_DATA('import_stream')
as  
    ALTER TASK TASK_MASTER SUSPEND;
    
ALTER TASK task_master SUSPEND;

CREATE OR REPLACE TASK task_nds_location
warehouse = Project2_wh
after task_master
as
	call data_into_nds_location();
    
CREATE OR REPLACE TASK task_nds_product
warehouse = Project2_wh
after task_nds_location
as    
	call data_into_nds_product();

CREATE OR REPLACE TASK task_nds_customer
warehouse = Project2_wh
after task_nds_product
as    
	call data_into_nds_customer();
    
CREATE OR REPLACE TASK task_nds_supplier
warehouse = Project2_wh
after task_nds_customer
as    
	call data_into_nds_supplier();

CREATE OR REPLACE TASK task_nds_warehouse
warehouse = Project2_wh
after task_nds_supplier
as    
	call data_into_nds_warehouse();

CREATE OR REPLACE TASK task_nds_storage
warehouse = Project2_wh
after task_nds_warehouse
as
	call data_into_nds_storage();
    
CREATE OR REPLACE TASK task_nds_export
warehouse = Project2_wh
after task_nds_storage
as
	call data_into_nds_export();
    
CREATE OR REPLACE TASK task_nds_import
warehouse = Project2_wh
after task_nds_export
as
	call data_into_nds_import();
    
CREATE OR REPLACE TASK task_model_location
warehouse = Project2_wh
after task_nds_import
as
    call procDimLocation();

CREATE OR REPLACE TASK task_model_product
warehouse = Project2_wh
after task_model_location
as
    call procDimProduct();

CREATE OR REPLACE TASK task_model_warehouse
warehouse = Project2_wh
after task_model_product
as
    call procDimWarehouse();

CREATE OR REPLACE TASK task_model_factimport
warehouse = Project2_wh
after task_model_warehouse
as
    call procFactImport();

CREATE OR REPLACE TASK task_model_factexport
warehouse = Project2_wh
after task_model_factimport
as
    call procFactExport();
    
CREATE OR REPLACE TASK task_cleanup
warehouse = Project2_wh
after task_model_factexport
as
    call CleanUp();

ALTER TASK task_cleanup RESUME;
ALTER TASK task_model_factexport RESUME;
ALTER TASK task_model_factimport RESUME;
ALTER TASK task_model_warehouse RESUME;
ALTER TASK task_model_product RESUME;
ALTER TASK task_model_location RESUME;
ALTER TASK task_nds_import RESUME;
ALTER TASK task_nds_export RESUME;
ALTER TASK task_nds_storage RESUME;
ALTER TASK task_nds_warehouse RESUME;
ALTER TASK task_nds_supplier RESUME;
ALTER TASK task_nds_customer RESUME;
ALTER TASK task_nds_product RESUME;
ALTER TASK task_nds_location RESUME;
ALTER TASK task_master RESUME;

-- Create Trainer account
USE ROLE ACCOUNTADMIN;
CREATE OR REPLACE USER longbv1 password='abc123' default_role = trainer;
CREATE OR REPLACE USER mainq2 password='abc123' default_role = trainer;

CREATE OR REPLACE ROLE trainer;
GRANT ROLE trainer TO ROLE sysadmin;

GRANT ROLE trainer TO USER longbv1;
GRANT ROLE trainer TO USER mainq2;

GRANT USAGE, MONITOR ON DATABASE PROJECT2 TO ROLE trainer;
GRANT USAGE, MONITOR ON SCHEMA PROJECT2.STAGE TO ROLE trainer;
GRANT USAGE, MONITOR ON SCHEMA PROJECT2.MODEL TO ROLE trainer;
GRANT USAGE, MONITOR ON SCHEMA PROJECT2.NDS TO ROLE trainer;
GRANT USAGE, MONITOR ON SCHEMA PROJECT2.UTILS TO ROLE trainer;

GRANT SELECT ON ALL TABLES IN SCHEMA PROJECT2.STAGE TO ROLE trainer;
GRANT SELECT ON ALL TABLES IN SCHEMA PROJECT2.MODEL TO ROLE trainer;
GRANT SELECT ON ALL TABLES IN SCHEMA PROJECT2.NDS TO ROLE trainer;
GRANT SELECT ON ALL TABLES IN SCHEMA PROJECT2.UTILS TO ROLE trainer;

GRANT MONITOR, OPERATE, USAGE ON WAREHOUSE PROJECT2_WH TO ROLE trainer;
GRANT MONITOR, OPERATE, USAGE ON WAREHOUSE POWERBI_WH TO ROLE trainer;
GRANT MONITOR, OPERATE, USAGE ON WAREHOUSE LOAD_WH TO ROLE trainer;

GRANT MONITOR ON ALL TASKS IN DATABASE PROJECT2 TO ROLE trainer;
