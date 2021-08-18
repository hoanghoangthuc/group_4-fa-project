USE ROLE ACCOUNTADMIN;
create user NhatLq3 password='Nhat123456' default_role = sysadmin must_change_password = true;
grant role sysadmin to user NhatLq3;
create user Msmai password='12345678wa' default_role = trainer must_change_password = true;
grant role sysadmin to user Msmai;
create user Mrlong password='12345678wa' default_role = trainer must_change_password = true;
grant role sysadmin to user Mrlong;

CREATE OR REPLACE ROLE trainer;
GRANT ROLE trainer TO ROLE sysadmin;

GRANT ROLE trainer TO USER Msmai;
GRANT ROLE trainer TO USER Mrlong;

GRANT USAGE, MONITOR ON DATABASE PROJECT1 TO ROLE trainer;
GRANT USAGE, MONITOR ON SCHEMA PROJECT1.STAGE TO ROLE trainer;
GRANT USAGE, MONITOR ON SCHEMA PROJECT1.NDS TO ROLE trainer;
GRANT USAGE, MONITOR ON SCHEMA PROJECT1.MODEL TO ROLE trainer;
GRANT USAGE, MONITOR ON SCHEMA PROJECT1.PUBLIC TO ROLE trainer;

GRANT SELECT ON ALL TABLES IN SCHEMA PROJECT1.STAGE TO ROLE trainer;
GRANT SELECT ON ALL TABLES IN SCHEMA PROJECT1.NDS TO ROLE trainer;
GRANT SELECT ON ALL TABLES IN SCHEMA PROJECT1.MODEL TO ROLE trainer;
GRANT SELECT ON ALL TABLES IN SCHEMA PROJECT1.PUBLIC TO ROLE trainer;