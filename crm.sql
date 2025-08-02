create database crm;
CREATE TABLE Opportunity (
    Account_ID TEXT,
    Backlog_Rev TEXT,
    Bio_Reactors_used TEXT,
    BM_Test TEXT,
    Campaign_ID TEXT,
    Cell_Culture_Media TEXT,
    Cell_Type TEXT,
    Close_Date TEXT,
    Closed TEXT,
    Closed_Lost_Reason TEXT,
    Competitive_Product_Details TEXT,
    Contact_ID TEXT,
    COVID_Notes TEXT,
    COVID_Status TEXT,
    Created_By_ID TEXT,
    Created_by_Lead_Conversion TEXT,
    Created_Date TEXT,
    Date_Opportunity_was_Closed TEXT,
    Deleted TEXT,
    DOR_Distributor TEXT,
    DOR_Expiration TEXT,
    Final_Quote TEXT,
    Fiscal_Period TEXT,
    Fiscal_Quarter TEXT,
    Fiscal_Year TEXT,
    Forecast_Category TEXT,
    Forecast_Category1 TEXT,
    Forecast_Q_Commit TEXT,
    Forecast_Q_Prior_Commit TEXT,
    Funding_Source TEXT,
    Has_Line_Item TEXT,
    Has_Open_Activity TEXT,
    Has_Overdue_Task TEXT,
    Industry TEXT,
    Install_This_Quarter TEXT,
    Interface_Type TEXT,
    Internal_Forecast TEXT,
    Last_Activity TEXT,
    Last_Modified_By_ID TEXT,
    Last_Modified_Date TEXT,
    Last_Referenced_Date TEXT,
    Last_Stage_Change_Date TEXT,
    Last_Stage_Change_Date1 TEXT,
    Last_Viewed_Date TEXT,
    LDO TEXT,
    LDO_Priority_Level TEXT,
    Lead_Application TEXT,
    Lead_Source TEXT,
    LS_Other_Research_Area TEXT,
    LS_Research_Area TEXT,
    Mass_Spec_Manufacturer TEXT,
    Mass_Spec_Type TEXT,
    Media_Provider TEXT,
    Opportunity_ID TEXT,
    Opportunity_Type TEXT,
    Order_Finalized TEXT,
    Other_Closed_Lost_Details TEXT,
    Other_Mass_Spec_Type TEXT,
    Other_Research_Area TEXT,
    Owner_ID TEXT,
    Price_Book_ID TEXT,
    Primary_Application TEXT,
    Primary_Application_FF TEXT,
    Primary_Contact TEXT,
    Product_Category TEXT,
    Product_of_Interest TEXT,
    Purchase_Agent TEXT,
    Quote_ID TEXT,
    Record_Type_ID TEXT,
    Registered_Vendor_confirmed TEXT,
    Secondary_Application_FF TEXT,
    Ship_This_Quarter TEXT,
    Ship_This_Quarter_List TEXT,
    Signing_Authority TEXT,
    Stage TEXT,
    Standard_Application TEXT,
    System_Modstamp TEXT,
    Technical_Owner TEXT,
    Training_Date TEXT,
    Validated_Customer_Needs TEXT,
    Won TEXT,
    Close_Date_Extensions TEXT,
    Close_Date_Month_Extensions TEXT,
    Amount TEXT,
    Days_Open TEXT,
    Expected_Amount TEXT,
    Probability_Percent TEXT,
    Push_Count TEXT
);


LOAD DATA LOCAL INFILE 
'C:/Users/jayshri/OneDrive/Desktop/First Project/second project/3rd/DA_P939 Dataset/DA_P939 Dataset/Dataset/Oppertuninty Table.csv' 
INTO TABLE Opportunity 
CHARACTER SET latin1
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;
-- Expected Amount

SELECT 
   concat( ROUND(
        SUM(
            CAST(REPLACE(REPLACE(Expected_Amount, '$', ''), ',', '') AS DECIMAL(18,2))
        ) / 1000000, 1  ) ,'M'
    ) AS Expected_Amount_Million
FROM 
    Opportunity;
    -- Active Opportunities

    SELECT 
    COUNT(*) AS Active_Opportunities
FROM 
    Opportunity
WHERE 
    Stage NOT IN ('Closed Won', 'Closed Lost');
-- Conversion Rate

SELECT 
   concat( ROUND(
        (COUNT(CASE WHEN LOWER(TRIM(Won)) = 'true' THEN 1 END) * 100.0) / 
        NULLIF(COUNT(*), 0),
        2
        ),"%"
    ) AS Conversion_Rate_Percent
FROM 
    Opportunity;
    
   -- Loss Rate 
SELECT 
   concat( ROUND(
        (COUNT(CASE WHEN Stage = 'CLOSED LOST' THEN 1 END) * 100.0) /
        NULLIF(
            COUNT(CASE WHEN Stage IN ('CLOSED WON', 'CLOSED LOST') THEN 1 END),
            0
        ),
        2),"%"
    ) AS Loss_Rate_Percent
FROM 
    Opportunity;
    
    -- Win Rate
    SELECT 
   concat( ROUND(
        (COUNT(CASE WHEN Stage = 'CLOSED WON' THEN 1 END) * 100.0) /
        NULLIF(
            COUNT(CASE 
                      WHEN Stage IN ('CLOSED WON', 'CLOSED LOST') 
                      THEN 1 
                 END), 
            0
        ),
        2),"%"
    ) AS Win_Rate_Percent
FROM 
    Opportunity;
    
    -- Trend Analysis 

    SELECT 
    DATE_FORMAT(STR_TO_DATE(Created_Date, '%m/%d/%Y'), '%Y-%m') AS Month,
    COUNT(*) AS Total_Opportunities
