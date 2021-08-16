
import random
from faker import Faker
import pandas as pd
import pandas as pd
import numpy as np
from datetime import datetime  
from datetime import timedelta 
from shipcost import distance
from shipcost import shipping_cost

def Create_Record():
    Index_count=300
    fake = Faker()
    Faker.seed(0) 
    df=pd.DataFrame(columns=['Order_ID','Product_ID','Customer_ID','Product_Values','Unit_Cost',
    'General_Price','Tax','Profit','Total_Cost','Date_Order','Date_Ship','Date_due', 'Ship_Distance', 'Ship_Cost'])
    Ra_Pro=pd.read_csv('Raw_Product.csv')
    Ra_Cus=pd.read_csv('Raw_Customer.csv')
    Ra_Wah=pd.read_csv('Raw_Warehouse.csv')
    for i in range(Index_count):
        Order_ID=fake.random_int(0,56892)
        Pro_in=random.randint(1, len(Ra_Pro)-1)
        Cus_in=random.randint(0, len(Ra_Cus)-1)
        Wah_in=random.randint(0, len(Ra_Wah)-1)

        Product_ID=Ra_Pro['Product_ID'][Pro_in]
        Customer_ID=Ra_Cus['Customer_ID'][Cus_in]
        # diền ship vào đay ship là tiền ship (lat,long của cus,,,, lat long của warehosue)
        Ship_Distance = distance(Ra_Cus['Lat'][Cus_in],Ra_Cus['Long'][Cus_in],Ra_Wah['Lat'][Wah_in],Ra_Wah['Long'][Wah_in])
        Ship_Cost = shipping_cost(Ship_Distance)


        Product_Values = float(Ra_Pro['Standard_Cost'][Pro_in]) + float(Ra_Pro['General_Price'][Pro_in])
        Unit_Cost = Ra_Pro['Standard_Cost'][Pro_in]
        General_Price = Ra_Pro['General_Price'][Pro_in]
        Tax = Product_Values/10
        Profit = random.randint(5,30)
        Total_Cost = Product_Values*(100+Profit)/100 + Tax + Ship_Cost
        Date_Order = fake.date_between(start_date = '-5y', end_date = 'today')
        Date_Ship = fake.date_between(start_date = Date_Order, end_date = Date_Order + timedelta(days=10))   
        Date_due=fake.date_between(start_date = Date_Order, end_date = Date_Order + timedelta(days=10))
        
        to_append = [Order_ID,Product_ID, Customer_ID,Product_Values,Unit_Cost,General_Price,Tax
                    ,Profit,Total_Cost,Date_Order,Date_Ship,Date_due, Ship_Distance, Ship_Cost]
        a_series = pd.Series(to_append, index = df.columns)
        df = df.append(a_series, ignore_index=True)
        df.to_csv('Raw_Record.csv')
    return df
