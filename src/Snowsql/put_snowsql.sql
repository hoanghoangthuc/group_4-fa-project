!set variable_substitution=true;


select CURRENT_TIMESTAMP, CURRENT_USER;
select 'Put file to STAGEGING.PRODUCT' as Process;



-- >> Copy from stage @Product to database.schema.table (product)
PUT file:///&{folder}/*Product*.csv @%Product;
COPY INTO PROJECT1.STAGE.Product file_format = CSV_FILE pattern = '.*Product.csv.gz' on_error = 'skip_file';

PUT file:///&{folder}/*Location*.csv @%Location;
COPY INTO PROJECT1.STAGE.Location file_format = CSV_FILE pattern = '.*Location.csv.gz' on_error = 'skip_file';

PUT file:///&{folder}/*Customer*.csv @%Customer;
COPY INTO PROJECT1.STAGE.Customer file_format = CSV_FILE pattern = '.*Customer.csv.gz' on_error = 'skip_file';

PUT file:///&{folder}/*Datetime*.csv @%Datetime;
COPY INTO PROJECT1.STAGE.Datetime file_format = CSV_FILE pattern = '.*Datetime.csv.gz' on_error = 'skip_file';

PUT file:///&{folder}/*Warehouse*.csv @%Warehouse;
COPY INTO PROJECT1.STAGE.Warehouse file_format = CSV_FILE pattern = '.*Warehouse.csv.gz' on_error = 'skip_file';

PUT file:///&{folder}/*Record*.csv @%Record;
COPY INTO PROJECT1.STAGE.Record file_format = CSV_FILE pattern = '.*Record.csv.gz' on_error = 'skip_file';
--!quit