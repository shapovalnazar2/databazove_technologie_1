
CREATE TABLE dim_user (
    user_id INTEGER PRIMARY KEY,
    age INTEGER,
    gender VARCHAR(10),
    occupation VARCHAR(100),
    age_group VARCHAR(20),
    zip_code VARCHAR(20)
);

CREATE TABLE dim_movie (
    movie_id INTEGER PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_year INTEGER
);

CREATE TABLE dim_genre (
    genre_id INTEGER PRIMARY KEY,
    genre_name VARCHAR(100) NOT NULL
);

CREATE TABLE dim_date (
    date_key INTEGER PRIMARY KEY,
    full_date DATE NOT NULL UNIQUE,
    day INTEGER,
    month INTEGER,
    year INTEGER,
    quarter INTEGER
);

CREATE TABLE fact_ratings (
    rating_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    date_key INTEGER NOT NULL,
    rating NUMERIC(2,1) NOT NULL,
    rated_at TIMESTAMP,

    CONSTRAINT fk_rating_user
        FOREIGN KEY (user_id) REFERENCES dim_user(user_id),

    CONSTRAINT fk_rating_movie
        FOREIGN KEY (movie_id) REFERENCES dim_movie(movie_id),

    CONSTRAINT fk_rating_date
        FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);

CREATE TABLE bridge_movie_genre (
    movie_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,

    PRIMARY KEY (movie_id, genre_id),

    CONSTRAINT fk_bridge_movie
        FOREIGN KEY (movie_id) REFERENCES dim_movie(movie_id),

    CONSTRAINT fk_bridge_genre
        FOREIGN KEY (genre_id) REFERENCES dim_genre(genre_id)
);


-- ============================================

