-- Active: 1791112921687@@127.0.0.1@5432@retail
CREATE DATABASE retail;

SELECT current_database();

CREATE TABLE retail_sales (
    invoice_no VARCHAR(20),
    stock_code VARCHAR(50),
    description TEXT,
    quantity INTEGER,
    invoice_date TIMESTAMP,
    unit_price NUMERIC(10, 2),
    customer_id INTEGER,
    country VARCHAR(100)
);

SELECT *
FROM retail_sales
LIMIT 20;

SELECT COUNT(*)
FROM retail_sales;


