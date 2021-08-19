# PROJECT FA 01
## Please read this to understand what we do!
## I. DECSRIPTION OF THIS PROJECT
- *Business Question*: Minimizing transportation costs and warehouse allocation

- *Business Scenario*: E-commerce Service Company A is one of the large e-commerce companies capable of providing international products to customers. Items shipped domestically need at least 14 days of inspection before shipping to customers. Some products are stocked before and can be delivered to customers in a short time. To be able to supply products on company A well, it needs to have good supply warehouses for customers. Including warehouses in many provinces before shipping to customer addresses (districts, districts, wards). However, there are many costs that need to be optimized, such as the cost of storage and the cost of products supplied to the market, which is also an issue that needs to be calculated.

This project is for initializing and creating data pipeline to solve the aboved Business Question and Business Scenario
## ROOT Folder
![Root ffle](https://user-images.githubusercontent.com/62283838/129613523-993dae1c-1817-4082-b5f4-55c7e4f2e95f.PNG)
there is project's root folder. That shows what we work here
- *Folder Data include data train, data use, data Error, data raw and data working
    - Raw folder includes data after we generate data from python code.
    - Working folder includes the data after we generate the data from the python code, which we use all the '.csv' data in a way that is set to ssis and data errors (insufficient quality) into the files. '.txt'.
    - Directory errors include data audit and logging after running ssis and in SQL server.
    - Work folder includes data after ETL ssis and fetched from SQL server, we use this directory put in snowflake.
    - Export_snowflake includes the data that we download the data model from snowflake.
- *Folder Src include process with SQL, SSIS, Snowflake project and code.
    - MSSQL includes an init file to declare the schema before we run ssis and put the project related data into SQL server.
    - Snowflake includes an init file to declare the schema before we run ssis and inject data related to the Snowflake project, the data modeling process, and the task.
        -  connect_snowsql.bat is file run upload data from data/work to snowflake
        -  export_snowsql.bat is file down load data to folder data/export_snowflake
        -  put_snow.sql is code sql support upload data for connect_snowsql.bat 
        -  export_snowsql.sql is code sql support download data for export_snowsql.bat
        -  export_log.txt is record process with download data from snowflake
        -  snowsql_log.txt is record processs with upload data from snowflake
    - SnowSQL includes code and logs to automate loading and unloading data from snowflake and local.
        - init_snowflake.sql file set up table, schema, stage, database in snowflake
        - procedure_snowflake.sql file set producre in snowflake and call producre
        - task_snowflake.sql file set task and schedule to run procedure.
    - SSIS includes project and file to run ssis in visualcode
- *Folder Resoure include Code generator data by python.
    - Config.json is file include number row of tables and time start and time end of record.
    - configparam.py is file have declare values from config to RD.py
    - Rawdata.py is file run code generate data from RD.py
    - RD.py is file have def create table, caculation,... to make data.
- *Doc is folder inclule flow, detail data, chema when begin(and end),...
## detail of work
### 1. Design data pipeline [here](https://github.com/thuchh/group_4-fa-project/blob/main/Doc/flow.png)
### 2. Ingest data from flat file
### 3. Extract, ETL Data
### 4. Load new and changed data onto Snowflake
### 5. Build data model [schema](https://github.com/thuchh/group_4-fa-project/blob/main/Doc/Schema.png) with [detail](https://github.com/thuchh/group_4-fa-project/blob/main/Doc/detail%20of%20columns.xlsx)
### 6. Visualize data
## Generate Data by python (require python 3)
-  We work all in resouces folder, that have file name RawData.py to generator data. output is files CSV in folder Data/Raw, Data/Working. We use fake module to make fake data. 
 1. We should have a path to the folder in local in Command Prompt to install module that required to run python.
--PATH (is where we have the folder contain all folder of project)

```bash
pip install resources/requirements.txt
```
 2. Change rows of tables. In file Config.json: customer_record(customer line number), product_record(product line number), location_record(location line number), warehouse_record(warehouse line number), order_record(order line number), start_date(date start of record),end_date(date end of record).
 3. Installation RawData (folder Data/Raw, Data/Working)
```bash
python resources/RawData.py
```
###Install snowSQL:[Download](https://sfc-repo.snowflakecomputing.com/snowsql/index.html) 
###SSIS (require: visual studio has integration service, SQL server,SnowSQL)
1. go to src/MSSQL click init_SQL_install.SQL to init tables and trigger in to SQLserver. Name database is Project1.
2. go to src/Snowflake link:https://yr27995.southeast-asia.azure.snowflakecomputing.com/ and:
-  Take init_snowflake.sql, procedure_snowflake.sql task_snowflake.sql into 3 script query int snowflake.
-  Run init_snowflake in query first to declare model of data.
-  in file procedure, I have comment all call, If use, you shold open new querry in Snowflake.
-  You should run file procedure and task after you run init_snowflake
3. In visual code, go to file select open, click on project/solution. select file .sln in folder SSIS of the project.
4. Set folder of path:
- Click right in background of control flow, select variables. 
- In values of 'ProjectPath' in values box, change source to the folder contain the project.
- Click in all of other boxs '...' in expresssion. click evaluate expression and save. 
 ![image](https://user-images.githubusercontent.com/62283838/129654666-c335f3ab-3b7f-428c-9826-e9d312cecb91.png)
5. change connect manager to Project1 database in your SQL server. And make connection managerment in Solution Explorer board in to your Database.
6. Set up again SCD in stagging_location data flow task by click in that, set table view is Stagging.Location, set input columns is coppy of...(...same Dimension Columns), set type Key of Location is Bussiness key and click next. Next, in Dimension Columns add Address(1 house may has 2 address when they in update), in change type choice historical atrribute click next. Set 'columns to indicate current record' is post code,'Values when current' is current, 'expỉation value' is expired. And click finish.
7. Click F5 to run SSIS
8. When we see that finished load data to csv. It'll show Program, waiting and type passwork is"Nhat123456" You can change your account snowflake in both files .bat in /src/snowSQL/ by -a (account) -u (user) -d (Database) -w (warehouse) -s (stage) -r (role). 
9. Wait to finish SSIS. Data will go into SQLserver and snowflake cloud.
Set task schedule and process by run script of procedure_snowflake.sql task_snowflake.sql in snowflake 'snowflakecomputing.com/' 

### Download data by click file \src\Snowsql\export_snowflake.bat, You can see a status of put and download data by snowsql_log.txt(put), export_log(download)
You can take database from snowflake to build PowerBI

## link snowflake: https://yr27995.southeast-asia.azure.snowflakecomputing.com/
##account for trainer:
    - Miss Mai: Acc:'msmai' / pass:'12345678wa'
    = Mr Long: Acc:'Mrlong' / pass: '12345678wa'
## link powerBI https://app.powerbi.com/groups/me/reports/b6b77461-33f2-40c1-9aac-57b0612737fc/ReportSection
Thank You!
Nhat,Le Quang
Thuc, Hoang Hoang
