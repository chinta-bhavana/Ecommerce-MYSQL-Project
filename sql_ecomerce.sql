CREATE DATABASE ecommerce;
USE ecommerce;
select * from csv_customers;
select * from csv_order_items;
select * from csv_orders;
select * from csv_products;

-- SECTION 1: SELECT, WHERE, ORDER BY, GROUP BY

-- how to display all customers
SELECT * FROM  csv_customers;


SELECT product_name, price FROM csv_products;

-- how to find customers from a specific city
SELECT * FROM csv_customers
WHERE city = 'Hyderabad';

SELECT * FROM csv_orders
WHERE status = 'Delivered';

-- how to sort products by price
SELECT * FROM csv_products
ORDER BY price DESC;


SELECT * FROM csv_customers
ORDER BY registration_date ASC;


# Total Orders per Customer
SELECT customer_id,
       COUNT(order_id) AS total_orders
FROM csv_orders
GROUP BY customer_id;

#Total Quantity Sold per Product

SELECT product_id,
       SUM(quantity) AS total_sold
FROM csv_order_items
GROUP BY product_id;

#Revenue per Order (Using unit_price & discount)

SELECT order_id,
       SUM(quantity * unit_price * (1 - discount)) AS total_amount
FROM csv_order_items
GROUP BY order_id;

# Revenue per Customer

SELECT o.customer_id,
       SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS total_spent
FROM csv_orders o
JOIN csv_order_items oi ON o.order_id = oi.order_id
GROUP BY o.customer_id;

#Combined Query (All Concepts)

SELECT o.customer_id,
       SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS total_spent
FROM  csv_orders o
JOIN csv_order_items oi ON o.order_id = oi.order_id
WHERE oi.quantity > 1
GROUP BY o.customer_id
ORDER BY total_spent DESC;

-- SECTION 2: JOINS (INNER, LEFT, RIGHT)

-- Show customers their orders(INNER JOIN)
SELECT c.customer_name,
       o.order_id,
       o.order_date
FROM csv_customers c
INNER JOIN csv_orders o
ON c.customer_id = o.customer_id;

-- show all customers even without orders(left join)
SELECT c.customer_name,
       o.order_id
FROM csv_customers c
LEFT JOIN csv_orders o
ON c.customer_id = o.customer_id;

-- show all orders with customers names(right join)
SELECT c.customer_name,
       o.order_id
FROM csv_orders o
LEFT JOIN csv_customers c
ON c.customer_id = o.customer_id;

-- section 4 : Subquery

-- find customers who placed orders
SELECT customer_name
FROM csv_customers
WHERE customer_id IN (
    SELECT customer_id
    FROM csv_orders
);

-- SECTION 3: AGGREGATE FUNCTIONS — SUM, AVG, COUNT, MAX, MIN

-- 
SELECT customer_id,
       COUNT(order_id) AS total_orders
FROM csv_orders
GROUP BY customer_id;

-- find total_revenue
SELECT SUM(quantity * unit_price * (1 - discount)) AS total_revenue
FROM csv_order_items;

-- Average quantity sold per order
SELECT AVG(quantity) AS avg_quantity
FROM csv_order_items;

-- SECTION 5: VIEWS FOR ANALYSIS

-- create customers order 
CREATE VIEW csv_customer_csv_orders AS
SELECT customer_id,
       COUNT(order_id) AS total_orders
FROM csv_orders
GROUP BY customer_id;

SELECT * FROM csv_customer_csv_orders;



-- SECTION 6: QUERY OPTIMIZATION — INDEXES

CREATE INDEX idx_customer_id
ON csv_orders(customer_id);

CREATE INDEX idx_product_id
ON csv_order_items(product_id);
