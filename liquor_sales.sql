--DATA EXPLORATION TO FIND MISSING VALUES AND OTHER INCONSISTENCES
SELECT 
    *
  FROM
    bigquery-public-data.iowa_liquor_sales.sales
  WHERE
    EXTRACT(YEAR FROM date) = 2020
    AND CONCAT(date,category,category_name,volume_sold_gallons,sale_dollars) IS NULL

--MORE EXPLORATION TO FIND IF INCONSISTENCES EXIST IN CATEGORY NAMES
SELECT 
    DISTINCT category_name, category
FROM
    bigquery-public-data.iowa_liquor_sales.sales
WHERE
    EXTRACT(YEAR FROM date) = 2020

--CREATED A VIEW SHOWING ONLY NECESSARY 2020 DATA AND NAMED IT SALES_2020
SELECT 
    DISTINCT invoice_and_item_number,
    date,
    city,
    category AS category_id,
    category_name,
    volume_sold_gallons AS volume_sold,
    sale_dollars AS revenue
  FROM
    bigquery-public-data.iowa_liquor_sales.sales
  WHERE
    EXTRACT(YEAR FROM date) = 2020
    AND CONCAT(date,category,category_name,volume_sold_gallons,sale_dollars) IS NOT NULL

---CALCULATED THE TOP THREE SELLER CATEGORIES
SELECT
  category_id,
  category_name,
  COUNT(category_name) AS category_sales,
  ROUND(SUM(volume_sold),2) AS total_volume_sold,
  ROUND(SUM(revenue),2) AS total_revenue
FROM (
    SELECT
        date,
        category_id,
        category_name,
        volume_sold,
        revenue
    FROM
        liquor.sales_2020
    )
GROUP BY
  category_name,
  category_id
ORDER BY
  category_sales DESC
LIMIT  3

--LOOKED AT HIGHEST, LOWEST, AND AVERAGE SALES FOR SELECTED TOP 3 CATEGORIES
SELECT
  category_name,
  MAX(revenue) AS highest_daily_revenue,
  MIN(revenue) AS lowest_daily_revenue,
  ROUND(AVG(revenue),2) AS average_order_revenue
FROM
  liquor.sales_2020
WHERE
  category_id IN ("1031100","1012100","1011200")
GROUP BY
  category_name 

--LOOKED AT CITIES WITH THE MOST SALES OF THESE CATEGORIES
SELECT
  city,
  SUM(revenue) AS total_revenue
FROM
  liquor.sales_2020
WHERE
  category_id IN ("1031100","1012100","1011200")
GROUP BY city
ORDER BY total_revenue DESC
LIMIT 3

--CREATED A PERMANENT TABLE FOR SALES THROUGHOUT THE YEAR TO VISUALISE TRENDS IN SALES
SELECT
  date,
  category_name,
  revenue,
  volume_sold,
  city
FROM
  liquor.sales_2020
WHERE
  category_id IN ("1031100","1012100","1011200")