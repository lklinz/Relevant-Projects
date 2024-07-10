--Creating the Pizza Runner Database
USE master;
GO

IF NOT EXISTS (
      SELECT name
      FROM sys.databases
      WHERE name = N'TutorialDB'
      )
   CREATE DATABASE [Pizza_runner];
GO

IF SERVERPROPERTY('ProductVersion') > '12'
   ALTER DATABASE [Pizza_runner] SET QUERY_STORE = ON;
GO

-- Creating Runners Table and inserting the data

DROP TABLE IF EXISTS dbo.runners;
CREATE TABLE dbo.runners (
  "runner_id" INTEGER,
  "registration_date" DATE
);
INSERT INTO dbo.runners
  ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


--Creating the Customer Orders table and inserting the data
DROP TABLE IF EXISTS dbo.customer_orders;
CREATE TABLE dbo.customer_orders (
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" DATETIME
);

INSERT INTO dbo.customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
VALUES
  ('1', '101', '1', NULL, NULL, '2020-01-01 18:05:02'),
  ('2', '101', '1', NULL, NULL, '2020-01-01 19:00:52'),
  ('3', '102', '1', NULL, NULL, '2020-01-02 23:51:23'),
  ('3', '102', '2', NULL, NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', NULL, '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', NULL, '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', NULL, '2020-01-04 13:23:46'),
  ('5', '104', '1', NULL, '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', NULL, NULL, '2020-01-08 21:03:13'),
  ('7', '105', '2', NULL, '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', NULL, NULL, '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1', '2020-01-10 11:22:59'),
  ('9', '103', '1', '4', '5', '2020-01-10 11:22:59'),
  ('10', '104', '1', NULL, NULL, '2020-01-11 18:34:49'),
  ('10', '104', '1', '2', '1', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2', '4', '2020-01-11 18:34:49'),
  ('10', '104', '1', '6', '1', '2020-01-11 18:34:49'),
  ('10', '104', '1', '6', '4', '2020-01-11 18:34:49');


--Creating the Runners Orders table and inserting the data
DROP TABLE IF EXISTS dbo.runner_orders;
CREATE TABLE dbo.runner_orders (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" DATETIME,
  "distance in km" FLOAT,
  "duration in minutes" INTEGER,
  "cancellation" VARCHAR(23)
);

INSERT INTO dbo.runner_orders
  ("order_id", "runner_id", "pickup_time", "distance in km", "duration in minutes", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20', '32', NULL),
  ('2', '1', '2020-01-01 19:10:54', '20', '27', NULL),
  ('3', '1', '2020-01-03 00:12:37', '13.4', '20', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', NULL, '0', '0', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25', '25', NULL),
  ('8', '2', '2020-01-10 00:15:02', '23.4', '15', NULL),
  ('9', '2', NULL, '0', '0','Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10', '10', NULL);

--Creating the Pizza Names table and inserting the data
DROP TABLE IF EXISTS dbo.pizza_names;
CREATE TABLE dbo.pizza_names (
  "pizza_id" INTEGER,
  "pizza_name" NVARCHAR(100)
);
INSERT INTO dbo.pizza_names
  ("pizza_id", "pizza_name")
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');

--Creating the Pizza Recipes table and inserting the data

DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  "pizza_id" INTEGER,
  "toppings" NVARCHAR(100)
);
INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');

--Creating the Pizza Toppings table and inserting the data

DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  "topping_id" INTEGER,
  "topping_name" NVARCHAR(100)
);
INSERT INTO pizza_toppings
  ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');

--A. Pizza Metrics
--a.1 How many pizza were ordered
SELECT COUNT(order_id) AS orders
FROM customer_orders
-- 18 pizzas were ordered

--a.2 How many unique customer orders were made?
SELECT COUNT(DISTINCT(order_id)) AS unique_orders
FROM customer_orders
-- 10 unique customer orders were made

--a.3 How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(order_id) as successful_runner_orders
FROM runner_orders
WHERE cancellation is NULL
GROUP BY runner_id
--runner 1 has 4 successful orders
--runner 2 has 3 successful orders
--runner 3 has 1 successful order

--a.4 How many of each type of pizza was delivered?
SELECT pizza_names.pizza_name, COUNT(customer_orders.pizza_id) AS pizza_type
FROM customer_orders
JOIN runner_orders
ON customer_orders.order_id = runner_orders.order_id
JOIN pizza_names
ON customer_orders.pizza_id = pizza_names.pizza_id
WHERE runner_orders.[distance in km] != 0
GROUP BY pizza_names.pizza_name
-- 12 Meatlovers were ordered
--3 Vegetarian were ordered

--a.5 How many Vegetarian and Meatlovers were ordered by each customer?
SELECT customer_orders.customer_id, pizza_names.pizza_name, COUNT(pizza_names.pizza_name) AS number_of_pizzas
FROM customer_orders
JOIN pizza_names
ON customer_orders.pizza_id = pizza_names.pizza_id
GROUP BY customer_orders.customer_id, pizza_names.pizza_name
ORDER BY customer_orders.customer_id
--101 ordered 2 Meatlovers and 1 Vegetarian
--102 ordered 2 Meatlovers and 1 Vegetarian
--103 ordered 4 Meatlovers and 1 Vegetarian
--104 ordered 6 Meatlovers
--105 ordered 1 Vegetarian

--a.6 What was the maximum number of pizzas delivered in a single order?
SELECT MAX(A.order_id_count) as maximum_pizza_delivered
FROM
(SELECT runner_orders.order_id, COUNT(runner_orders.order_id) as order_id_count 
FROM runner_orders
JOIN customer_orders
ON customer_orders.order_id = runner_orders.order_id
WHERE cancellation is NULL
GROUP BY runner_orders.order_id
)A
--Maximum 5 pizzas were delivered in a single order

--a.7 For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT customer_orders.customer_id,customer_orders.exclusions,customer_orders.extras,
CASE WHEN customer_orders.exclusions is not NULL or customer_orders.extras is NOT NULL THEN 1 ELSE 0 END AS changes,
CASE WHEN customer_orders.exclusions is NULL AND customer_orders.extras is NULL THEN 1 ELSE 0 END AS no_changes
FROM customer_orders
JOIN runner_orders
ON customer_orders.order_id = runner_orders.order_id
WHERE cancellation is NULL
ORDER BY customer_id
--101 and 102 wanted original pizzas
--103 and 105 wanted at least 1 change to their pizzas
--104 sometimes ordered orginal pizzas and sometimes made changes

--a.8 How many pizzas were delivered that had both exclusions and extras?
SELECT COUNT(B.customer_id) AS pizza_with_exclusions_and_extras
FROM
(SELECT customer_orders.customer_id, customer_orders.exclusions, customer_orders.extras
FROM customer_orders
JOIN runner_orders
ON customer_orders.order_id = runner_orders.order_id
WHERE runner_orders.[distance in km] != 0
)B
WHERE B.exclusions is not NULL and B.extras is not NULL
--4 pizzas were delivered that had both exclusions and extras

--a.9 What was the total volume of pizzas ordered for each hour of the day?
SELECT DATEPART(HOUR, order_time) AS hours_of_day, COUNT(order_id) AS pizzas_ordered_volume
FROM customer_orders
GROUP BY DATEPART(HOUR, order_time)
--11 hour had 2 orders
--13 hour had 3 orders
--18 hour had 6 orders
--19 hour had 1 order
--21 hour had 3 orders
--23 hour had 3 orders

--a.10 What was the volume of orders for each day of the week?
SELECT FORMAT(order_time ,'dddd')AS day_of_the_week, COUNT(order_id) AS pizza_count
FROM customer_orders
GROUP BY FORMAT(order_time ,'dddd')
--Friday had 2 orders
--Saturday had 8 orders
--Thursday had 3 orders
--Wednesday had 5 orders

--B. Runner and Customer Experience

--b.1 How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT DATEPART(WEEK, registration_date) as weeks_registered,COUNT(runner_id) as runners_registered
FROM runners
GROUP BY DATEPART(WEEK, registration_date)
--Week 1 had 1 runner
--Week 2 had 2 runners
--Week 3 had 1 runner

--b.2 What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
SELECT C.runner_id, AVG(C.times_taken) AS average_time_taken
FROM
(SELECT runner_orders.runner_id, DATEDIFF(MINUTE, customer_orders.order_time,runner_orders.pickup_time) AS times_taken
FROM runner_orders
JOIN customer_orders
ON runner_orders.order_id = customer_orders.order_id
WHERE runner_orders.[distance in km] != 0
)C
GROUP BY C.runner_id
--runner 1 took 15 minutes
--runner 2 took 24 minutes
--runner 3 took 10 minutes

--b.3 Is there any relationship between the number of pizzas and how long the order takes to prepare?
SELECT D.number_of_pizzas_per_order, AVG(D.prep_times) AS avarage_prep_times
FROM
(SELECT runner_orders.order_id, COUNT(runner_orders.order_id) AS number_of_pizzas_per_order,
customer_orders.order_time, runner_orders.pickup_time,DATEDIFF(MINUTE, customer_orders.order_time,runner_orders.pickup_time) AS prep_times
FROM runner_orders
JOIN customer_orders
ON runner_orders.order_id = customer_orders.order_id
WHERE runner_orders.[distance in km] != 0
GROUP BY runner_orders.order_id, customer_orders.order_time, runner_orders.pickup_time
)D
GROUP BY D.number_of_pizzas_per_order
--it took 12 minutes for 1 pizza
--21 minutes for 2 pizzas
--30 minutes for 3 pizzas
--16 minutes for 5 pizzas

--b.4 What was the average distance travelled for each customer?
SELECT customer_orders.customer_id, ROUND(AVG(runner_orders.[distance in km]),2) AS average_distance
FROM customer_orders
JOIN runner_orders
ON customer_orders.order_id = runner_orders.order_id
WHERE runner_orders.[distance in km] != 0
GROUP BY customer_orders.customer_id
ORDER BY customer_orders.customer_id
-- 101 is 20km
-- 102 is 16.73km


--b.5 What was the difference between the longest and shortest delivery times for all orders?
SELECT MAX([duration in minutes]) -  MIN([duration in minutes]) AS difference_in_delivery_time
FROM runner_orders
WHERE [distance in km] != 0 
--the difference is 30 minutes

--b.6 What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT E.runner_id, E.number_of_pizzas, AVG(ROUND((1.0 * E.[distance in km]/ E.[duration in hours]),1)) AS avarage_speed
FROM
(SELECT runner_orders.runner_id, COUNT(runner_orders.order_id) AS number_of_pizzas, 
runner_orders.[distance in km], ROUND(1.0 * runner_orders.[duration in minutes]/60,2) AS [duration in hours]
FROM customer_orders
JOIN runner_orders
ON customer_orders.order_id = runner_orders.order_id
WHERE runner_orders.[distance in km] != 0
GROUP BY runner_orders.runner_id, runner_orders.[distance in km], runner_orders.[duration in minutes]
)E
GROUP BY E.number_of_pizzas, E.runner_id
-- runner 1's speed fluctuates between 41km/h to 58.8km/h
-- runner 2's speed varies between 34.9km/h to 76.5km/h. His avarage speed increase roughly 100% for each 1 additional pizza
-- runner 3's speed is 40km/h

--b.7 What is the successful delivery percentage for each runner?
SELECT runner_orders.runner_id,
1.0 *  SUM(CASE WHEN [distance in km] != 0 THEN 1 
ELSE 0 END)/COUNT(*) * 100 AS success_rate
FROM runner_orders
GROUP BY runner_id
--runner 1 is 100%
--runner 2 is 75%
--runner 3 is 50%

--C. Ingredient Optimisation

--Recreating the pizza_recipes table so that each table has pizza_id and its topping
DROP table if exists dbo.pizza_recipes;

CREATE TABLE dbo.pizza_recipes
(
  pizza_id int,
  toppings int,
  topping_name nvarchar(150)
);

INSERT INTO dbo.pizza_recipes
VALUES
(1,1, 'Bacon'),
(1,2,  'BBQ Sauce'),
(1,3 , 'Beef'),
(1,4, 'Cheese'),
(1,5, 'Chicken'),
(1,6, 'Mushrooms'),
(1,8, 'Pepperoni'),
(1,10, 'Salami'),
(2,4, 'Cheese'),
(2,6, 'Mushrooms'),
(2,7, 'Onions'),
(2,9, 'Peppers'),
(2,11, 'Tomatoes'),
(2,12, 'Tomato Sauce');

--c.1 What are the standard ingredients for each pizza?
SELECT pizza_names.pizza_name, STRING_AGG(topping_name,',') AS standard_ingredients
FROM pizza_recipes
JOIN pizza_names
ON pizza_recipes.pizza_id = pizza_names.pizza_id
GROUP BY pizza_recipes.pizza_id, pizza_names.pizza_name
--Meatlovers: Bacon,BBQ Sauce,Beef,Cheese,Chicken,Mushrooms,Pepperoni,Salami
--Vegetarian: Cheese,Mushrooms,Onions,Peppers,Tomatoes,Tomato Sauce

--c.2 What was the most commonly added extra?
SELECT pizza_toppings.topping_name, COUNT(customer_orders.extras) AS added_extra
FROM customer_orders
JOIN pizza_toppings
ON pizza_toppings.topping_id = customer_orders.extras 
WHERE customer_orders.extras is NOT NULL
GROUP BY pizza_toppings.topping_name
--Bacon is the most added extra with 5
--Cheese is the second with 2
--Chicken is the last with 1

--c.3 What was the most common exclusion?
SELECT TOP 1*
FROM
(SELECT pizza_toppings.topping_name, COUNT(customer_orders.exclusions) AS most_common_added_exclusions
FROM customer_orders
JOIN pizza_toppings
ON customer_orders.exclusions = pizza_toppings.topping_id
WHERE exclusions is NOT NULL
GROUP BY pizza_toppings.topping_name
)F
ORDER BY F.most_common_added_exclusions DESC
--The most common added exclustion is Cheese with 5 times added

--c.4 Generate an order item for each record in the customers_orders table in the format of one of the following:
--Meat Lovers
--Meat Lovers - Exclude Beef
--Meat Lovers - Extra Bacon
--Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
-- etc.
SELECT customer_orders.customer_id,pizza_names.pizza_name, customer_orders.exclusions, customer_orders.extras, 
CASE WHEN pizza_name = 'Meatlovers' AND exclusions is NULL AND extras is NULL THEN 'Meatlovers'
WHEN pizza_name = 'Meatlovers' AND exclusions = '3' THEN 'Meatlovers - Exclude Beef'
WHEN pizza_name = 'Meatlovers' AND exclusions = '4' THEN 'Meatlovers - Exclude Cheese'
WHEN pizza_name = 'Meatlovers' AND extras = '1' THEN 'Meatlovers - Extra Beef'
WHEN pizza_name = 'Meatlovers' AND exclusions IN ('1','4') AND extras IN ('6','9') THEN 'Meatlovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers'
WHEN pizza_name = 'Meatlovers' AND extras IN ('1','4') AND exclusions IN ('6','9') THEN 'Meatlovers - Extra Cheese, Bacon - Exclude Mushroom, Peppers'
WHEN pizza_name = 'Meatlovers' AND extras IN ('1','4') AND exclusions = '2' THEN 'Meatlovers - Extra Cheese, Bacon - Exclude BBQ Sauce'
WHEN pizza_name = 'Vegetarian' AND exclusions is NULL AND extras is NULL THEN 'Vegetarian'
ELSE NULL
END AS ordered_items
FROM customer_orders
LEFT JOIN pizza_names
ON customer_orders.pizza_id = pizza_names.pizza_id
ORDER BY customer_id

--D. Pricing and Ratings
--d.1 If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - 
--how much money has Pizza Runner made so far if there are no delivery fees?
SELECT SUM(G.revenue) AS total_revenues
FROM
(SELECT customer_orders.customer_id, runner_orders.runner_id, CASE WHEN customer_orders.pizza_id = '1' THEN 12 ELSE 10 END AS revenue
FROM customer_orders
LEFT JOIN runner_orders
ON customer_orders.order_id = runner_orders.order_id
WHERE [distance in km] != 0
)
G
--The restaurant's total revenue is $174

--d.2 What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra
SELECT SUM(CASE WHEN H.extras is NULL THEN H.revenue
WHEN H.extras = '4' THEN H.revenue + 2
ELSE H.revenue + 1
END) AS total_revenues
FROM
(SELECT customer_orders.customer_id, runner_orders.runner_id, customer_orders.extras,
CASE WHEN customer_orders.pizza_id = '1' THEN 12 ELSE 10 END AS revenue
FROM customer_orders
LEFT JOIN runner_orders
ON customer_orders.order_id = runner_orders.order_id
WHERE [distance in km] != 0
)
H
--In this case, the total revenue is $182

--d.3 The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, 
--how would you design an additional table for this new dataset - 
--generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
DROP TABLE IF EXISTS customer_ratings;

CREATE TABLE customer_ratings
(order_id int,
runner_id int,
ratings int)

INSERT INTO customer_ratings VALUES
(1,1,3),
(2,1,4),
(3,1,4),
(4,2,3),
(5,3,4),
(6,3,0),
(7,2,5),
(8,2,5),
(9,2,0),
(10,1,4)

SELECT *
FROM customer_ratings

--d.4 Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
--customer_id
--order_id
--runner_id
--rating
--order_time
--pickup_time
--Time between order and pickup in minutes
--Delivery duration
--Average speed
--Total number of pizzas

SELECT customer_orders.customer_id, runner_orders.order_id,runner_orders.runner_id,customer_ratings.ratings, 
customer_orders.order_time,runner_orders.pickup_time, runner_orders.[duration in minutes],runner_orders.[distance in km],
DATEPART(MINUTE,runner_orders.pickup_time - customer_orders.order_time) AS time_gap, 
ROUND(1.0 * runner_orders.[distance in km]/(1.0*runner_orders.[duration in minutes]/60),1) AS average_speed, COUNT(customer_orders.order_id) AS [number of pizzas]
FROM customer_orders
JOIN runner_orders
ON customer_orders.order_id = runner_orders.order_id
JOIN customer_ratings
ON customer_orders.order_id = customer_ratings.order_id
WHERE [distance in km] != 0 
GROUP BY customer_orders.customer_id, runner_orders.order_id,runner_orders.runner_id,customer_ratings.ratings, 
customer_orders.order_time,runner_orders.pickup_time, DATEPART(MINUTE,runner_orders.pickup_time - customer_orders.order_time), 
runner_orders.[duration in minutes], runner_orders.[distance in km]

--d.5 If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled 
-- how much money does Pizza Runner have left over after these deliveries?
SELECT SUM(K.prices * K.[number of pizzas]) AS revenue, SUM(K.runner_payment) AS payment, SUM(K.prices * K.[number of pizzas]) - SUM(K.runner_payment) AS total_profits
FROM
(SELECT customer_orders.customer_id, runner_orders.order_id, CASE WHEN customer_orders.pizza_id = '1' THEN 12 ELSE 10 END AS prices, 
runner_orders.[distance in km], 0.3 * runner_orders.[distance in km] AS runner_payment, COUNT(runner_orders.order_id) AS [number of pizzas]
FROM customer_orders
JOIN runner_orders
ON customer_orders.order_id = runner_orders.order_id
WHERE [distance in km] != 0
GROUP BY customer_orders.customer_id, runner_orders.order_id,runner_orders.[distance in km],customer_orders.pizza_id
)K
--The restaurant's profit is $119.4