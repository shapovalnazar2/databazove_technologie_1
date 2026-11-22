
\set ON_ERROR_STOP on
\encoding UTF8

CREATE SCHEMA IF NOT EXISTS gold;


CREATE TABLE IF NOT EXISTS gold.dim_user (
    user_id INT PRIMARY KEY,
    gender CHAR(1) NOT NULL CHECK (gender IN ('M', 'F')),
    zip_code VARCHAR(10),
    age_group VARCHAR(20) NOT NULL,
    occupation VARCHAR(50) NOT NULL
);


CREATE TABLE IF NOT EXISTS gold.dim_movies (
    movie_id INT PRIMARY KEY,
    title TEXT NOT NULL,
    release_year INT,
    genres TEXT
);


CREATE TABLE IF NOT EXISTS gold.dim_date (
    date_id INT PRIMARY KEY,
    rated_at DATE NOT NULL,
    day INT NOT NULL,
    month INT NOT NULL,
    year INT NOT NULL,
    day_of_week INT NOT NULL,
    day_name VARCHAR(15),
    week INT NOT NULL,
    month_name VARCHAR(15),
    quarter INT NOT NULL
);


CREATE TABLE IF NOT EXISTS gold.dim_time (
    time_id INT PRIMARY KEY,
    rated_time TIME NOT NULL,
    hour INT NOT NULL,
    minute INT NOT NULL,
    second INT NOT NULL,
    time_of_day VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS gold.fact_rating (
    rating_id INT PRIMARY KEY,
    user_id INT NOT NULL REFERENCES gold.dim_user(user_id),
    movie_id INT NOT NULL REFERENCES gold.dim_movies(movie_id),
    date_id INT NOT NULL REFERENCES gold.dim_date(date_id),
    time_id INT NOT NULL REFERENCES gold.dim_time(time_id),
    rating NUMERIC(2,1) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_fact_rating_user
ON gold.fact_rating(user_id);

CREATE INDEX IF NOT EXISTS idx_fact_rating_movie
ON gold.fact_rating(movie_id);

CREATE INDEX IF NOT EXISTS idx_fact_rating_date
ON gold.fact_rating(date_id);

CREATE INDEX IF NOT EXISTS idx_fact_rating_time
ON gold.fact_rating(time_id);

BEGIN;

TRUNCATE TABLE
    gold.fact_rating,
    gold.dim_user,
    gold.dim_movies,
    gold.dim_date,
    gold.dim_time;


INSERT INTO gold.dim_user (
    user_id,
    gender,
    zip_code,
    age_group,
    occupation
)
SELECT
    u.user_id,
    u.gender,
    u.zip_code,
    COALESCE(a.age_group_name, 'unknown'),
    COALESCE(o.occupation_name, 'unknown')
FROM silver.stg_users u
LEFT JOIN silver.stg_age_group a
    ON a.age_group_id = u.age
LEFT JOIN silver.stg_occupations o
    ON o.occupation_id = u.occupation_id
ORDER BY u.user_id;


INSERT INTO gold.dim_movies (
    movie_id,
    title,
    release_year,
    genres
)
SELECT
    m.movie_id,
    m.title,
    m.release_year,
    COALESCE(
        STRING_AGG(g.genre_name, ', ' ORDER BY g.genre_name),
        'Unknown'
    ) AS genres
FROM silver.stg_movies m
LEFT JOIN silver.stg_genres_movies gm
    ON gm.movie_id = m.movie_id
LEFT JOIN silver.stg_genres g
    ON g.genre_id = gm.genre_id
GROUP BY
    m.movie_id,
    m.title,
    m.release_year
ORDER BY m.movie_id;


INSERT INTO gold.dim_date (
    date_id,
    rated_at,
    day,
    month,
    year,
    day_of_week,
    day_name,
    week,
    month_name,
    quarter
)
SELECT
    TO_CHAR(d, 'YYYYMMDD')::INT AS date_id,
    d AS rated_at,
    EXTRACT(DAY FROM d)::INT AS day,
    EXTRACT(MONTH FROM d)::INT AS month,
    EXTRACT(YEAR FROM d)::INT AS year,
    EXTRACT(ISODOW FROM d)::INT AS day_of_week,
    TRIM(TO_CHAR(d, 'Day')) AS day_name,
    EXTRACT(WEEK FROM d)::INT AS week,
    TRIM(TO_CHAR(d, 'Month')) AS month_name,
    EXTRACT(QUARTER FROM d)::INT AS quarter
FROM GENERATE_SERIES(
    (SELECT MIN(rated_at)::DATE FROM silver.stg_ratings),
    (SELECT MAX(rated_at)::DATE FROM silver.stg_ratings),
    INTERVAL '1 day'
) AS gs(d);


INSERT INTO gold.dim_time (
    time_id,
    rated_time,
    hour,
    minute,
    second,
    time_of_day
)
SELECT
    (sec / 3600) * 10000
        + ((sec / 60) % 60) * 100
        + sec % 60 AS time_id,

    MAKE_TIME(
        sec / 3600,
        (sec / 60) % 60,
        sec % 60
    ) AS rated_time,

    sec / 3600 AS hour,
    (sec / 60) % 60 AS minute,
    sec % 60 AS second,

    CASE
        WHEN sec / 3600 BETWEEN 5 AND 11 THEN 'morning'
        WHEN sec / 3600 BETWEEN 12 AND 17 THEN 'afternoon'
        WHEN sec / 3600 BETWEEN 18 AND 21 THEN 'evening'
        ELSE 'night'
    END AS time_of_day

FROM GENERATE_SERIES(0, 86399) AS gs(sec);


INSERT INTO gold.fact_rating (
    rating_id,
    user_id,
    movie_id,
    date_id,
    time_id,
    rating
)
SELECT
    r.rating_id,
    r.user_id,
    r.movie_id,
    TO_CHAR(r.rated_at::DATE, 'YYYYMMDD')::INT AS date_id,

    EXTRACT(HOUR FROM r.rated_at)::INT * 10000
        + EXTRACT(MINUTE FROM r.rated_at)::INT * 100
        + EXTRACT(SECOND FROM r.rated_at)::INT AS time_id,

    r.rating

FROM silver.stg_ratings r;

COMMIT;
