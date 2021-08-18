

USE ROLE SYSADMIN;
USE WAREHOUSE STAGE;
USE DATABASE PROJECT1;
USE SCHEMA STAGE;

--pro_Location_customer_NDS--
CREATE OR REPLACE PROCEDURE pro_Location_customer_NDS()
RETURNS string
LANGUAGE javascript
AS
$$
var result;
var sql_command1=
   `UPDATE PROJECT1.NDS.Location_CUSTOMER tag
    SET tag.Address=n.Address,tag.Lat=n.Lat ,tag.Long=n.Long ,tag.Post_Code=n.Post_Code,tag.City=n.City,tag.Country_code=n.Country_code,tag.Country_name=n.Country_name,tag.States=n.States
    FROM PROJECT1.NDS.Location_CUSTOMER n
    INNER JOIN
    (SELECT t.LOCATION_NA, Address,Lat ,Long ,Post_Code,City,Country_code,Country_name,States
     FROM PROJECT1.STAGE.LOCATION t
     inner join PROJECT1.STAGE.Customer p 
     on t.location_na=p.location_na  ) d
    ON d.Location_Na=n.Location_NA;`;
var sql_command2 =
    `INSERT INTO  PROJECT1.NDS.Location_CUSTOMER(LOCATION_NA, Address,Lat ,Long ,Post_Code,City,Country_code,Country_name,States)
    SELECT distinct p.LOCATION_NA, p.Address,p.Lat ,p.Long ,p.Post_Code,p.City,p.Country_code,p.Country_name,p.States
    FROM PROJECT1.STAGE.Location p
    INNER JOIN PROJECT1.STAGE.CUSTOMER n
    ON p.LOCATION_NA=n.LOCATION_NA 
    Where p.Location_NA not in (Select Location_NA from PROJECT1.NDS.Location_CUSTOMER);`;
    
 try {
snowflake.execute ({sqlText: sql_command1});
snowflake.execute ({sqlText: sql_command2});
result = "Succeeded";
}
catch (err) {
result = "Failed"+err;
}
return result;
$$;
--pro_Location_customer_Model--
CREATE OR REPLACE PROCEDURE pro_Location_customer_Model()
RETURNS string
LANGUAGE javascript
AS
$$
var result;
var sql_command =
`MERGE INTO PROJECT1.MODEL.DIMLOCATION_Customer t
USING PROJECT1.NDS.Location_customer s
ON t.Location_ID = s.Location_ID
WHEN matched THEN
UPDATE SET t.Lat = s.Lat, t.Long = s.Long, t.Address = s.Address, t.City = s.City
WHEN NOT matched THEN
INSERT (Location_ID, Address,Lat ,Long ,Post_Code,City,Country_code,Country_name,States)
VALUES (Location_ID, Address,Lat ,Long ,Post_Code,City,Country_code,Country_name,States);`;
 try {
snowflake.execute ({sqlText: sql_command});
result = "Succeeded";
}
catch (err) {
result = "Failed"+err;
}
return result;
$$;

--pro warehouse nds--
CREATE OR REPLACE PROCEDURE pro_Location_Warehouse_NDS()
RETURNS string
LANGUAGE javascript
AS
$$
var result;
var sql_command1=
   `UPDATE PROJECT1.NDS.Location_Warehouse tag
    SET tag.Address=n.Address,tag.Lat=n.Lat ,tag.Long=n.Long ,tag.Post_Code=n.Post_Code,tag.City=n.City,tag.Country_code=n.Country_code,tag.Country_name=n.Country_name,tag.States=n.States
    FROM PROJECT1.NDS.Location_Warehouse n
    INNER JOIN
    (SELECT t.LOCATION_NA, Address,Lat ,Long ,Post_Code,City,Country_code,Country_name,States
     FROM PROJECT1.STAGE.LOCATION t
     inner join PROJECT1.STAGE.warehouse p 
     on t.location_na=p.location_na  ) d
    ON d.Location_Na=n.Location_NA;`;
var sql_command2 =
    `INSERT INTO  PROJECT1.NDS.Location_Warehouse(LOCATION_NA, Address,Lat ,Long ,Post_Code,City,Country_code,Country_name,States)
    SELECT distinct  p.LOCATION_NA, p.Address,p.Lat ,p.Long ,p.Post_Code,p.City,p.Country_code,p.Country_name,p.States
    FROM PROJECT1.STAGE.Location p
    INNER JOIN PROJECT1.STAGE.warehouse n
    ON p.LOCATION_NA=n.LOCATION_NA 
    Where p.Location_NA not in (Select Location_NA from PROJECT1.NDS.Location_Warehouse);`;
