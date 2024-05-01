-- DATA CLEANING

use diwali;

alter table `diwali sales data` rename to diwali_sales_data;

select * from diwali_sales_data;

alter table diwali_sales_data rename column `Age Group` to `Age_Group`;

alter table diwali_sales_data drop unnamed1;
  
SELECT occupation,Product_Category, COUNT(*)
FROM diwali_sales_data
GROUP BY occupation,Product_Category
HAVING COUNT(*) > 1;  
  
-- 1. Remove Duplicate
-- 2. Standardize the Data
-- 3. Null Value and Blank value
-- 4. Remove any columns.

with duplicate_cte as 
(
select * ,
row_number() over (partition by User_ID , Cust_name , Product_ID , Gender,
Age_Group , Age , Marital_Status , State , Zone , Occupation , Product_Category,Orders,Amount) as row_num
from diwali_sales_data 
)
select * from 
duplicate_cte
where row_num > 1;


create table sales_data
like diwali_sales_data;

select * from sales_data;

insert sales_data
select * from diwali_sales_data;

select * from sales_data 
where zone = 'western'
and state = 'Maharashtra'
order by age limit 5;

create table sales_data2 (
User_ID int ,
Cust_name text, 
Product_ID text, 
Gender text ,
Age_Group text, 
Age int ,
Marital_Status int ,
State text ,
Zone text ,
Occupation text ,
Product_Category text, 
Orders int ,
Amount int,
row_num int
)
engine= InnoDB default charset=utf8mb4 collate =utf8mb4_0900_ai_ci;


insert into sales_data2
select * ,
row_number() over (partition by User_ID , Cust_name , Product_ID , Gender,
Age_Group , Age , Marital_Status , State , Zone , Occupation , Product_Category,Orders,Amount) as row_num
from sales_data ;

select * from sales_data2;




select * from 
sales_data2
where row_num > 1;

SET SQL_SAFE_UPDATES = 0;

delete from 
sales_data2
where row_num > 1;


-- Standardizing Data

-- trim is used to remove whitespaces from the value.

select * from 
sales_data2;

select Cust_name , trim(Cust_name)
from sales_data2;

select *
from sales_data2
where Cust_name like 'andy%';


select Age_group
from sales_data2
group by Age_Group
order by 1 asc;


ALTER TABLE your_table
ADD COLUMN age_group VARCHAR(50);

UPDATE sales_data2
SET age_group = 
    CASE
        WHEN age BETWEEN 0 AND 17 THEN 'Under 18'
        WHEN age BETWEEN 18 AND 25 THEN 'Young Adult'
        WHEN age BETWEEN 26 AND 35 THEN 'Adult'
        WHEN age BETWEEN 36 AND 45 THEN 'Mature Adult'
        WHEN age BETWEEN 46 AND 50 THEN 'Middle-Aged'
        WHEN age BETWEEN 51 AND 55 THEN 'Older Adult'
        WHEN age >= 55 THEN 'Senior'
        ELSE 'Unknown'
    END;
    
select * from sales_data2;   

alter table sales_data2
drop column row_num; 
 
-- How many unique users are there in the dataset?
select distinct(User_id)
from sales_data2;

-- What is the distribution of users by gender?

SELECT gender, COUNT(User_ID) AS Number_of_Users
FROM sales_data2
GROUP BY gender;

select * from sales_data2; 

-- How many users fall into each age group?

select Age_group , count(user_id)
from sales_data2
group by Age_Group
order by 1 asc;

-- What is the most common age group among the users?


SELECT Age_Group, COUNT(User_ID) AS Number_of_Users
FROM sales_data2
GROUP BY Age_Group
ORDER BY Number_of_Users DESC
LIMIT 1;

-- How many unique products are being sold?

select * from sales_data2; 

select count(distinct product_category) as unique_product
from sales_data2;

-- What are the top-selling products by the number of orders?

select product_category , sum(orders) as total_order
from sales_data2
group by Product_Category
order by 2 desc
limit 5;

SELECT Product_ID, SUM(Orders) AS Total_Orders
FROM sales_data2
GROUP BY Product_ID
ORDER BY Total_Orders DESC;

-- Which product category has the highest sales revenue?

select * from sales_data2; 

select Product_Category , sum(amount) as highest_sales_revenue
from sales_data2
group by Product_Category
order by highest_sales_revenue desc
limit 1;

-- What is the average order amount per user?

select * from sales_data2; 

select user_id , avg(amount) as Avg_ammount
from sales_data2
group by user_id;

SELECT User_ID, AVG(Amount) AS Average_Order_Amount
FROM sales_data2
GROUP BY User_ID;

-- How many orders does the average user place?

select * from sales_data2; 

select avg(orders) 
from sales_data2;


-- What is the average amount spent by users in different age groups?

select * from sales_data2; 

select age_group , avg(amount) as avg_amount
from sales_data2
group by Age_Group
order by avg_amount desc;

-- How many unique states are represented in the dataset?

select * from sales_data2;

select count(distinct state)
from sales_data2;

-- What is the distribution of users across different states?

select state , count(user_id) as No_of_users
from sales_data2
group by state 
order by No_of_users;

-- Which state has the highest sales revenue?

select state , max(amount) as highest_sales_revenue
from sales_data2
group by state
order by highest_sales_revenue
limit 1;

select * from sales_data2;

-- What are the most common occupations among the users?

select occupation  , count(user_id) as total_occupation_user
from sales_data2
group by occupation
order by total_occupation_user;


-- How does marital status correlate with the number of orders or amount spent?

select * from sales_data2;

select marital_status , avg(orders) as avg_order , avg(amount) as avg_amount
from sales_data2
group by marital_status;

-- What is the distribution of users across different zones?

select zone , count(user_id) as user_count
from sales_data2
group by zone;

-- Which zone has the highest average order amount?

select zone , avg(amount) as avg_amount
from sales_data2
group by zone
order by avg_amount 
limit 1;

select * from sales_data2;
