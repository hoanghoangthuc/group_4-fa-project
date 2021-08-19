from RDcode import create_Warehouse
from RDcode import create_Customer
from RDcode import create_location
from RDcode import create_product
from RDcode import create_record
from configparam import ParamObject
from datetime import datetime
from RDcode import Rawurl
import os
from distutils.dir_util import copy_tree
def Raw():
    a=Rawurl()# take link of folder
    #create dir
    print('Create Location ')
    df_l=create_location(ParamObject.location_record)
    print('Create Warehouse ')
    df_w=create_Warehouse(ParamObject.warehouse_record,df_l)
    print('Create Customer ')
    df_C=create_Customer(ParamObject.customer_record,df_l)
    print('Create Product ')
    df_P=create_product(ParamObject.product_record,datetime.strptime(ParamObject.start_date, '%d-%m-%Y'),datetime.strptime(ParamObject.end_date, '%d-%m-%Y'),df_w)
    print('Create Record ')
    df_R=create_record(ParamObject.order_record,datetime.strptime(ParamObject.start_date, '%d-%m-%Y'),datetime.strptime(ParamObject.end_date, '%d-%m-%Y'),df_P,df_C,df_w)
    #to CSV file
    
    df_l.to_csv(a+'\Raw_Location.csv',index=False)
    df_w.to_csv(a+'\Raw_WareHouse.csv',index=False)
    df_C.to_csv(a+'\Raw_Customer.csv',index=False)
    df_P.to_csv(a+'\Raw_Product.csv',index=False)
    df_R.to_csv(a+'\Raw_Record.csv',index=False)



if __name__ == '__main__':
    print('Start Make Raw Data.....')
    Raw()   
    print('Done')