try {
snowflake.execute ({sqlText: sql_command1});
snowflake.execute ({sqlText: sql_command2}); 
result = "Succeeded";
}
catch (err) {
result = "Failed"+err;
}
return result;
$$;
--pro warehouse model--
CREATE OR REPLACE PROCEDURE pro_Location_Warehouse_model()
RETURNS string
LANGUAGE javascript
AS
$$
var result;
var sql_command2 =
`MERGE INTO PROJECT1.MODEL.DIMLOCATION_Warehouse t
USING PROJECT1.NDS.Location_warehouse s
ON t.Location_ID = s.Location_ID
WHEN matched THEN
UPDATE SET t.Lat = s.Lat, t.Long = s.Long, t.Address = s.Address, t.City = s.City
WHEN NOT matched THEN
INSERT (Location_ID, Address,Lat ,Long ,Post_Code,City,Country_code,Country_name,States)
VALUES (Location_ID, Address,Lat ,Long ,Post_Code,City,Country_code,Country_name,States);`;

try {
snowflake.execute ({sqlText: sql_command2}); 
result = "Succeeded";
}
catch (err) {
result = "Failed"+err;
}
return result;
$$;

CREATE OR REPLACE PROCEDURE pro_Customer_NDS()
RETURNS string
LANGUAGE javascript
AS
$$
var result;
var sql_command1=
   `UPDATE PROJECT1.NDS.Customer tag
    SET tag.name=n.name ,tag.username=n.username ,tag.sex=n.sex,tag.mail=n.mail,tag.birthdate=n.birthdate,
    tag.Location_Na=n.Location_Na,tag.Phone=n.Phone
    FROM PROJECT1.Stage.Customer n
    where n.Customer_Na=tag.Customer_Na;`;
var sql_command2 =
`INSERT INTO  PROJECT1.NDS.Customer(Customer_Na,name, username,sex ,mail ,birthdate,Location_Na,Phone)
    SELECT distinct p.Customer_Na, p.name, p.username,p.sex ,p.mail ,p.birthdate,p.Location_Na,p.Phone
    FROM PROJECT1.STAGE.Customer p
    INner JOIN  PROJECT1.NDS.Location_CUstomer t
    ON p.Location_Na=t.Location_Na
    Where p.Customer_Na not in (Select Customer_NA from PROJECT1.NDS.Customer);`;
var sql_command3 =
`UPDATE  PROJECT1.NDS.Customer Cus
SET Cus.Location_ID=d.Location_ID
FROM PROJECT1.NDS.Customer t
INNER JOIN
PROJECT1.NDS.Location_Customer d
ON d.Location_Na=t.Location_NA;`;
try {
snowflake.execute ({sqlText: sql_command1});
snowflake.execute ({sqlText: sql_command2});
snowflake.execute ({sqlText: sql_command3}); 
result = "Succeeded";
}
catch (err) {
result = "Failed"+err;
}
return result;
$$;


CREATE OR REPLACE PROCEDURE pro_Customer_Model()
RETURNS string
LANGUAGE javascript
AS
$$
var result;
var sql_command1=
`MERGE INTO PROJECT1.MODEL.DIMCUSTOMER t
USING PROJECT1.NDS.Customer s
ON t.Customer_ID = s.Customer_ID
WHEN matched THEN
UPDATE SET t.Customer_ID=s.Customer_ID,t.name=s.name ,t.username=s.username,t.sex=s.sex ,t.mail=s.mail ,t.birthdate=s.birthdate,
           t.Phone=s.Phone,t.Location_ID=s.Location_ID
WHEN NOT matched THEN
INSERT (Customer_ID,name, username,sex ,mail ,birthdate,Phone,Location_ID)
VALUES (Customer_ID,name, username,sex ,mail ,birthdate,Phone,Location_ID);`;
try {
snowflake.execute ({sqlText: sql_command1});
result = "Succeeded";
}
catch (err) {
result = "Failed"+err;
}
return result;
$$;


CREATE OR REPLACE PROCEDURE pro_Warehouse_NDS()
RETURNS string
LANGUAGE javascript
AS
$$
var result;
var sql_command1=
   `UPDATE PROJECT1.NDS.Warehouse tag
    SET tag.Warehouse_Name=n.Warehouse_Name ,tag.Warehouse_cost=n.Warehouse_cost ,tag.Location_Na=n.Location_Na
    FROM PROJECT1.Stage.warehouse n
    where n.warehouse_NA=tag.Warehouse_Na;`;

