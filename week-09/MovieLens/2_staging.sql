
\set ON_ERROR_STOP on
\encoding UTF8

CREATE SCHEMA IF NOT EXISTS silver;

CREATE OR REPLACE VIEW silver.stg_users AS
SELECT
    NULLIF(TRIM(id), '')::INT AS user_id,
    NULLIF(TRIM(age), '')::INT AS age,
    UPPER(NULLIF(TRIM(gender), '')) AS gender,
    NULLIF(TRIM(occupation_id), '')::INT AS occupation_id,
    NULLIF(TRIM(zip_code), '') AS zip_code
FROM bronze.users;

CREATE OR REPLACE VIEW silver.stg_ratings AS
SELECT
    NULLIF(TRIM(id), '')::INT AS rating_id,
    NULLIF(TRIM(user_id), '')::INT AS user_id,
    NULLIF(TRIM(movie_id), '')::INT AS movie_id,
    NULLIF(TRIM(rating), '')::NUMERIC(2,1) AS rating,
    NULLIF(TRIM(rated_at), '')::TIMESTAMP AS rated_at
FROM bronze.ratings;

CREATE OR REPLACE VIEW silver.stg_movies AS
SELECT
    NULLIF(TRIM(id), '')::INT AS movie_id,
    NULLIF(TRIM(title), '') AS title,
    NULLIF(TRIM(release_year), '')::INT AS release_year
FROM bronze.movies;

CREATE OR REPLACE VIEW silver.stg_occupations AS
SELECT
    NULLIF(TRIM(id), '')::INT AS occupation_id,
    NULLIF(TRIM(name), '') AS occupation_name
FROM bronze.occupations;

CREATE OR REPLACE VIEW silver.stg_age_group AS
SELECT
    NULLIF(TRIM(id), '')::INT AS age_group_id,
    NULLIF(TRIM(name), '') AS age_group_name
FROM bronze.age_group;

CREATE OR REPLACE VIEW silver.stg_genres AS
SELECT
    NULLIF(TRIM(id), '')::INT AS genre_id,
    NULLIF(TRIM(name), '') AS genre_name
FROM bronze.genres;

CREATE OR REPLACE VIEW silver.stg_genres_movies AS
SELECT
    NULLIF(TRIM(id), '')::INT AS id,
    NULLIF(TRIM(movie_id), '')::INT AS movie_id,
    NULLIF(TRIM(genre_id), '')::INT AS genre_id
FROM bronze.genres_movies;


SELECT 'users' AS view_name, COUNT(*) FROM silver.stg_users
UNION ALL
SELECT 'ratings', COUNT(*) FROM silver.stg_ratings
UNION ALL
SELECT 'movies', COUNT(*) FROM silver.stg_movies
UNION ALL
SELECT 'occupations', COUNT(*) FROM silver.stg_occupations
UNION ALL
SELECT 'age_group', COUNT(*) FROM silver.stg_age_group
UNION ALL
SELECT 'genres', COUNT(*) FROM silver.stg_genres
UNION ALL
SELECT 'genres_movies', COUNT(*) FROM silver.stg_genres_movies;

SELECT *
FROM silver.stg_users
ORDER BY user_id
LIMIT 10;