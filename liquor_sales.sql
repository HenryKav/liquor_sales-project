--LOOKED AT MAXIMUM AND MINIMUM
SELECT 
        category_name,
        MAX(sale_dollars) AS highest_daily_revenue,
        MIN(sale_dollars) AS lowest_daily_revenue,
        
    FROM  
        bigquery-public-data.iowa_liquor_sales.sales
    WHERE 
        EXTRACT(YEAR FROM date) = 2020
        AND CONCAT(date,category,category_name,volume_sold_gallons,sale_dollars) IS NOT NULL
    AND category IN ("1031100","1012100","1011200")
GROUP BY category_name


---SELECTED THE TOP THREE LIQUOR CATEGORIES 
SELECT 
    category,
    category_name,
    COUNT(category_name) AS category_sales,
    ROUND(SUM(volume_sold_gallons),2) AS total_gallons_sold,
    ROUND(SUM(sale_dollars),2) AS total_revenue
 FROM 
   (SELECT 
        date,
        category,category_name,
        volume_sold_gallons,
        sale_dollars
    FROM  
        bigquery-public-data.iowa_liquor_sales.sales
    WHERE 
        EXTRACT(YEAR FROM date) = 2020
        AND CONCAT(date,category,category_name,volume_sold_gallons,sale_dollars) IS NOT NULL
   )
GROUP BY category_name,category
ORDER BY category_sales DESC
LIMIT 3 

--LOOKED AT DAILY HIGHS AND LOWS 
SELECT 
        category_name,
        MAX(sale_dollars) AS highest_daily_revenue,
        MIN(sale_dollars) AS lowest_daily_revenue,
        
    FROM  
        bigquery-public-data.iowa_liquor_sales.sales
    WHERE 
        EXTRACT(YEAR FROM date) = 2020
        AND CONCAT(date,category,category_name,volume_sold_gallons,sale_dollars) IS NOT NULL
    AND category IN ("1031100","1012100","1011200")
GROUP BY category_name

--CREATING A VIEW HAVING ONLY INTEREST CATEGORIES DATA FOR VISUALIZATION
SELECT 
        date,
        category_name,
        volume_sold_gallons,
        sale_dollars
    FROM  
        bigquery-public-data.iowa_liquor_sales.sales
    WHERE 
        EXTRACT(YEAR FROM date) = 2020
        AND CONCAT(date,category,category_name,volume_sold_gallons,sale_dollars) IS NOT NULL
    AND category IN ("1031100","1012100","1011200")
