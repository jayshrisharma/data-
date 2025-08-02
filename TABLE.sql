CREATE TABLE cleaned_data (
    RestaurantID bigint primary key,
    RestaurantName VARCHAR(233),
    CountryCode INT,
    City VARCHAR(100),
    Locality VARCHAR(100),
    Cuisines VARCHAR(255),
    Has_Table_booking VARCHAR(10),
    Has_Online_delivery VARCHAR(10),
    Is_delivering_now VARCHAR(10),
    Switch_to_order_menu VARCHAR(10),
    Price_range INT,
    Votes INT,
    CostUSD DECIMAL(6,2),
    Rating float,
    Datekey_Opening VARCHAR(50),
    OpeningDate VARCHAR(50),
    Year INT,
    Month_No INT,
    MonthName VARCHAR(50),
    Quarter VARCHAR(5),
    Month VARCHAR(20),
    WeekNumber INT,
    Weekday_No INT,
    WeekdayName VARCHAR(20),
    FinancialMonth VARCHAR(10),
    FinancialQuarter VARCHAR(10),
    RatingBucket VARCHAR(20),
    CostBucketUSD VARCHAR(20),
    PriceCategory VARCHAR(20)
);


SET GLOBAL LOCAL_INFILE= ON;

LOAD DATA Local INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cleaned_data.csv'
INTO TABLE cleaned_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

select count(*)from cleaned_data;

-- Total Restaurants
select count(*) as Total_Restaurants
from cleaned_data;

-- Average Rating
SELECT 
    ROUND(AVG(CAST(Rating AS DECIMAL(3,1))), 1) AS Average_Rating
FROM 
    cleaned_data;

-- avg_cost for two    
    SELECT ROUND(AVG( CostUSD),1) AS Avg_Cost_For_Two FROM cleaned_data;
   
   -- total votes
   SELECT SUM(Votes) AS Total_Votes FROM cleaned_data;
   
   
   -- Total unique cuisines
   SELECT COUNT(DISTINCT Cuisines) AS Unique_Cuisines FROM cleaned_data;
  
  
  -- Restaurant distribution by city
   SELECT City, COUNT(*) AS Restaurant_Count
FROM cleaned_data
GROUP BY City
ORDER BY Restaurant_Count DESC
LIMIT 5;

-- opening over time
SELECT 
  DATE_FORMAT(STR_TO_DATE(OpeningDate, '%d-%b-%y'), '%Y-%m') AS Month_Year,
  COUNT(*) AS Count_Of_Restaurants
FROM cleaned_data
GROUP BY DATE_FORMAT(STR_TO_DATE(OpeningDate, '%d-%b-%y'), '%Y-%m')
ORDER BY DATE_FORMAT(STR_TO_DATE(OpeningDate, '%d-%b-%y'), '%Y-%m');


SELECT OpeningDate FROM cleaned_data LIMIT 10;


-- % by online delivery
SELECT 
    Has_Online_delivery,
   concat( ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM cleaned_data), 2 ) , '%')AS Percentage
FROM cleaned_data
GROUP BY Has_Online_delivery with rollup ;


-- cost for two
SELECT 
  Price_Range,
  COUNT(*) AS Count_Of_Restaurants
FROM (
  SELECT 
  
    CASE 
      WHEN CostUSD < 100 THEN '<$100'
      WHEN CostUSD BETWEEN 100 AND 299 THEN '$100-$299'
      WHEN CostUSD BETWEEN 300 AND 499 THEN '$300-$499'
      WHEN CostUSD BETWEEN 500 AND 799 THEN '$500-$799'
      WHEN CostUSD >= 800 THEN '$800+'
      ELSE 'Unknown'
    END AS Price_Range
  FROM cleaned_data
) AS derived_table
GROUP BY Price_Range with rollup
ORDER BY Count_Of_Restaurants DESC;

-- top rated restaurants
SELECT 
RestaurantName, Rating
FROM cleaned_data
WHERE Rating = 4.0
ORDER BY RestaurantName;


-- top cuisines
SELECT ifnull( Cuisines, 'total') as
Cuisines, COUNT(*) AS Count
FROM cleaned_data
GROUP BY Cuisines with rollup 
ORDER BY Count DESC
LIMIT 10;

-- total city
SELECT COUNT(DISTINCT City) AS Total_Unique_Cities
FROM cleaned_data;

-- total country 
SELECT COUNT(DISTINCT CountryCode) AS Total_Unique_Countries
FROM cleaned_data;