var sql_command2 =
`INSERT INTO  PROJECT1.NDS.Warehouse(Warehouse_Na,Warehouse_Name, Warehouse_cost,Location_Na)
    SELECT distinct p.Warehouse_Na, p.Warehouse_Name, p.Warehouse_cost,p.Location_Na
    FROM PROJECT1.STAGE.Warehouse p
    INNER JOIN  PROJECT1.NDS.Location_Warehouse t
    ON p.Location_Na=t.Location_Na
    Where p.Warehouse_Na not in (Select Warehouse_Na from PROJECT1.NDS.Warehouse);`;

var sql_command3 =
`UPDATE  PROJECT1.NDS.Warehouse Wa
SET Wa.Location_ID=d.Location_ID
FROM PROJECT1.NDS.Warehouse t
INNER JOIN
PROJECT1.NDS.Location_Warehouse d
ON d.Location_Na=t.Location_NA;`;



try {
snowflake.execute ({sqlText: sql_command1});
snowflake.execute ({sqlText: sql_command2});
snowflake.execute ({sqlText: sql_command3}); 
result = "Succeeded";
}
catch (err) {
result = "Failed"+err;
}
return result;
$$;

CREATE OR REPLACE PROCEDURE pro_Warehouse_model()
RETURNS string
LANGUAGE javascript
AS
$$
var result;
var sql_command2 =
`MERGE INTO PROJECT1.MODEL.DIMWAREHOUSE t
USING PROJECT1.NDS.Warehouse s
ON t.Warehouse_ID = s.Warehouse_ID
WHEN matched THEN
UPDATE SET t.Warehouse_ID=s.Warehouse_ID,t.Warehouse_Name=s.Warehouse_Name ,t.Warehouse_cost=s.Warehouse_cost,t.Location_ID=s.Location_ID      
WHEN NOT matched THEN
INSERT (Warehouse_ID,Warehouse_Name, Warehouse_cost,Location_ID)
VALUES (Warehouse_ID,Warehouse_Name, Warehouse_cost,Location_ID);`;


try {
snowflake.execute ({sqlText: sql_command2});
result = "Succeeded";
}
catch (err) {
result = "Failed"+err;
}
return result;
$$;

CREATE OR REPLACE PROCEDURE pro_Product_Nds()
RETURNS string
LANGUAGE javascript
AS

$$
var result;

var sql_command1=
   `UPDATE PROJECT1.NDS.Product tag
    SET tag.Product_Name=t.Product_Name, tag.Product_SubCategory=t.Product_SubCategory,tag.Product_Color=t.Product_Color,
    tag.Standard_Cost=t.Standard_Cost,tag.General_Price=t.General_Price,tag.Product_Number=t.Product_Number,
    tag.Sale_DateStart=t.Sale_DateStart,tag.Sale_DateEnd=t.Sale_DateEnd,
    tag.Import_Flag=t.Import_Flag,tag.Warehouse_Na=t.Warehouse_Na
    FROM PROJECT1.Stage.Product t
    where t.product_na=tag.product_na;`;
var sql_command2 =
`INSERT INTO  PROJECT1.NDS.Product(Product_Na,Product_Name, Product_SubCategory,Product_Color ,Standard_Cost,General_Price,Product_Number,Sale_DateStart,Sale_DateEnd,Import_Flag,Warehouse_Na)
    SELECT distinct p.Product_Na,p.Product_Name, p.Product_SubCategory,p.Product_Color ,p.Standard_Cost,p.General_Price,p.Product_Number,p.Sale_DateStart,p.Sale_DateEnd,p.Import_Flag,p.Warehouse_Na
    FROM PROJECT1.STAGE.Product p
    Inner JOIN  PROJECT1.NDS.Warehouse t
    ON p.Warehouse_Na=t.Warehouse_Na
    Where p.Product_Na not in (Select Product_NA from PROJECT1.NDS.Product);`;

var sql_command3 =
`UPDATE  PROJECT1.NDS.Product Pr
SET Pr.WAREHOUSE_ID=d.Warehouse_ID
FROM PROJECT1.NDS.Product t
INNER JOIN
PROJECT1.NDS.Warehouse d
ON d.Warehouse_NA=t.Warehouse_Na;`;



try {
snowflake.execute ({sqlText: sql_command1});
snowflake.execute ({sqlText: sql_command2});
snowflake.execute ({sqlText: sql_command3}); 
result = "Succeeded";
}
catch (err) {
result = "Failed"+err;
}
return result;
$$;


