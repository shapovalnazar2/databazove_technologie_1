CREATE OR REPLACE PROCEDURE apply_regional_discount(
    region_name VARCHAR,
    discount_rate NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE orders
    SET sales = ROUND(sales * (1 - discount_rate), 2)
    WHERE region = region_name;

    RAISE NOTICE 'Zľava: %, Región: %',
        discount_rate, region_name;
END;
$$;

BEGIN;

SELECT SUM(sales) AS pred_zlavou
FROM orders
WHERE region = 'West';

CALL apply_regional_discount('West', 0.10);

SELECT SUM(sales) AS po_prvej_zlave
FROM orders
WHERE region = 'West';

CALL apply_regional_discount('West', 0.10);

SELECT SUM(sales) AS po_druhej_zlave
FROM orders
WHERE region = 'West';

ROLLBACK;