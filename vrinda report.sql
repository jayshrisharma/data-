create database vrinda;
create table sales_report (
 index_id bigint primary key,
 Order_ID text ,
Cust_ID text ,
Gender text ,
Age_Group text ,
Age text ,
Order_Date text ,
Month_name text ,
Status text ,
Channel text ,
SKU text ,
Category text ,
Size text ,
Qty text ,
currency text,
Amount text,
ship_city text,
ship_state text ,
s text,
ship_country text,
B2B text);

LOAD DATA  local infile "C:/Users/jayshri/OneDrive/Desktop/data project/sql/Vrinda_Store_Data.csv"
INTO TABLE sales_report
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT * 
FROM sales_report
WHERE Amount IS NOT NULL;


select count(*)from sales_report;
SET sql_mode = '';

-- Orders vs Sales 
select 
ifnull(Month(Order_Date),'total') As month,
count(Order_ID) As Total_Orders,
concat(round(sum(Amount )/ 1000000,2),'M')As Total_sales
from sales_report
group by Month(Order_Date) with rollup; 

-- Sales Men Vs Women
select  ifnull(Gender , 'Total') as Gender,
 sum(Amount)as Total_Sales,
  concat(round(sum(Amount)*100.0 /(select sum(Amount)
from sales_report),2),'%') AS Sales_Percentage
from sales_report
group by Gender with rollup ;

-- Order Status
select  ifnull(Status ,'Total') as Status,
concat(
round(count(Order_ID)/1000, 2),'K') as Total_Orders
from sales_report
group by Status with rollup ;

-- Top 10 States by sale
select ship_state,
 concat(round(sum(Amount) /1000,2),'K') as total_sales
 from sales_report
 group by ship_state 
 order by total_sales desc
 limit 10;
 
 -- Age Vs Gender
 select Age_Group,
 Gender,
  concat(round(sum(Amount) /1000,2),'K') as total_sales
  from sales_report
  group by Age_Group , Gender 
  order by Age_Group;
  
  -- order by Channel
  select Channel,
   concat(round(count(order_id) /1000,2),'K') as total_orders
   from sales_report
   group by Channel;
 
 
 


 
select distinct ship_state
from sales_report
limit 20 ;


