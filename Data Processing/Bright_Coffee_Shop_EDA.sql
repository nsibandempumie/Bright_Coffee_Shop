--------------------------------------------------------------------------------------------
-- Retrieving bright coffee sales data
--------------------------------------------------------------------------------------------
SELECT * 
FROM workspace.bright.bright_coffee_shop_dataset
LIMIT 100;

--------------------------------------------------------------------------------------------
        -- Data analysis (The size of the data) and duplicates
--------------------------------------------------------------------------------------------
-- Dataset contains 149 116 transaction records
SELECT COUNT(*) AS number_of_rows,
       COUNT(DISTINCT transaction_id) AS number_of_transactions
FROM workspace.bright.bright_coffee_shop_dataset;

--- Another way to check duplicates on the data
SELECT transaction_id, COUNT(*) AS duplicate_count
FROM workspace.bright.bright_coffee_shop_dataset
GROUP BY transaction_id
HAVING COUNT(*) > 1;        -- Returned no duplicates

----------------------------------------------------------------------------------------------
        -- -- Checking the primary key for NULL values 
----------------------------------------------------------------------------------------------
SELECT COUNT(*) AS cnt                      -- Returned 0 therefore no NULL values on the data
FROM workspace.bright.bright_coffee_shop_dataset
WHERE transaction_id is NULL;

----------------------------------------------------------------------------------------
-- Store Exploration
----------------------------------------------------------------------------------------
-- Available store locations
SELECT DISTINCT store_location
FROM workspace.bright.bright_coffee_shop_dataset;
-- 3 branches of Bright Coffee Shop: Lower Manhattan, Hell's Kitchen & Astoria

-- Checking for NULL/None values
SELECT COUNT(*) AS none_values
FROM workspace.bright.bright_coffee_shop_dataset
WHERE store_location ILIKE 'none';                 -- No NULL/None values on store locations

-- Empty values
SELECT COUNT(*) AS empty_values
FROM workspace.bright.bright_coffee_shop_dataset
WHERE TRIM(store_location) = '';                      -- No empty values on store location column

----------------------------------------------------------------------------------------
-- Store Performance Analysis
----------------------------------------------------------------------------------------

-- Revenue by branch
SELECT  store_location,
        SUM(transaction_qty * unit_price) AS revenue
FROM workspace.bright.bright_coffee_shop_dataset
GROUP BY store_location
ORDER BY revenue DESC;

-- Number of transactions by branch
SELECT  store_location,
        COUNT(*) AS transactions
FROM workspace.bright.bright_coffee_shop_dataset
GROUP BY store_location
ORDER BY transactions DESC;

-- Average Sale
SELECT  store_location,
        ROUND(AVG(transaction_qty * unit_price),2) AS average_sale
FROM workspace.bright.bright_coffee_shop_dataset
GROUP BY store_location;

-- Branch that makes the most revenue: Hell's Kitchen at no.1
-- Number of transactions per branch: Hell's Kitchen at no.1
-- Average transaction value per branch: Lower Manhattan at no.1

----------------------------------------------------------------------------------------
-- Product Exploration
----------------------------------------------------------------------------------------
-- Available product categories
SELECT DISTINCT product_category
FROM workspace.bright.bright_coffee_shop_dataset;

-- Available product types
SELECT DISTINCT product_type
FROM workspace.bright.bright_coffee_shop_dataset;

-- Exploring the Clothing product type (Merchandise)
SELECT *
FROM workspace.bright.bright_coffee_shop_dataset
WHERE product_type = 'Clothing';                  

----------------------------------------------------------------------------------------
-- Product Performance Analysis
----------------------------------------------------------------------------------------

-- Top 10 products by revenue
SELECT product_detail,
        SUM(transaction_qty * unit_price) AS revenue
FROM workspace.bright.bright_coffee_shop_dataset
GROUP BY product_detail
ORDER BY revenue DESC
LIMIT 10;

-- Bottom 10 products by revenue
SELECT  product_detail,
        SUM(transaction_qty * unit_price) AS revenue
FROM workspace.bright.bright_coffee_shop_dataset
GROUP BY product_detail
ORDER BY revenue
LIMIT 10;

-- Revenue by product type
SELECT  product_type,
        ROUND(SUM(transaction_qty * unit_price), 2) AS revenue
FROM workspace.bright.bright_coffee_shop_dataset
GROUP BY product_type
ORDER BY revenue DESC;

