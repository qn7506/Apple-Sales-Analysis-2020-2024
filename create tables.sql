-- Use the database
USE apple_sales;

-- Create table for each file and load file into table
-- Category
CREATE TABLE category (
category_id VARCHAR(50) PRIMARY KEY,
category_name VARCHAR(50) 
);

load data local infile 'd:/UAH GO CHARGERS/apple sales/category.csv'
into table category
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 lines;

-- Sales
CREATE TABLE sales (
sale_id VARCHAR(100),
sale_date VARCHAR(50),
store_id VARCHAR(50),
product_id VARCHAR(50),
quantity int
);

load data local infile 'd:/UAH GO CHARGERS/apple sales/sales.csv'
into table sales
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 lines;

UPDATE sales 
SET sale_date = STR_TO_DATE(sale_date, '%d/%m/%Y');
ALTER TABLE sales 
MODIFY COLUMN sale_date DATE;

-- Product 
CREATE TABLE product (
product_id VARCHAR(50) PRIMARY KEY,
product_name VARCHAR(50),
category VARCHAR(50),
launch_date VARCHAR(50),
price int
);

load data local infile 'd:/UAH GO CHARGERS/apple sales/products.csv'
into table product
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 lines;

-- Stores
CREATE TABLE stores (
store_id VARCHAR(50) PRIMARY KEY,
store_name VARCHAR(50),
city VARCHAR(50),
country VARCHAR(50)
);

load data local infile 'd:/UAH GO CHARGERS/apple sales/stores.csv'
into table stores
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 lines;



