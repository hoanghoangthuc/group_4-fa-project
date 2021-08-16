from testlistint import generatePassword
import os
import random
from datetime import datetime
from decimal import Decimal
from faker import Faker
import pandas as pd
import numpy as np
fake = Faker()
Faker.seed(0) 
def create_csv_file_Raw_Warehouse():
    time_stampe = datetime.now().strftime("%Y_%m_%d-%I_%M_%S_%p")
    raw_path = os.path.dirname(__file__)
    Warehouse_ID=[]
    Warehouse_Name =[]
    Warehouse_cost = []
    current_location = []
    RECORD_COUNT = 6
    address=[]
    location_id=[]
    States=[]
    Lat=[]
    Long=[]
    datalocation=pd.read_csv('Raw_Location.csv')
    indexlocationk=generatePassword(RECORD_COUNT,len(datalocation))
    for i in range(RECORD_COUNT):
        Warehouse_ID.append(fake.random_int(0,6)),
        indexlocation=indexlocationk[i]
        Warehouse_cost.append(fake.random_int(30000,80000))
        indexlocationk.append(indexlocation)
        address.append(datalocation['Address'][indexlocation])
        location_id.append(datalocation['Location_ID'][indexlocation])
        States.append(datalocation['States'][indexlocation])
        Lat.append(datalocation['Lat'][indexlocation])
        Long.append(datalocation['Long'][indexlocation])
        Warehouse_Name.append(str(str(States[i])+'_WH'+str(indexlocation)))
        
    dict = {
        'Warehouse_ID': Warehouse_ID,
        'Warehouse_Name': Warehouse_Name,
        'Warehouse_cost': Warehouse_cost,
        'Location_ID':location_id,
        'Address':address,
        'States':States,
        'Lat':Lat,
        'Long': Long
    }

    df = pd.DataFrame(dict)
    df.to_csv('Raw_Warehouse.csv', index = None, header = True )    #lưu ý dấu ngoặc đơn
    return df