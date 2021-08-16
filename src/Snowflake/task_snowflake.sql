
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
SCHEDULE="USING CRON 30 0 * * * UTC"
COMMENT="Master task job to trigger all other tasks"
AS select *
from table(information_schema.task_history())
order by scheduled_time;

-- task_location_customer
CREATE OR REPLACE TASK task_location_customer
WAREHOUSE=WAREHOUSE
COMMENT="Update Datetime Dimension"
AFTER task_master
AS CALL procLocation_customer();
 
-- task_location_warehouse
CREATE OR REPLACE TASK task_location_warehouse
WAREHOUSE=WAREHOUSE
COMMENT="Update Datetime Dimension"
AFTER task_location_customer
AS CALL procLocation_Warehouse();

-- task_Datetime
CREATE OR REPLACE TASK task_Datetime
WAREHOUSE=WAREHOUSE
COMMENT="Update Datetime Dimension"
AFTER task_location_warehouse
AS CALL proDATETIME();

-- task_Location
CREATE OR REPLACE TASK task_Warehouse
WAREHOUSE=WAREHOUSE
COMMENT="Update Warehouse Dimension"
AFTER task_Datetime
AS CALL proWarehouse();


-- task_Product
CREATE OR REPLACE TASK task_Product
WAREHOUSE=WAREHOUSE
COMMENT="Update Product Dimension"
AFTER task_Warehouse
AS CALL procProduct();

-- task_Product
CREATE OR REPLACE TASK task_Customer
WAREHOUSE=WAREHOUSE
COMMENT="Update Customer Dimension"
AFTER task_Product
AS CALL proCustomer();




--task_FactSales
CREATE OR REPLACE TASK task_FactRecord
WAREHOUSE=WAREHOUSE
COMMENT="Update FactRecord"
AFTER task_Customer
AS CALL proRecord();


--task_Cleanup
CREATE OR REPLACE TASK task_Cleanup
WAREHOUSE=WAREHOUSE
COMMENT="Truncate load tables after process completes"
AFTER task_FactRecord
AS CALL procCleanup();







