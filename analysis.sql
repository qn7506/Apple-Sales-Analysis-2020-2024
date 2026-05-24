-- Select databse
USE apple_sales;

-- Analyze Data
-- 1. Top 5 Sales by unit
SELECT 
    s.product_id AS 'Product ID',
    p.product_name AS 'Name',
    SUM(s.quantity) AS 'Number of unit sold',
    p.launch_date AS 'Launch date'
FROM sales s
JOIN product p ON p.product_id = s.product_id
GROUP BY 1 , 2 , 4
ORDER BY 3 DESC
LIMIT 5;

-- 2. Top 5 Sales per Category
SELECT * FROM
(
SELECT c.category_id,
		c.category_name,
		p.product_name, 
        p.price,
        p.launch_date,
		SUM(s.quantity) AS total_unit_sold,
        RANK() OVER(PARTITION BY p.category ORDER BY SUM(s.quantity) DESC) AS rank_num
FROM sales s
JOIN product p ON p.product_id = s.product_id
JOIN category c ON c.category_id = p.category
GROUP BY 1,2,3,4,5) AS ranked
WHERE rank_num < 6;

-- 3. Top 10 Stores have the most sold units
SELECT 
    s.store_id,
    s.store_name,
    s.country,
    SUM(sl.quantity) AS 'Sold Products'
FROM
    stores s
        JOIN
    sales sl ON s.store_id = sl.store_id
GROUP BY store_id
ORDER BY 4 DESC
LIMIT 10;

-- 4. Top 10 Stores have the most revenue
SELECT 
    st.store_id,
    st.store_name,
    SUM(s.quantity * p.price) AS revenues
FROM sales s
JOIN product p ON p.product_id = s.product_id
JOIN stores st ON st.store_id = s.store_id
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 10;
		
-- 5. What are the total sales sold per country?
SELECT 
    st.country,
    SUM(s.quantity * p.price) AS revenues,
    SUM(s.quantity) AS units_sold
FROM sales s 
JOIN product p ON p.product_id = s.product_id
JOIN stores st ON st.store_id = s.store_id
GROUP BY 1
ORDER BY 2 DESC;

-- 6. Total revenue, units sold, stores, products (KPI Cards)
SELECT 
    SUM(s.quantity * p.price) AS total_revenue,
    SUM(s.quantity) AS total_units_sold,
    COUNT(DISTINCT s.store_id) AS total_stores,
    COUNT(DISTINCT s.product_id) AS total_products
FROM sales s
JOIN product p ON p.product_id = s.product_id;


-- 7. Monthly Sales
SELECT 
    SUBSTRING(sale_date, 1, 7) AS month,
    SUM(s.quantity * p.price) AS revenues,
    SUM(s.quantity) AS units_sold
FROM sales s
JOIN product p ON s.product_id = p.product_id
GROUP BY 1
ORDER BY 1;

-- 8. Revenue by Category (with % contribution)
SELECT 
    c.category_name,
    SUM(s.quantity * p.price) AS revenue,
    ROUND(SUM(s.quantity * p.price) / SUM(SUM(s.quantity * p.price)) OVER() * 100, 2) AS pct_of_total
FROM sales s
JOIN product p ON p.product_id = s.product_id
JOIN category c ON c.category_id = p.category
GROUP BY 1
ORDER BY 2 DESC;

-- 9. Price Range Performance (budget vs premium)
SELECT 
    p.product_id,
    p.product_name,
    CASE
        WHEN price < 500 THEN 'Budget (under 500)'
        WHEN price BETWEEN 500 AND 1000 THEN 'Mid-range (500-1000)'
        WHEN price BETWEEN 1000 AND 1500 THEN 'Premium (1000-1500)'
        ELSE 'Luxury (over 1500)'
    END AS price_range,
    SUM(s.quantity) AS units_sold,
    SUM(s.quantity * price) AS revenue
FROM sales s
JOIN product p ON s.product_id = p.product_id
GROUP BY 1, 2
ORDER BY 2;
 