-- Revenue by product category
SELECT  product_category,
        ROUND(SUM(transaction_qty * unit_price), 2) AS revenue
FROM workspace.bright.bright_coffee_shop_dataset
GROUP BY product_category
ORDER BY revenue DESC;

-- Most expensive products
SELECT DISTINCT product_detail,
                unit_price
FROM workspace.bright.bright_coffee_shop_dataset
ORDER BY unit_price DESC;

-- Cheapest products
SELECT DISTINCT product_detail,
                unit_price
FROM workspace.bright.bright_coffee_shop_dataset
ORDER BY unit_price;

----------------------------------------------------------------------------------------
-- Product Sales Analysis
----------------------------------------------------------------------------------------

-- Monthly sales
SELECT  MONTH(transaction_date) AS month,
        SUM(transaction_qty * unit_price) AS revenue
FROM workspace.bright.bright_coffee_shop_dataset
GROUP BY MONTH(transaction_date)
ORDER BY month;

-- Day of week
SELECT
    DATE_FORMAT(transaction_date,'EEEE') AS day_of_week,
    SUM(transaction_qty * unit_price) AS revenue
FROM workspace.bright.bright_coffee_shop_dataset
GROUP BY DATE_FORMAT(transaction_date,'EEEE')
ORDER BY revenue DESC;

-- Hour of the day
SELECT  HOUR(transaction_time) AS hour,
        SUM(transaction_qty * unit_price) AS revenue
FROM workspace.bright.bright_coffee_shop_dataset
GROUP BY HOUR(transaction_time)
ORDER BY hour;

----------------------------------------------------------------------
-- Exploring Product Sales
----------------------------------------------------------------------

--- Products that sold the most units: Earl Grey Rg at no.1
SELECT product_detail,
       SUM(transaction_qty) AS total_units_sold
FROM workspace.bright.bright_coffee_shop_dataset
GROUP BY product_detail
ORDER BY total_units_sold DESC;          

-- products type sold the most units: Brewed Chai tea at no.1
SELECT product_type,
       COUNT(*) AS transactions
FROM workspace.bright.bright_coffee_shop_dataset
GROUP BY product_type
ORDER BY transactions DESC;             

-- Products category that sold the most units: Coffee at no.1
SELECT product_category,
       COUNT(*) AS transactions
FROM workspace.bright.bright_coffee_shop_dataset
GROUP BY product_category
ORDER BY transactions DESC;

-- Products that generated the most revenue: Sustainably Grown Organic Lg at no.1
SELECT product_detail,
       SUM(transaction_qty * unit_price) AS total_revenue
FROM workspace.bright.bright_coffee_shop_dataset
GROUP BY product_detail
ORDER BY total_revenue DESC;

-- Product types generated the most revenue: Barista Espresso at no.1
SELECT product_type,
       SUM(transaction_qty * unit_price) AS total_revenue
FROM workspace.bright.bright_coffee_shop_dataset
GROUP BY product_type
ORDER BY total_revenue DESC;

----------------------------------------------------------------------------------------
-- Exploring Transaction Time
----------------------------------------------------------------------------------------

SELECT DISTINCT transaction_time
FROM workspace.bright.bright_coffee_shop_dataset
LIMIT 10;

SELECT
    transaction_time,
    HOUR(transaction_time) AS hour,
    MINUTE(transaction_time) AS minute
FROM workspace.bright.bright_coffee_shop_dataset
LIMIT 10;

----------------------------------------------------------------------------------------
-- Revenue Analysis by 30-Minute Time Intervals
----------------------------------------------------------------------------------------
SELECT
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
    END AS time_interval,
    COUNT(*) AS total_transactions,
    SUM(transaction_qty) AS total_units_sold,
    ROUND(SUM(transaction_qty * unit_price),2) AS total_revenue

FROM workspace.bright.bright_coffee_shop_dataset

GROUP BY
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
    END

ORDER BY time_interval;


SELECT * 
FROM workspace.bright.bright_coffee_shop_dataset
LIMIT 100;
----------------------------------------------------------------------------------------
-- Business Insights
----------------------------------------------------------------------------------------

-- The dataset contains 149,116 sales transactions.
-- No duplicate transactions were identified.
-- No NULL values were found in the transaction_id column.
-- Hell's Kitchen generated the highest total revenue.
-- Lower Manhattan recorded the highest average sale value.
-- Coffee was the best-selling product category.
-- Barista Espresso generated the highest revenue among product types.
-- The 30-minute interval analysis identifies peak trading periods throughout the day.