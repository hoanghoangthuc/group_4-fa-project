import os
import pandas as pd
os.chdir('..')
os.makedirs('Data', exist_ok=True)   
Datalink=os.getcwd()+'\Data'
os.chdir(Datalink)
Datalinks=os.getcwd()
os.makedirs('Raw', exist_ok=True)   
os.makedirs('Working', exist_ok=True)
Raw=Datalinks+'\Raw'
Woking=Datalinks+'\Working'
def Work_Customer():
    RC=pd.read_csv(Raw+'\Raw_Customer.csv')
    columns=['Customer_ID','name','job', 'company', 'ssn',
       'username',  'sex', 'mail', 'birthdate','Location_ID']
    RC=RC[columns]
    RC.to_csv(Woking+'\Working_Customer.csv',index=False)
def Work_Location():
    RC=pd.read_csv(Raw+'\Raw_Location.csv')
    RC.to_csv(Woking+'\Working_Location.csv',index=False)
def Work_Product():
    RC=pd.read_csv(Raw+'\Raw_Product.csv')
    columns=['Product_ID', 'Product_Name', 'Product_SubCategory',
       'Product_Color', 'Standard_Cost', 'General_Price', 'Product_Number',
       'Sale_DateStart', 'Sale_DateEnd', 'Import_Flag', 'Warehouse_ID']
    RC=RC[columns]
    RC.to_csv(Woking+'\Working_Product.csv',index=False)
def Work_Warehouse():
    RC=pd.read_csv(Raw+'\Raw_Warehouse.csv')
    columns=['Warehouse_ID', 'Warehouse_Name', 'Warehouse_cost', 'Location_ID']
    RC=RC[columns]
    RC.to_csv(Woking+'\Working_Warehouse.csv',index=False)
def Work_Record():
    RC=pd.read_csv(Raw+'\Raw_Record.csv')
    columns=['Order_ID', 'Product_ID', 'Customer_ID', 'Product_Values',
       'General_Price', 'Tax', 'Total_Cost', 'Date_Order',
       'Date_Ship', 'Date_due', 'Ship_Distance', 'Ship_Cost']
    RC=RC[columns]
    RC.to_csv(Woking+'\Working_Record.csv',index=False)