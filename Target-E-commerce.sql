-- Check the available tables in the 'public' schema

-- select table_name
-- from information_schema.tables
-- where table_schema ='public'

-- Check data type of all columns in relevant tables

-- select column_name,data_type
-- from information_schema.columns
-- where table_name in ('customers','geolocations','order_items','orders','payments','products','reviews','sellers','zip_codes');

-- Get the earliest and latest order dates

-- select min(order_purchase_timestamp) as earliest_order,
-- max(order_purchase_timestamp) as latest_order
-- from orders;

-- Count the number of cities & states of customers who ordered during the period

-- select a.city,a.state,min(a.order_purchase_timestamp)as earliest_order,max(a.order_purchase_timestamp)as latest_order
-- from 
-- (select c.customer_city as city, c.customer_state as state,o.order_purchase_timestamp from customers as c
-- join 
-- orders as o on o.customer_id = c.customer_id) as a
-- group by a.city,a.state;

-- Yearly order trends

-- select date_part('year',order_purchase_timestamp) as year ,count(*) as order_count
-- from
-- orders
-- group by (year)
-- order by (year);

-- Monthly order trends

-- select date_part('month',order_purchase_timestamp) as order_month ,count(*) as order_count
-- from
-- orders
-- group by order_month
-- order by order_month;

-- Daily order trends

-- select date(order_purchase_timestamp) as order_date ,count(*) as order_count
-- from
-- orders
-- group by order_date
-- order by order_date

-- Time of day analysis

-- select
-- case 
-- when extract(hour from order_purchase_timestamp) between  5 and 11 then 'Morning'
-- when extract(hour from order_purchase_timestamp) between 12 and 17 then 'Afternoon'
-- when extract(hour from order_purchase_timestamp) between 18 and 22 then 'Night'
-- else 'Dawn'
-- end as time_of_day,
--   COUNT(*) AS order_count
-- FROM orders
-- GROUP BY time_of_day
-- ORDER BY order_count DESC;

-- Month-Wise order count by state

-- SELECT 
--     DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
--     c.customer_state AS state,
--     COUNT(*) AS order_count
-- FROM orders o
-- JOIN customers c ON o.customer_id = c.customer_id
-- GROUP BY order_month, c.customer_state
-- ORDER BY order_month, c.customer_state;

-- Customer Count

-- select  count(*) as total_rows,
-- count(distinct customer_id) as unique_customer_ids
-- from customers;

-- Customer distribution by state

-- select 
--     customer_state as state,
--     count(customer_id) as customer_count
-- from customers
-- group by customer_state
-- order by customer_count desc;

-- Total money movement from orders and freight

-- select 
--     sum(price) as total_order_value,
--     sum(freight_value) as total_freight,
--     sum(price + freight_value) as total_transaction_value
-- from order_items;

-- Percentage increase in total cost from Jan–Aug 2017 to Jan–Aug 2018

-- with cost_2017 as (
--     select 
--         sum(oi.price + oi.freight_value) as total_2017
--     from orders o
--     join order_items oi on o.order_id = oi.order_id
--     where extract(year from o.order_purchase_timestamp) = 2017
--       and extract(month from o.order_purchase_timestamp) between 1 and 8
-- ),

-- cost_2018 as (
--     select 
--         sum(oi.price + oi.freight_value) as total_2018
--     from orders o
--     join order_items oi on o.order_id = oi.order_id
--     where extract(year from o.order_purchase_timestamp) = 2018
--       and extract(month from o.order_purchase_timestamp) between 1 and 8
-- )

-- select
--     c17.total_2017,
--     c18.total_2018,
--     round(
--         100.0 * (c18.total_2018 - c17.total_2017) / nullif(c17.total_2017, 0), 
--         2
--     ) as percent_increase
-- from cost_2017 c17, cost_2018 c18;

-- Total & average order and freight values by state

-- select 
--     c.customer_state as state,
--     round(sum(oi.price), 2) as total_price,
--     round(sum(oi.freight_value), 2) as total_freight,
--     round(avg(oi.price), 2) as avg_price,
--     round(avg(oi.freight_value), 2) as avg_freight
-- from customers c
-- join orders o on c.customer_id = o.customer_id
-- join order_items oi on o.order_id = oi.order_id
-- group by c.customer_state
-- order by total_price desc;

-- Delivery time & difference from estimated date

-- select 
--     order_id,
--     order_purchase_timestamp,
--     order_delivered_customer_date,
--     order_estimated_delivery_date,
--     order_delivered_customer_date - order_purchase_timestamp as delivery_days,
--     order_estimated_delivery_date - order_delivered_customer_date as early_or_late
-- from orders
-- where order_delivered_customer_date is not null;

-- Top 5 states with highest average freight

-- select 
--     c.customer_state,
--     round(avg(oi.freight_value), 2) as avg_freight
-- from customers c
-- join orders o on c.customer_id = o.customer_id
-- join order_items oi on o.order_id = oi.order_id
-- group by c.customer_state
-- order by avg_freight desc
-- limit 5;

-- Top 5 states with highest average delivery time

-- select 
--     c.customer_state,
--     round(avg(extract(day from order_delivered_customer_date - order_purchase_timestamp)), 2) as avg_delivery_days
-- from customers c
-- join orders o on c.customer_id = o.customer_id
-- where order_delivered_customer_date is not null
-- group by c.customer_state
-- order by avg_delivery_days desc
-- limit 5;

-- Top 5 states where delivery is faster than estimated

-- select 
--     c.customer_state,
--     count(*) as early_deliveries
-- from customers c
-- join orders o on c.customer_id = o.customer_id
-- where order_delivered_customer_date < order_estimated_delivery_date
-- group by c.customer_state
-- order by early_deliveries desc
-- limit 5;

-- Month-Wise orders by payment type

-- select 
--     date_trunc('month', o.order_purchase_timestamp) as order_month,
--     p.payment_type,
--     count(distinct p.order_id) as order_count
-- from payments p
-- join orders o on p.order_id = o.order_id
-- group by order_month, p.payment_type
-- order by order_month, p.payment_type;

-- Orders based on payment installments

-- select 
--     payment_installments,
--     count(distinct order_id) as order_count
-- from payments
-- group by payment_installments
-- order by payment_installments;