CREATE TABLE IF NOT EXISTS stg_ratings (
    id INTEGER,
    user_id INTEGER,
    movie_id INTEGER,
    rating NUMERIC(2,1),
    rated_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS stg_users (
    id INTEGER,
    age INTEGER,
    gender VARCHAR(10),
    occupation_id INTEGER,
    zip_code VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS stg_occupations (
    id INTEGER,
    name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS stg_movies (
    id INTEGER,
    title VARCHAR(255),
    release_year INTEGER
);

CREATE TABLE IF NOT EXISTS stg_genres (
    id INTEGER,
    name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS stg_genres_movies (
    id INTEGER,
    movie_id INTEGER,
    genre_id INTEGER
);

CREATE TABLE IF NOT EXISTS stg_age_group (
    id INTEGER,
    name VARCHAR(20)
);


SELECT 'ratings' AS dataset, COUNT(*) FROM stg_ratings
UNION ALL
SELECT 'users', COUNT(*) FROM stg_users
UNION ALL
SELECT 'movies', COUNT(*) FROM stg_movies
UNION ALL
SELECT 'genres', COUNT(*) FROM stg_genres
UNION ALL
SELECT 'occupations', COUNT(*) FROM stg_occupations
UNION ALL
SELECT 'genres_movies', COUNT(*) FROM stg_genres_movies
UNION ALL
SELECT 'age_group', COUNT(*) FROM stg_age_group;




INSERT INTO dim_user (
    user_id, age, gender, occupation, age_group, zip_code
)
SELECT
    u.id,
    u.age,
    u.gender,
    COALESCE(o.name, 'Unknown'),
    CASE
        WHEN u.age < 18 THEN 'Under 18'
        WHEN u.age BETWEEN 18 AND 24 THEN '18-24'
        WHEN u.age BETWEEN 25 AND 34 THEN '25-34'
        WHEN u.age BETWEEN 35 AND 44 THEN '35-44'
        WHEN u.age BETWEEN 45 AND 49 THEN '45-49'
        WHEN u.age BETWEEN 50 AND 55 THEN '50-55'
        WHEN u.age >= 56 THEN '56+'
        ELSE 'Unknown'
    END,
    u.zip_code
FROM stg_users u
LEFT JOIN stg_occupations o
    ON u.occupation_id = o.id
ON CONFLICT (user_id) DO NOTHING;



INSERT INTO dim_movie (movie_id, title, release_year)
SELECT
    id,
    title,
    release_year
FROM stg_movies
ON CONFLICT (movie_id) DO NOTHING;



INSERT INTO dim_genre (genre_id, genre_name)
SELECT
    id,
    name
FROM stg_genres
ON CONFLICT (genre_id) DO NOTHING;


INSERT INTO dim_date (
    date_key, full_date, day, month, year, quarter
)
SELECT DISTINCT
    TO_CHAR(rated_at::date, 'YYYYMMDD')::INTEGER,
    rated_at::date,
    EXTRACT(DAY FROM rated_at)::INTEGER,
    EXTRACT(MONTH FROM rated_at)::INTEGER,
    EXTRACT(YEAR FROM rated_at)::INTEGER,
    EXTRACT(QUARTER FROM rated_at)::INTEGER
FROM stg_ratings
WHERE rated_at IS NOT NULL
ON CONFLICT (date_key) DO NOTHING;



INSERT INTO bridge_movie_genre (movie_id, genre_id)
SELECT DISTINCT
    movie_id,
    genre_id
FROM stg_genres_movies
ON CONFLICT (movie_id, genre_id) DO NOTHING;




INSERT INTO fact_ratings (
    rating_id, user_id, movie_id,
    date_key, rating, rated_at
)
SELECT
    r.id,
    r.user_id,
    r.movie_id,
    TO_CHAR(r.rated_at::date, 'YYYYMMDD')::INTEGER,
    r.rating,
    r.rated_at
FROM stg_ratings r
WHERE r.rated_at IS NOT NULL
ON CONFLICT (rating_id) DO NOTHING;

INSERT INTO dim_user (
    user_id, age, gender, occupation, age_group, zip_code
)
SELECT
    u.id,
    u.age,
    u.gender,
    COALESCE(o.name, 'Unknown'),
    CASE
        WHEN u.age < 18 THEN 'Under 18'
        WHEN u.age BETWEEN 18 AND 24 THEN '18-24'
        WHEN u.age BETWEEN 25 AND 34 THEN '25-34'
        WHEN u.age BETWEEN 35 AND 44 THEN '35-44'
        WHEN u.age BETWEEN 45 AND 49 THEN '45-49'
        WHEN u.age BETWEEN 50 AND 55 THEN '50-55'
        WHEN u.age >= 56 THEN '56+'
        ELSE 'Unknown'
    END,
    u.zip_code
FROM stg_users u
LEFT JOIN stg_occupations o
    ON u.occupation_id = o.id
ON CONFLICT (user_id) DO NOTHING;

INSERT INTO dim_date (
    date_key, full_date, day, month, year, quarter
)
SELECT DISTINCT
    TO_CHAR(rated_at::date, 'YYYYMMDD')::INTEGER,
    rated_at::date,
    EXTRACT(DAY FROM rated_at)::INTEGER,
    EXTRACT(MONTH FROM rated_at)::INTEGER,
    EXTRACT(YEAR FROM rated_at)::INTEGER,
    EXTRACT(QUARTER FROM rated_at)::INTEGER
FROM stg_ratings
WHERE rated_at IS NOT NULL
ON CONFLICT (date_key) DO NOTHING;

INSERT INTO bridge_movie_genre (movie_id, genre_id)
SELECT DISTINCT movie_id, genre_id
FROM stg_genres_movies
ON CONFLICT (movie_id, genre_id) DO NOTHING;



INSERT INTO fact_ratings (
    rating_id, user_id, movie_id,
    date_key, rating, rated_at
)
SELECT
    r.id,
    r.user_id,
    r.movie_id,
    TO_CHAR(r.rated_at::date, 'YYYYMMDD')::INTEGER,
    r.rating,
    r.rated_at
FROM stg_ratings r
WHERE r.rated_at IS NOT NULL
ON CONFLICT (rating_id) DO NOTHING;


SELECT 'dim_user' AS table_name, COUNT(*) FROM dim_user
UNION ALL
SELECT 'dim_movie', COUNT(*) FROM dim_movie
UNION ALL
SELECT 'dim_genre', COUNT(*) FROM dim_genre
UNION ALL
SELECT 'dim_date', COUNT(*) FROM dim_date
UNION ALL
SELECT 'fact_ratings', COUNT(*) FROM fact_ratings
UNION ALL
SELECT 'bridge_movie_genre', COUNT(*) FROM bridge_movie_genre;

