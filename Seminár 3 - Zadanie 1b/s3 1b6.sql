WITH RECURSIVE
date_range AS (
    SELECT
        MIN(sale_date) AS start_date,
        MAX(sale_date) AS end_date
    FROM flourmills_sales
),
calendar AS (
    SELECT start_date AS sale_date
    FROM date_range

    UNION ALL

    SELECT c.sale_date + 1
    FROM calendar c
    CROSS JOIN date_range d
    WHERE c.sale_date < d.end_date
)
SELECT sale_date
FROM calendar
ORDER BY sale_date ASC;