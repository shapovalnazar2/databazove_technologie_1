-- Active: 1791112921687@@127.0.0.1@5432@Pagila
CREATE TABLE dim_country (
    country_id INT PRIMARY KEY,
    country VARCHAR(50) NOT NULL
);

CREATE TABLE dim_city (
    city_id INT PRIMARY KEY,
    city VARCHAR(50) NOT NULL,
    country_id INT NOT NULL,
    CONSTRAINT fk_city_country FOREIGN KEY (country_id) REFERENCES dim_country(country_id)
);

CREATE TABLE dim_address (
    address_id INT PRIMARY KEY,
    address VARCHAR(50) NOT NULL,
    address2 VARCHAR(50),
    district VARCHAR(50),
    city_id INT NOT NULL,
    postal_code VARCHAR(10),
    phone VARCHAR(20),
    CONSTRAINT fk_address_city FOREIGN KEY (city_id) REFERENCES dim_city(city_id)
);

CREATE TABLE dim_language (
    language_id INT PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);

CREATE TABLE dim_film (
    film_id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    release_year INT,
    language_id INT NOT NULL,
    rental_duration SMALLINT,
    rental_rate DECIMAL(4,2),
    length SMALLINT,
    replacement_cost DECIMAL(5,2),
    rating VARCHAR(10),
    CONSTRAINT fk_film_language FOREIGN KEY (language_id) REFERENCES dim_language(language_id)
);

CREATE TABLE dim_category (
    category_id INT PRIMARY KEY,
    name VARCHAR(25) NOT NULL
);

CREATE TABLE bridge_film_category (
    film_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (film_id, category_id),
    CONSTRAINT fk_bridge_film FOREIGN KEY (film_id) REFERENCES dim_film(film_id),
    CONSTRAINT fk_bridge_category FOREIGN KEY (category_id) REFERENCES dim_category(category_id)
);

CREATE TABLE dim_customer (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    email VARCHAR(50),
    active SMALLINT,
    address_id INT NOT NULL,
    CONSTRAINT fk_customer_address FOREIGN KEY (address_id) REFERENCES dim_address(address_id)
);

CREATE TABLE dim_store (
    store_id INT PRIMARY KEY,
    address_id INT NOT NULL,
    CONSTRAINT fk_store_address FOREIGN KEY (address_id) REFERENCES dim_address(address_id)
);

CREATE TABLE dim_staff (
    staff_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(50),
    active SMALLINT,
    store_id INT NOT NULL,
    address_id INT NOT NULL,
    CONSTRAINT fk_staff_address FOREIGN KEY (address_id) REFERENCES dim_address(address_id),
    CONSTRAINT fk_staff_store FOREIGN KEY (store_id) REFERENCES dim_store(store_id)
);

CREATE TABLE dim_date (
    date_id INT PRIMARY KEY,
    full_date DATE NOT NULL,
    day INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(15) NOT NULL,
    quarter INT NOT NULL,
    year INT NOT NULL
);


CREATE TABLE fact_rental (
    fact_rental_id SERIAL PRIMARY KEY,
    rental_id INT NOT NULL,
    inventory_id INT NOT NULL,
    film_id INT NOT NULL,
    customer_id INT NOT NULL,
    staff_id INT NOT NULL,
    store_id INT NOT NULL,
    rental_date_id INT NOT NULL,
    rental_rate DECIMAL(4,2) NOT NULL,
    replacement_cost DECIMAL(5,2) NOT NULL,
    
    CONSTRAINT fk_fact_film FOREIGN KEY (film_id) REFERENCES dim_film(film_id),
    CONSTRAINT fk_fact_customer FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
    CONSTRAINT fk_fact_staff FOREIGN KEY (staff_id) REFERENCES dim_staff(staff_id),
    CONSTRAINT fk_fact_store FOREIGN KEY (store_id) REFERENCES dim_store(store_id),
    CONSTRAINT fk_fact_date FOREIGN KEY (rental_date_id) REFERENCES dim_date(date_id)
);



