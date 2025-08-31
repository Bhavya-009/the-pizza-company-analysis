USE the_pizza_company;

-- The distribution of orders by hour of the day. -> MASTER TABLE
SELECT DISTINCT
    HOUR(o.order_time) AS dayHour,
    t.category,
    t.name,
    p.size,
    SUM(d.quantity) AS totalOrders,
    ROUND(SUM(d.quantity * p.price), 2) AS totalSales
FROM
    orders o
        JOIN
    order_details d ON o.order_id = d.order_id
        JOIN
    pizzas p ON p.pizza_id = d.pizza_id
        JOIN
    pizza_types t ON p.pizza_type_id = t.pizza_type_id
GROUP BY dayHour , t.category , t.name , p.size
ORDER BY dayHour ASC;

-- Total number of orders placed.
SELECT 
    COUNT(*) AS totalOrders
FROM
    orders;

-- Total revenue generated from pizza sales.
SELECT 
    SUM(p.price * d.quantity) AS totalRevenue
FROM
    pizzas p
        JOIN
    order_details d ON p.pizza_id = d.pizza_id;

-- Highest-priced pizza.
SELECT 
    t.name, p.pizza_id, p.price
FROM
    pizzas p
        JOIN
    pizza_types t ON p.pizza_type_id = t.pizza_type_id
ORDER BY price DESC
LIMIT 1;

-- Most common pizza size 
SELECT 
    p.size,
    COUNT(d.quantity) AS totalOrders,
    ROUND(SUM(d.quantity * p.price), 2) AS totalSales
FROM
    pizzas p
        JOIN
    order_details d ON p.pizza_id = d.pizza_id
GROUP BY p.size
ORDER BY totalSales DESC;

-- Top 5 most ordered pizza types along with their quantities.
SELECT 
    t.name,
    SUM(d.quantity) AS totalQuantity,
    ROUND(SUM(d.quantity * p.price), 2) AS totalSales
FROM
    pizzas p
        JOIN
    order_details d ON p.pizza_id = d.pizza_id
        JOIN
    pizza_types t ON p.pizza_type_id = t.pizza_type_id
GROUP BY t.name , d.quantity
ORDER BY totalQuantity DESC
LIMIT 5;

-- Joining the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    t.category,
    COUNT(d.quantity) AS totalOrders,
    ROUND(SUM(d.quantity * p.price), 2) AS totalSales
FROM
    pizzas p
        JOIN
    order_details d ON p.pizza_id = d.pizza_id
        JOIN
    pizza_types t ON p.pizza_type_id = t.pizza_type_id
GROUP BY t.category
ORDER BY totalOrders DESC;

-- Joining relevant tables to find the category-wise distribution of pizzas.

SELECT 
    ROUND(AVG(dayOrders), 0) AS dayOrdersAvg
FROM
    (SELECT 
        o.order_date, SUM(d.quantity) AS dayOrders
    FROM
        orders o
    JOIN order_details d ON o.order_id = d.order_id
    GROUP BY o.order_date) AS dailyOrders;


-- Top 3 most ordered pizza types based on revenue.
SELECT 
    p.pizza_type_id,
    ROUND(SUM(d.quantity * p.price), 2) AS totalSales
FROM
    pizzas p
        JOIN
    order_details d ON p.pizza_id = d.pizza_id
GROUP BY p.pizza_type_id
ORDER BY totalSales DESC
LIMIT 3;

-- Percentage contribution of each pizza type to total revenue.
SELECT 
    t.category,
    ROUND(SUM(p.price * d.quantity) / (SELECT 
                    SUM(p.price * d.quantity)
                FROM
                    pizzas p
                        JOIN
                    order_details d ON p.pizza_id = d.pizza_id) * 100,
            2) AS salesPerc
FROM
    pizzas p
        JOIN
    order_details d ON p.pizza_id = d.pizza_id
        JOIN
    pizza_types t ON p.pizza_type_id = t.pizza_type_id
GROUP BY t.category
ORDER BY salesPerc DESC;


-- Top 3 most ordered pizza types based on revenue for each pizza category.
SELECT category, name, sales
FROM
(SELECT category, name, sales,
RANK() OVER(PARTITION BY category ORDER BY sales desc) AS rn
FROM
(SELECT t.category, t.name, SUM(p.price * d.quantity) AS sales
FROM pizza_types t
JOIN pizzas p ON p.pizza_type_id = t.pizza_type_id 
JOIN order_details d ON p.pizza_id = d.pizza_id
GROUP BY  t.category, t.name
ORDER BY sales desc) AS a) AS B
WHERE rn <= 3;


-- Pizza categories with pizza names and total orders n revenue
SELECT 
    category,
    name,
    SUM(Orders) AS totalOrders,
    SUM(Revenue) AS totalRevenue
FROM
    (SELECT 
        t.category,
            t.name,
            SUM(d.quantity) AS Orders,
            ROUND(SUM(p.price * d.quantity), 2) AS Revenue
    FROM
        pizza_types t
    JOIN pizzas p ON p.pizza_type_id = t.pizza_type_id
    JOIN order_details d ON p.pizza_id = d.pizza_id
    GROUP BY t.category , t.name , p.price , d.quantity
    ORDER BY t.category) AS sales
GROUP BY category , name;
