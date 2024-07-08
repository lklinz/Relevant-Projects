USE master;
GO

IF NOT EXISTS (
      SELECT name
      FROM sys.databases
      WHERE name = N'TutorialDB'
      )
   CREATE DATABASE [Dannys_Dinner];
GO

IF SERVERPROPERTY('ProductVersion') > '12'
   ALTER DATABASE [Dannys_Dinner] SET QUERY_STORE = ON;
GO

---Creating Sales table

CREATE TABLE dbo.sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

--Inserting Sales data
INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');

--Creating the Menu Table
CREATE TABLE dbo.menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);
--Inserting Menu Data
INSERT INTO dbo.menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  
--Creating Members Table
CREATE TABLE dbo.members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);
--Inserting members data
INSERT INTO dbo.members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');

SELECT *
FROM dbo.sales

SELECT *
FROM menu

SELECT customer_id,product_id
FROM dbo.sales 

	

--1 What is the total amount each customer spent at the restaurant?
SELECT SUM(menu.price) AS total_spending
FROM sales
LEFT JOIN menu
	ON sales.product_id = menu.product_id
WHERE sales.customer_id = 'A'

SELECT SUM(menu.price) AS total_spending
FROM sales
LEFT JOIN menu
	ON sales.product_id = menu.product_id
WHERE sales.customer_id = 'B'

SELECT SUM(menu.price) AS total_spending
FROM sales
LEFT JOIN menu
	ON sales.product_id = menu.product_id
WHERE sales.customer_id = 'C'

--2 How many days has each customer visited the restaurant?
SELECT customer_id, COUNT(DISTINCT(order_date)) as visit_times
FROM sales
GROUP BY (customer_id)


--3 What was the first item from the menu purchased by each customer?
SELECT c.customer_id, c.product_name
FROM
(
SELECT customer_id, order_date, product_name,
      ROW_NUMBER() OVER(PARTITION BY s.customer_id
      ORDER BY s.order_date) AS rownum
   FROM dbo.sales AS s
   JOIN dbo.menu AS m
      ON s.product_id = m.product_id
)c
WHERE c.rownum= 1
GROUP BY c.customer_id, c.product_name;
--4 What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT TOP 1 (COUNT(a.product_name)) AS most_purchased, a.product_name
FROM
(
SELECT product_name
FROM sales
JOIN menu
	ON sales.product_id = menu.product_id
)a
GROUP BY a.product_name
ORDER BY most_purchased DESC

--5 Which item was the most popular for each customer?
SELECT *
FROM dbo.sales

SELECT *
FROM menu
SELECT sales.customer_id, menu.product_name, COUNT(menu.product_name) AS order_time
FROM sales
JOIN menu
	ON sales.product_id = menu.product_id
	GROUP BY sales.customer_id,menu.product_name
	ORDER BY order_time DESC
--6 Which item was purchased first by the customer after they became a member?
SELECT *
FROM members

SELECT R.customer_id, R.order_date, menu.product_name
FROM
(SELECT sales.customer_id, sales.order_date, members.join_date,sales.product_id, DENSE_RANK() OVER(PARTITION BY members.customer_id ORDER BY sales.order_date) as date_after
FROM members
LEFT OUTER JOIN sales
	ON sales.customer_id = members.customer_id
	WHERE members.join_date <= sales.order_date
	)R
JOIN menu
	ON R.product_id = menu.product_id
WHERE R.date_after = 1
	

--7 Which item is purchased just before the customer become a member
SELECT A.customer_id, A.order_date, menu.product_name
FROM
(SELECT sales.customer_id, sales.order_date, members.join_date,sales.product_id, DENSE_RANK() OVER(PARTITION BY members.customer_id ORDER BY sales.order_date) as date_after
FROM members
LEFT OUTER JOIN sales
	ON sales.customer_id = members.customer_id
	WHERE members.join_date > sales.order_date
	)A
JOIN menu
	ON A.product_id = menu.product_id
WHERE A.date_after = 1

--8 What is the total item and amount spent by each member before they become a member
SELECT *
FROM dbo.sales
SELECT *
FROM menu

SELECT B.customer_id, COUNT(B.product_id) AS items, SUM(menu.price) AS total_spending
FROM
(SELECT sales.customer_id, sales.order_date, members.join_date,sales.product_id
FROM members
LEFT OUTER JOIN sales
	ON sales.customer_id = members.customer_id
	WHERE members.join_date > sales.order_date
	)B
JOIN menu
	ON B.product_id = menu.product_id
GROUP BY B.customer_id

--9. If each $1 equates to 10 points and sushi has 2x point multipler, how many points does each customer have?
SELECT C.customer_id, SUM(C.points) AS total_points
FROM
(SELECT sales.customer_id, menu.product_name, menu.price,
CASE WHEN menu.product_name = 'sushi' THEN menu.price * 10 * 2
ELSE menu.price *10
END AS points
FROM menu
JOIN sales
	ON sales.product_id = menu.product_id
)C
GROUP BY C.customer_id

--10 In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
--not just sushi — how many points do customer A and B have at the end of January?

SELECT D.customer_id, SUM(D.points) AS total_points
FROM
(SELECT sales.customer_id,sales.product_id,sales.order_date,members.join_date, menu.price, menu.product_name,
CASE WHEN sales.order_date >= members.join_date
or sales.order_date < members.join_date and menu.product_name = 'sushi' THEN menu.price * 10 * 2
ELSE menu.price * 10 
END AS points
FROM sales
JOIN members
ON sales.customer_id = members.customer_id
JOIN menu
ON sales.product_id = menu.product_id
)D
JOIN menu
ON D.product_id = menu.product_id
GROUP BY D.customer_id














