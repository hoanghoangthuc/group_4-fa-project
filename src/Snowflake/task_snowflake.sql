
USE ROLE SYSADMIN;
USE DATABASE PROJECT1;
USE SCHEMA PUBLIC;
CREATE WAREHOUSE IF NOT EXISTS WAREHOUSE 
WITH WAREHOUSE_SIZE = 'MEDIUM'
WAREHOUSE_TYPE = 'STANDARD' 
AUTO_SUSPEND = 600 
AUTO_RESUME = TRUE 
MIN_CLUSTER_COUNT = 2 
MAX_CLUSTER_COUNT = 4 
SCALING_POLICY = 'STANDARD';

-- Create task
-- task_master:
CREATE OR REPLACE TASK task_master
WAREHOUSE=WAREHOUSE
SCHEDULE="5 MINUTE"
COMMENT="Master task job to trigger all other tasks"
AS select *
from table(information_schema.task_history())
order by scheduled_time;
-- task_location_customer nds
CREATE OR REPLACE TASK task_Location_customer_NDS
WAREHOUSE=WAREHOUSE
COMMENT="Update NDS Location_customer"
AFTER task_master
AS CALL pro_Location_customer_NDS();
 
-- task_location_warehouse nds
CREATE OR REPLACE TASK task_location_warehouse_NDS
WAREHOUSE=WAREHOUSE
COMMENT="Update NDS Location_warehouse"
AFTER task_Location_customer_NDS
AS CALL pro_Location_Warehouse_NDS();

-- task_Datetime nds
CREATE OR REPLACE TASK task_Datetime_NDS
WAREHOUSE=WAREHOUSE
COMMENT="Update Datetime Dimension"
AFTER task_location_warehouse_NDS
AS CALL pro_DATETIME_NDS();

-- task_warehouse nds
CREATE OR REPLACE TASK task_Warehouse_NDS
WAREHOUSE=WAREHOUSE
COMMENT="Update Warehouse Dimension"
AFTER task_Datetime_NDS
AS CALL pro_Warehouse_NDS();


-- task_Product nds
CREATE OR REPLACE TASK task_Product_NDS
WAREHOUSE=WAREHOUSE
COMMENT="Update Product Dimension"
AFTER task_Warehouse_NDS
AS CALL pro_Product_NDS();

-- task_customer nds
CREATE OR REPLACE TASK task_Customer_NDS
WAREHOUSE=WAREHOUSE
COMMENT="Update Customer Dimension"
AFTER task_Product_NDS
AS CALL pro_Customer_NDS();




--task_FactSales nds
CREATE OR REPLACE TASK task_FactRecord_NDS
WAREHOUSE=WAREHOUSE
COMMENT="Update FactRecord"
AFTER task_Customer_NDS
AS CALL pro_Record_NDS();

-- task_location_customer model
CREATE OR REPLACE TASK task_Location_customer_model
WAREHOUSE=WAREHOUSE
COMMENT="Update NDS Location_customer"
AFTER task_FactRecord_NDS
AS CALL pro_Location_customer_model();
 
-- task_location_warehouse model
CREATE OR REPLACE TASK task_location_warehouse_model
WAREHOUSE=WAREHOUSE
COMMENT="Update NDS Location_warehouse"
AFTER task_Location_customer_model
AS CALL pro_Location_Warehouse_model();

-- task_Datetime model
CREATE OR REPLACE TASK task_Datetime_model
WAREHOUSE=WAREHOUSE
COMMENT="Update Datetime Dimension"
AFTER task_location_warehouse_model
AS CALL pro_DATETIME_model();

-- task_warehouse_model
CREATE OR REPLACE TASK task_Warehouse_model
WAREHOUSE=WAREHOUSE
COMMENT="Update Warehouse Dimension"
AFTER task_Datetime_model
AS CALL pro_Warehouse_model();


-- task_Product
CREATE OR REPLACE TASK task_Product_model
WAREHOUSE=WAREHOUSE
COMMENT="Update Product Dimension"
AFTER task_Warehouse_model
AS CALL pro_Product_model();

-- task_Product
CREATE OR REPLACE TASK task_Customer_model
WAREHOUSE=WAREHOUSE
COMMENT="Update Customer Dimension"
AFTER task_Product_model
AS CALL pro_Customer_model();




--task_FactSales
CREATE OR REPLACE TASK task_FactRecord_model
WAREHOUSE=WAREHOUSE
COMMENT="Update FactRecord"
AFTER task_Customer_model
AS CALL pro_Record_model();

--task_Cleanup
CREATE OR REPLACE TASK task_Cleanup
WAREHOUSE=WAREHOUSE
COMMENT="Truncate load tables after process completes"
AFTER task_FactRecord_model
AS CALL pro_Cleanup_Stage();



ALTER TASK TASK_CLEANUP RESUME;
ALTER TASK task_FactRecord_model RESUME;
ALTER TASK task_Customer_model RESUME;
ALTER TASK task_Product_model RESUME;
ALTER TASK task_Datetime_model RESUME;
ALTER TASK task_location_warehouse_model RESUME;
ALTER TASK task_location_customer_model RESUME;
ALTER TASK task_FactRecord_nds RESUME;
ALTER TASK task_Customer_nds RESUME;
ALTER TASK task_Product_nds RESUME;
ALTER TASK task_Datetime_nds RESUME;
ALTER TASK task_location_warehouse_nds RESUME;
ALTER TASK task_location_customer_nds RESUME;
ALTER TASK task_master RESUME;




