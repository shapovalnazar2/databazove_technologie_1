-- Active: 1791112921687@@127.0.0.1@5432@movielens_elt
-- CREATE DATABASE movielens_elt;


\set ON_ERROR_STOP on
\encoding UTF8

CREATE SCHEMA IF NOT EXISTS bronze;

CREATE TABLE IF NOT EXISTS bronze.users (
    id TEXT,
    age TEXT,
    gender TEXT,
    occupation_id TEXT,
    zip_code TEXT,
    _source_file TEXT DEFAULT 'users.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.ratings (
    id TEXT,
    user_id TEXT,
    movie_id TEXT,
    rating TEXT,
    rated_at TEXT,
    _source_file TEXT DEFAULT 'ratings.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.movies (
    id TEXT,
    title TEXT,
    release_year TEXT,
    _source_file TEXT DEFAULT 'movies.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.occupations (
    id TEXT,
    name TEXT,
    _source_file TEXT DEFAULT 'occupations.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.age_group (
    id TEXT,
    name TEXT,
    _source_file TEXT DEFAULT 'age_group.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.genres (
    id TEXT,
    name TEXT,
    _source_file TEXT DEFAULT 'genres.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.genres_movies (
    id TEXT,
    movie_id TEXT,
    genre_id TEXT,
    _source_file TEXT DEFAULT 'genres_movies.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

BEGIN;

TRUNCATE TABLE
    bronze.ratings,
    bronze.users,
    bronze.movies,
    bronze.occupations,
    bronze.age_group,
    bronze.genres,
    bronze.genres_movies;


\COPY bronze.users (id, age, gender, occupation_id, zip_code) FROM 'users.csv' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8')

\COPY bronze.ratings (id, user_id, movie_id, rating, rated_at) FROM 'ratings.csv' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8')

\COPY bronze.movies (id, title, release_year) FROM 'movies.csv' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8')

\COPY bronze.occupations (id, name) FROM 'occupations.csv' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8')

\COPY bronze.age_group (id, name) FROM 'age_group.csv' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8')

\COPY bronze.genres (id, name) FROM 'genres.csv' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8')

\COPY bronze.genres_movies (id, movie_id, genre_id) FROM 'genres_movies.csv' WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8')

COMMIT;


SELECT
    'users' AS table_name,
    COUNT(*) AS total_rows
FROM bronze.users

UNION ALL

SELECT 'ratings', COUNT(*) FROM bronze.ratings
UNION ALL
SELECT 'movies', COUNT(*) FROM bronze.movies
UNION ALL
SELECT 'occupations', COUNT(*) FROM bronze.occupations
UNION ALL
SELECT 'age_group', COUNT(*) FROM bronze.age_group
UNION ALL
SELECT 'genres', COUNT(*) FROM bronze.genres
UNION ALL
SELECT 'genres_movies', COUNT(*) FROM bronze.genres_movies;