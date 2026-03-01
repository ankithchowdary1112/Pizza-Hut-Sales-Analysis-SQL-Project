create database pizza_hut;
use pizza_hut;

select * from pizzas;
select * from orders;

create table orders (
order_id int  not null,
order_date date not null,
order_time time not null , 
primary key(order_id));

drop table orders_details;

create table orders_details (
order_details_id int  not null,
order_id int  not null,
pizza_id text  not null ,
quantity int not null , 
primary key(order_details_id));

select quantity from orders_details;

-- --Basic:
-- Retrieve the total number of orders placed.
select count(*) from orders;

-- Calculate the total revenue generated from pizza sales.
select  orders_details.quantity * pizzas.price  as total_sales 
from orders_details  join pizzas 
on orders_details.pizza_id = pizzas.pizza_id ;

-- Identify the highest-priced pizza.
select pizza_types.name , pizzas.price 
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 1;

select * from orders_details;
-- Identify the most common pizza size ordered.

select pizzas.size , count(orders_details.order_details_id)  
from orders_details  join pizzas 
on pizzas.pizza_id = orders_details.pizza_id
group by pizzas.size 
order by pizzas.size limit 1;

-- List the top 5 most ordered pizza types along with their quantities.
select sum(orders_details.quantity) as quantity , pizza_types.name
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join orders_details  
on orders_details.pizza_id = pizzas.pizza_id 
group by pizza_types.name
order by quantity desc ;

-- Intermediate:
-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    COUNT(orders_details.quantity) AS quantity,
    pizza_types.category
FROM
    pizzas
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON pizzas.pizza_id = orders_details.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC
;
 
-- Determine the distribution of orders by hour of the day.
select * from orders;

select hour(order_time), count(order_id)
from orders 
group by hour( order_time);

-- Join relevant tables to find the category-wise distribution of pizzas.
select category, count(name ) from pizza_types
group by category;



-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    AVG(quantity)
FROM
    (SELECT 
        orders.order_date, SUM(orders_details.quantity) AS quantity
    FROM
        orders
    JOIN orders_details ON orders.order_id = orders_details.order_id
    GROUP BY orders.order_date) AS order_quantity;

-- Determine the top 3 most ordered pizza types based on revenue.

select pizza_types.name , sum(orders_details.quantity*pizzas.price) as revenue 
from pizzas join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join orders_details
on orders_details.pizza_id= pizzas.pizza_id
group by pizza_types.name
order by revenue desc
limit 3;
