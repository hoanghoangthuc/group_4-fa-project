import json
import os
class ParamObject:
    def __init__(self, customer_record, product_record, Location_record, warehouse_record,order_record,
                 start_date, end_date):
        self.customer_record = customer_record
        self.product_record = product_record
        self.location_record = Location_record
        self.warehouse_record = warehouse_record
        self.order_record=order_record
        self.start_date = start_date
        self.end_date = end_date
    def customer_record(self):
        return self.customer_record

    def product_record(self):
        return self.product_record

    def location_record(self):
        return self.location_record
        
    def warehouse_record(self):
        return self.warehouse_record

    def start_date(self):
        return self.start_date
        
    def end_date(self):
        return self.end_date
with open('Config.json') as json_data_file:
    data = json.load(json_data_file)
    for i in data:
        ParamObject.customer_record = data['parameters']['customer_record']
        ParamObject.product_record = data['parameters']['product_record']
        ParamObject.location_record = data['parameters']['location_record']
        ParamObject.warehouse_record = data['parameters']['warehouse_record']
        ParamObject.start_date = data['parameters']['start_date']
        ParamObject.end_date = data['parameters']['end_date']