CREATE OR REPLACE PROCEDURE pro_Product_model()
RETURNS string
LANGUAGE javascript
AS

$$
var result;

var sql_command1 =
`MERGE INTO PROJECT1.MODEL.DIMPRODUCT t
USING PROJECT1.NDS.Product s
ON t.PRODUCT_ID = s.PRODUCT_ID
WHEN matched THEN
UPDATE SET t.Product_ID=s.Product_ID,t.Product_Name=s.Product_Name, t.Product_SubCategory=s.Product_SubCategory,t.Product_Color=s.Product_Color ,t.Standard_Cost=s.Standard_Cost,t.General_Price=s.General_Price,
            t.Product_Number=s.Product_Number,t.Sale_DateStart=s.Sale_DateStart,t.Sale_DateEnd=s.Sale_DateEnd,t.Import_Flag=s.Import_Flag,t.Warehouse_ID=s.Warehouse_ID    
WHEN NOT matched THEN
INSERT (Product_ID,Product_Name, Product_SubCategory,Product_Color ,Standard_Cost,General_Price,Product_Number,Sale_DateStart,Sale_DateEnd,Import_Flag,Warehouse_ID)
VALUES (Product_ID,Product_Name, Product_SubCategory,Product_Color ,Standard_Cost,General_Price,Product_Number,Sale_DateStart,Sale_DateEnd,Import_Flag,Warehouse_ID);`;



try {
snowflake.execute ({sqlText: sql_command1});
result = "Succeeded";
}
catch (err) {
result = "Failed"+err;
}
return result;
$$;
CREATE OR REPLACE PROCEDURE pro_DATETIME_NDS()
RETURNS string
LANGUAGE javascript
AS
$$
var result;
var sql_command1 =
`INSERT INTO  PROJECT1.NDS.Datetime 
    SELECT distinct*
    FROM PROJECT1.STAGE.Datetime p
    Where Thedate not in (Select Thedate from PROJECT1.NDS.Datetime);`;
try {
snowflake.execute ({sqlText: sql_command1});
result = "Succeeded";
}
catch (err) {
result = "Failed"+err;
}
return result;
$$;

CREATE OR REPLACE PROCEDURE pro_DATETIME_model()
RETURNS string
LANGUAGE javascript
AS
$$
var result;
var sql_command1 =
`INSERT INTO  PROJECT1.MODEL.DIMDATE
    SELECT *
    FROM PROJECT1.NDS.Datetime p
    Where Thedate not in (Select Thedate from PROJECT1.MODEL.DIMDATE);`;
try {
snowflake.execute ({sqlText: sql_command1});
result = "Succeeded";
}
catch (err) {
result = "Failed"+err;
}
return result;
$$;

CREATE OR REPLACE PROCEDURE pro_Record_NDS()
RETURNS string
LANGUAGE javascript
AS
$$
var result;
var sql_command1=
   `UPDATE PROJECT1.NDS.record tag
    SET tag.Product_Na=t.Product_Na, tag.Customer_Na=t.Customer_Na,tag.Product_Values=t.Product_Values,
    tag.General_Price=t.General_Price,tag.Tax=t.Tax,tag.Total_Cost=t.Total_Cost,
    tag.Date_Order=t.Date_Order,tag.Date_Ship=t.Date_Ship,tag.Ship_Cost=t.Ship_Cost,
    tag.Date_due=t.Date_due,tag.Ship_Distance=t.Ship_Distance
    FROM PROJECT1.Stage.record t
    where t.Order_Na=tag.Order_Na;`;
var sql_command2 =
`INSERT INTO  PROJECT1.NDS.Record(Order_Na,Product_Na, Customer_Na ,Product_Values,General_Price,Tax,Total_Cost,Date_Order,Date_Ship,Date_due,Ship_Distance,Ship_Cost)
    SELECT DISTINCT  p.Order_Na,p.Product_Na, p.Customer_Na,p.Product_Values,p.General_Price,p.Tax,p.Total_Cost,p.Date_Order,p.Date_Ship,p.Date_due,p.Ship_Distance,p.Ship_Cost
    FROM PROJECT1.STAGE.Record p
    Inner JOIN  PROJECT1.NDS.Customer c
    ON p.Customer_Na=c.Customer_Na
    Inner JOIN  PROJECT1.NDS.Product t
    ON p.Product_Na=t.Product_Na
    Where p.Order_Na not in (Select Order_Na from PROJECT1.NDS.Record);`;
    
