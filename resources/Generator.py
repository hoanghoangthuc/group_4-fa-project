from Codegenerate.Raw_Customer import create_csv_file_Raw_Customer
from Codegenerate.Raw_Location import Create_Location
from Codegenerate.Raw_Product  import create_Product
from Codegenerate.Raw_Warehouse import create_csv_file_Raw_Warehouse
from Codegenerate.Raw_Record import Create_Record
from datetime import datetime
from configparam import ParamObject
print(c)


customer_record = ParamObject.customer_record
product_record = ParamObject.product_record
location_record = ParamObject.location_record
warehouse_record = ParamObject.warehouse_record
order_record = ParamObject.order_record
update_start_date = datetime.strptime(ParamObject.start_date, '%d-%m-%Y')
update_end_date = datetime.strptime(ParamObject.end_date, '%d-%m-%Y')


if __name__ == '__main__':
    print('Generating a fake data...')
    create_csv_file_Raw_Customer(customer_record)
    create_Product(product_record,update_start_date, update_end_date)
    Create_Location(location_record)
    Create_Record(order_record, update_start_date, update_end_date)
    create_csv_file_Raw_Warehouse(warehouse_record)
    print('Done Generating Data...')
    print('Copy Data to Working Folder')
    print('Everything is Done!')