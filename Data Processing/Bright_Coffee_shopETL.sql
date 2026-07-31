----------------------------------------------------------------------------------------
-- Bright Coffee Shop ETL Pipeline
----------------------------------------------------------------------------------------
-- Purpose:
-- Create a cleaned analytics-ready dataset from the raw Bright Coffee Shop dataset.
----------------------------------------------------------------------------------------

CREATE OR REPLACE TABLE workspace.bright.bright_coffee_shop_clean AS

SELECT

    -- Original Columns
    transaction_id,
    transaction_date,
    transaction_time,
    store_id,
    store_location,
    product_id,
    product_category,
    product_type,
    product_detail,
    transaction_qty,
    unit_price,

    -- Calculated Revenue
    transaction_qty * unit_price AS revenue,

    -- Date Columns
    YEAR(transaction_date) AS year,
MONTH(transaction_date) AS month,
DATE_FORMAT(transaction_date,'MMMM') AS month_name,
QUARTER(transaction_date) AS quarter,
DATE_FORMAT(transaction_date,'EEEE') AS day_of_week,
WEEKOFYEAR(transaction_date) AS week_number,

    -- Time Columns
    HOUR(transaction_time) AS hour,
    MINUTE(transaction_time) AS minute,

    CASE
        WHEN MINUTE(transaction_time) < 30 THEN
            CONCAT(
                HOUR(transaction_time),
                ':00 - ',
                HOUR(transaction_time),
                ':29'
            )
        ELSE
            CONCAT(
                HOUR(transaction_time),
                ':30 - ',
                HOUR(transaction_time),
                ':59'
            )
    END AS time_interval

FROM workspace.bright.bright_coffee_shop_dataset;

-- Checking for NULLS
SELECT
    COUNT(CASE WHEN revenue IS NULL THEN 1 END) AS revenue_nulls,
    COUNT(CASE WHEN month IS NULL THEN 1 END) AS month_nulls,
    COUNT(CASE WHEN day_of_week IS NULL THEN 1 END) AS day_nulls,
    COUNT(CASE WHEN hour IS NULL THEN 1 END) AS hour_nulls,
    COUNT(CASE WHEN time_interval IS NULL THEN 1 END) AS interval_nulls
FROM workspace.bright.bright_coffee_shop_clean;

-- Checking Revenue
SELECT
    transaction_qty,
    unit_price,
    revenue
FROM workspace.bright.bright_coffee_shop_clean
LIMIT 20;

-- Final checking of my new table
SELECT *
FROM workspace.bright.bright_coffee_shop_clean;