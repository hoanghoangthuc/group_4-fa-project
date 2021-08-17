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
    - SnowSQL includes code and logs to automate loading and unloading data from snowflake and local.
    - SSIS includes project and file
- *Folder Resoure include Code generator data by python.
    - Config.json is file include number row of tables and time start and time end of record.
    - configparam.py is file have declare values from config to RD.py
    - Rawdata.py is file run code generate data from RD.py
    - RD.py is file have def create table, caculation,... to make data.
- *Doc is folder inclule flow, detail data, chema when begin(and end),...
## Generate Data by python (require python 3)
-  We work all in resouces folder, that have file name RawData.py to generator data. output is files CSV in folder Data/Raw, Data/Working. We use fake module to make fake data. 
### 1. We should have a path to the folder in local in Command Prompt to install module that required to run python.
--PATH (is where we have the folder contain all folder of project)

```bash
pip install resources/requirements.txt
```
### 2. Change rows of tables. In file Config.json: customer_record(customer line number), product_record(product line number), location_record(location line number), warehouse_record(warehouse line number), order_record(order line number), start_date(date start of record),end_date(date end of record).
### 3. Installation RawData (folder Data/Raw, Data/Working)
```bash
python resources/RawData.py
```
## SSIS (require: visual studio has integration service)
### 1 In visual code, go to file select open, click on project/solution. select file .sln in folder SSIS of the project.
### 2 Click right in background of control flow, select variables. and change values of ProjectPath, is
 ![image](https://user-images.githubusercontent.com/62283838/129654666-c335f3ab-3b7f-428c-9826-e9d312cecb91.png)






### Usage

```python
import foobar

# returns 'words'
foobar.pluralize('word')

# returns 'geese'
foobar.pluralize('goose')

# returns 'phenomenon'
foobar.singularize('phenomena')
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