var sql_command3 =
`UPDATE  PROJECT1.NDS.Record Pr
SET Pr.Customer_ID=d.Customer_ID
FROM PROJECT1.NDS.Record t
INNER JOIN
PROJECT1.NDS.Customer d
ON d.Customer_Na=t.Customer_Na;`;

var sql_command4 =
`UPDATE  PROJECT1.NDS.Record Pr
SET Pr.Product_ID=d.Product_ID
FROM PROJECT1.NDS.Record t
INNER JOIN
PROJECT1.NDS.Product d
ON d.Product_NA=t.Product_NA;`;


try {
snowflake.execute ({sqlText: sql_command1});
snowflake.execute ({sqlText: sql_command2});
snowflake.execute ({sqlText: sql_command3});
snowflake.execute ({sqlText: sql_command4}); 
result = "Succeeded";
}
catch (err) {
result = "Failed"+err;
}
return result;
$$;
CREATE OR REPLACE PROCEDURE pro_Record_model()
RETURNS string
LANGUAGE javascript
AS
$$
var result;
var sql_command2 =
`MERGE INTO PROJECT1.MODEL.FACTRECORD t
USING PROJECT1.NDS.RECORD s
ON t.ORDER_ID = s.ORDER_ID
WHEN matched THEN
UPDATE SET t.ORDER_ID=s.ORDER_ID,t.PRODUCT_ID=s.PRODUCT_ID, t.CUSTOMER_ID=s.CUSTOMER_ID,t.PRODUCT_VALUES=s.PRODUCT_VALUES ,t.GENERAL_PRICE=s.GENERAL_PRICE,t.TAX=s.TAX,
            t.TOTAL_COST=s.TOTAL_COST,t.DATE_ORDER=s.DATE_ORDER,t.DATE_SHIP=s.DATE_SHIP,t.DATE_DUE=s.DATE_DUE,t.SHIP_DISTANCE=s.SHIP_DISTANCE, t.SHIP_COST=s.SHIP_COST    
WHEN NOT matched THEN
INSERT (ORDER_ID,PRODUCT_ID, CUSTOMER_ID,PRODUCT_VALUES,GENERAL_PRICE,TAX,TOTAL_COST,DATE_ORDER,DATE_SHIP,DATE_DUE,SHIP_DISTANCE,SHIP_COST)
VALUES (ORDER_ID,PRODUCT_ID, CUSTOMER_ID ,PRODUCT_VALUES,GENERAL_PRICE,TAX,TOTAL_COST,DATE_ORDER,DATE_SHIP,DATE_DUE,SHIP_DISTANCE,SHIP_COST);`;


try {
snowflake.execute ({sqlText: sql_command2});
result = "Succeeded";
}
catch (err) {
result = "Failed"+err;
}
return result;
$$;

CREATE OR REPLACE PROCEDURE pro_Cleanup_Stage()
RETURNS string
LANGUAGE javascript
AS
$$
var result;
var sql_command1 ='TRUNCATE PROJECT1.STAGE.LOCATION;';
var sql_command2 ='TRUNCATE PROJECT1.STAGE.CUSTOMER;';
var sql_command3 ='TRUNCATE PROJECT1.STAGE.WAREHOUSE;';
var sql_command4 ='TRUNCATE PROJECT1.STAGE.DATETIME;';
var sql_command5 ='TRUNCATE PROJECT1.STAGE.PRODUCT;';
var sql_command6 ='TRUNCATE PROJECT1.STAGE.RECORD;';


try {
snowflake.execute ({sqlText: sql_command1});
snowflake.execute ({sqlText: sql_command2}); 
snowflake.execute ({sqlText: sql_command3}); 
snowflake.execute ({sqlText: sql_command4}); 
snowflake.execute ({sqlText: sql_command5}); 
snowflake.execute ({sqlText: sql_command6}); 
result = "Succeeded";
}
catch (err) {
result = "Failed"+err;
}
return result;
$$;

CALL pro_Location_customer_NDS();
CALL pro_Location_Warehouse_NDS();
CALL pro_DATETIME_NDS();
CALL pro_Warehouse_NDS();
CALL pro_Product_NDS();
CALL pro_Customer_NDS();
CALL pro_Record_NDS();
CALL pro_Location_customer_model();
CALL pro_Location_Warehouse_model();
CALL pro_DATETIME_model();
CALL pro_Warehouse_model();
CALL pro_Product_model();
CALL pro_Customer_model();
CALL pro_Record_model();
CALL pro_Cleanup_Stage();