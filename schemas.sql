CREATE DATABASE IF NOT EXISTS the_pizza_company;
USE the_pizza_company;

SELECT * FROM pizzas;
SELECT * FROM pizza_types;

CREATE TABLE if not exists orders(
order_id INT PRIMARY KEY,
order_date DATE NOT NULL,
order_time TIME NOT NULL
);

CREATE TABLE if not exists order_details(
order_details_id INT NOT NULL PRIMARY KEY,
order_id INT NOT NULL,
pizza_id TEXT NOT NULL,
quantity INT NOT NULL
);

SELECT * FROM orders;
SELECT * FROM order_details;
