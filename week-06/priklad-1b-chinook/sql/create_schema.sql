-- Active: 1791112921687@@127.0.0.1@5432@chinook_dw
CREATE DATABASE chinook_dw;



CREATE SCHEMA IF NOT EXISTS chinook_dw;

SET search_path TO chinook_dw;

CREATE TABLE dim_date (
    date_key INTEGER PRIMARY KEY,
    full_date DATE NOT NULL,
    day INTEGER NOT NULL,
    month INTEGER NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    quarter INTEGER NOT NULL,
    year INTEGER NOT NULL
);

CREATE TABLE dim_customer (
    customer_key INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    company VARCHAR(80),
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(40),
    UNIQUE (customer_id)
);

CREATE TABLE dim_track (
    track_key INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    track_id INTEGER NOT NULL,
    track_name VARCHAR(200) NOT NULL,
    album_title VARCHAR(160),
    artist_name VARCHAR(120),
    genre_name VARCHAR(120),
    media_type VARCHAR(120),
    composer VARCHAR(220),
    milliseconds INTEGER,
    bytes INTEGER,
    UNIQUE (track_id)
);

CREATE TABLE dim_location (
    location_key INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    city VARCHAR(80),
    state VARCHAR(80),
    country VARCHAR(80),
    UNIQUE NULLS NOT DISTINCT (city, state, country)
);


CREATE TABLE fact_sales (
    sales_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    invoice_line_id INTEGER NOT NULL UNIQUE,
    invoice_id INTEGER NOT NULL,
    date_key INTEGER NOT NULL REFERENCES dim_date(date_key),
    customer_key INTEGER NOT NULL REFERENCES dim_customer(customer_key),
    track_key INTEGER NOT NULL REFERENCES dim_track(track_key),
    location_key INTEGER NOT NULL REFERENCES dim_location(location_key),
    quantity INTEGER NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    sales_amount NUMERIC(12,2) NOT NULL
);


SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_schema = 'chinook_dw'
ORDER BY table_name;