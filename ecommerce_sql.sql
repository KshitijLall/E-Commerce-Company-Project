SELECT * FROM ecommerce.products;
use ecommerce

/* demand forecasting */


/* Forecast Monthly Product Demand */

SELECT products.product_id,products.name AS product_name,
    DATE_FORMAT(orders.order_date, '%Y-%m') AS month,
    SUM(orderdetails.quantity) AS total_quantity_sold
FROM
    orderdetails
    JOIN orders ON orderdetails.order_id = orders.order_id
    JOIN products ON orderdetails.product_id = products.product_id
GROUP BY
    products.product_id,
    products.name,
    DATE_FORMAT(orders.order_date, '%Y-%m')
ORDER BY
    products.product_id,
    month;











/*Forecasting Next Month's Demand (Simple Moving Average)*/


WITH last_3_months AS (
    SELECT
        products.product_id,
        products.name AS product_name,
        DATE_FORMAT(orders.order_date, '%Y-%m') AS month,
        SUM(orderdetails.quantity) AS total_quantity_sold
    FROM
        orderdetails
        JOIN orders ON orderdetails.order_id = orders.order_id
        JOIN products ON orderdetails.product_id = products.product_id
    WHERE
        orders.order_date >= DATE_SUB("2024-03-01", INTERVAL 3 MONTH)
    GROUP BY
        products.product_id,
        products.name,
        month
)
SELECT
    product_id,
    product_name,
    AVG(total_quantity_sold) AS avg_last_3_months_quantity
FROM
    last_3_months
GROUP BY
    product_id,
    product_name
ORDER BY
    avg_last_3_months_quantity DESC;
    
    
 /* Forecasting Demand by Location (City) */   
 
 SELECT
    p.product_id,
    p.name AS product_name,
    c.location,
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(od.quantity) AS total_quantity_sold
FROM
    orderdetails od
    JOIN orders o ON od.order_id = o.order_id
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN products p ON od.product_id = p.product_id
GROUP BY
    p.product_id,
    c.location,
    month
ORDER BY
    p.product_id,
    c.location,
    month;


/* total quantity sold for each and every product */

SELECT
    p.product_id,
    p.name AS product_name,
    SUM(od.quantity) AS total_quantity_sold
FROM
    orderdetails od
    JOIN products p ON od.product_id = p.product_id
GROUP BY
    p.product_id, p.name
ORDER BY
    total_quantity_sold DESC;

    
    
