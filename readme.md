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
    - Folder Raw include data after we generate data from code python
    - Folder Working include data after we generate data from code python, that we use all data '.csv' by put to ssis, and data error (not enough quality) into '.txt' files.
    - Folder Error include data audit and log after run ssis and during SQL server.
    - Folder work include data after ETL ssis and take from SQL server, we use this folder that put to snowflake.
    - Export_snowflake  include data we download data model from snowflake.
- *Folder Src include process with SQL, SSIS, Snowflake project and code.
    - MSSQL include init file to declare schema before we run ssis and put data relate with project in SQL server.
    - Snowflake include init file to declare schema before we run ssis and put data relate with project Snowflake, procedure to process create data model and task.
    - SnowSQL include code and log to automation put and download data from snowflake and local.
    - SSIS include project and file
- *Folder Resoure include Code generator data by python.
    - Config.json is file include number row of tables and time start and time end of record.
    - configparam.py is file have declare values from config to RD.py
    - Rawdata.py is file run code generate data from RD.py
    - RD.py is file have def create table, caculation,... to make data.
- *Doc is folder inclule flow, detail data, chema when begin(and end),...
## Generate Data by python
-  We work all in resouces folder, that have file name RawData.py to generator data. output is files CSV in folder Data/Raw, Data/Working.  
### 1. We should have a path to the folder in local in Command Prompt to install module that required to run python.
--PATH (is where we have the folder contain all folder of project)

```bash
pip install Source/requirements.txt
```
### 2. Installation RawData 
Data that generator by code. Source 'csv' is gone './Data/Raw'
```bash
python Source/RawData.py
```




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