FROM 
    Opportunity
WHERE 
    Created_Date IS NOT NULL
GROUP BY 
    Month
ORDER BY 
    Month;
    
    -- Total_Expected_Amount
    SELECT 
    DATE_FORMAT(STR_TO_DATE(Created_Date, '%m/%d/%Y'), '%Y-%m') AS Month,
    concat(ROUND(
      SUM(
            CAST(REPLACE(REPLACE(Expected_Amount, ',', ''), '$', '') AS DECIMAL(18,2))
        ) /10000,2 ),'K'
    ) AS Total_Expected_Amount
FROM 
    Opportunity
WHERE 
    Created_Date IS NOT NULL
GROUP BY 
    Month
ORDER BY 
    Month;
    
    -- Won_Opportunities
    SELECT 
    DATE_FORMAT(STR_TO_DATE(Close_Date, '%m/%d/%Y'), '%Y-%m') AS Month,
    COUNT(*) AS Won_Opportunities
FROM 
    Opportunity
WHERE 
    LOWER(TRIM(Won)) = 'true'
    AND Close_Date IS NOT NULL
GROUP BY 
    Month
ORDER BY 
    Month;

-- Expected Vs Forecast
SELECT 
    DATE_FORMAT(STR_TO_DATE(Created_Date, '%m/%d/%Y'), '%Y-%m') AS Month,
   concat( ROUND(
        SUM(
            CAST(REPLACE(REPLACE(Expected_Amount, ',', ''), '$', '') AS DECIMAL(18,2))
        ) / 1000,
        2),'K'
    ) AS Forecasted_Expected_Amount_K
FROM 
    Opportunity
WHERE 
    LOWER(TRIM(Internal_Forecast)) = 'true'
    AND Expected_Amount IS NOT NULL
    AND Created_Date IS NOT NULL
GROUP BY 
    Month
ORDER BY 
    Month;

-- Ative Vs Total Opportunities
SELECT 
    Month,
    SUM(Total_Opportunities) OVER (ORDER BY Month) AS Cumulative_Total,
    SUM(Active_Opportunities) OVER (ORDER BY Month) AS Cumulative_Active
FROM (
    SELECT 
        DATE_FORMAT(STR_TO_DATE(Created_Date, '%m/%d/%Y'), '%Y-%m') AS Month,
        COUNT(*) AS Total_Opportunities,
        COUNT(CASE 
            WHEN LOWER(TRIM(Stage)) NOT IN ('closed won', 'closed lost') THEN 1 
            END) AS Active_Opportunities
    FROM 
        Opportunity
    WHERE 
        Created_Date IS NOT NULL
    GROUP BY 
        Month
) AS sub
ORDER BY 
    Month;

-- Closed Won Vs Total Opportunities
SELECT 
    Industry,
    COUNT(Opportunity_ID) AS Total_Opportunities,
    COUNT(CASE 
        WHEN LOWER(TRIM(Stage)) = 'closed won' THEN 1 
    END) AS Closed_Won_Opportunities,
  concat(  ROUND(
        COUNT(CASE 
            WHEN LOWER(TRIM(Stage)) = 'closed won' THEN 1 
        END) * 100.0 / NULLIF(COUNT(Opportunity_ID), 0),
        2),"%"
    ) AS Win_Percentage
FROM 
    Opportunity
WHERE 
    Industry IS NOT NULL
GROUP BY 
    Industry
ORDER BY 
    Win_Percentage DESC;
    
    -- Closed Won Vs Total Closed
    SELECT 
    DATE_FORMAT(STR_TO_DATE(Close_Date, '%m/%d/%Y'), '%Y-%m') AS Month,
    
    COUNT(CASE 
        WHEN LOWER(TRIM(Stage)) = 'closed won' THEN 1 
    END) AS Closed_Won_Opportunities,

    COUNT(CASE 
        WHEN LOWER(TRIM(Stage)) IN ('closed won', 'closed lost') THEN 1 
    END) AS Total_Closed_Opportunities,

  concat(  ROUND(
        COUNT(CASE 
            WHEN LOWER(TRIM(Stage)) = 'closed won' THEN 1 
        END) * 100.0 / NULLIF(
            COUNT(CASE 
                WHEN LOWER(TRIM(Stage)) IN ('closed won', 'closed lost') THEN 1 
            END), 0
        ),
        2 ), '%'
    ) AS Win_After_Closure_Percent

FROM 
    Opportunity
WHERE 
    Close_Date IS NOT NULL
GROUP BY 
    Month
ORDER BY 
    Month;
    
    -- Expected Amount by Opportunity Type

SELECT 
    Opportunity_Type,
    CONCAT(
        ROUND(
            SUM(
                CAST(REPLACE(REPLACE(Expected_Amount, '$', ''), ',', '') AS DECIMAL(18,2))
            ) / 1000, 0
        ),
        'K'
    ) AS Total_Expected_Amount
FROM 
    Opportunity
WHERE 
    Expected_Amount IS NOT NULL
    AND Opportunity_Type IS NOT NULL
GROUP BY 
    Opportunity_Type
ORDER BY 
    SUM(
        CAST(REPLACE(REPLACE(Expected_Amount, '$', ''), ',', '') AS DECIMAL(18,2))
    ) DESC;


-- Opportunities by Industry
SELECT 
    Industry,
    COUNT(Opportunity_ID) AS Total_Opportunities
FROM 
    Opportunity
WHERE 
    Industry IS NOT NULL
GROUP BY 
    Industry
ORDER BY 
    Total_Opportunities DESC;












