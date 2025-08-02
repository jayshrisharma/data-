create database Hr;
CREATE TABLE employee_attrition (
    Age INT,
    Attrition VARCHAR(5),
    BusinessTravel VARCHAR(50),
    DailyRate INT,
    Department VARCHAR(50),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(50),
    EmployeeCount INT,
    EmployeeNumber INT,
    EnvironmentSatisfaction INT,
    Gender VARCHAR(10),
    HourlyRate INT,
    JobInvolvement INT,
    JobLevel INT,
    JobRole VARCHAR(50),
    JobSatisfaction INT,
    MaritalStatus VARCHAR(20),
    MonthlyIncome INT,
    MonthlyRate INT,
    NumCompaniesWorked INT,
    Over18 VARCHAR(100),
    OverTime VARCHAR(100),
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT,
    AgeGroup VARCHAR(100)
);
-- In MySQL
LOAD DATA  local infile "C:/Users/jayshri/OneDrive/Desktop/data project/sql/emp_attrition.csv"
INTO TABLE employee_attrition
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select count(*)from employee_attrition;
-- Total Employees
SELECT COUNT(*) AS Total_Employees
FROM employee_attrition;

-- Employees Who Left 
SELECT COUNT(*) AS Employees_Left
FROM employee_attrition
WHERE Attrition = 'Yes';

-- Attrition Rate (%)
SELECT 

  CONCAT(ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2), '%') AS Attrition_Rate
FROM employee_attrition;

-- Average Monthly Income
SELECT 
  CONCAT(ROUND(AVG(MonthlyIncome) / 1000, 1), 'K') AS Avg_Monthly_Income
FROM employee_attrition;

--  Average Age
SELECT ROUND(AVG(Age), 0) AS Avg_Age
FROM employee_attrition;

-- Average Working Years
SELECT 
 ConCat (ROUND(AVG(TotalWorkingYears), 0), 'Year' )AS Avg_Total_Working_Years
FROM employee_attrition;

-- Average Years at Company
SELECT  ConCat( ROUND(AVG(YearsAtCompany), 0), 'Year' )AS Avg_Years_At_Company
FROM employee_attrition;

-- Attrition by Department
SELECT Department, 
       COUNT(*) AS Total_Employees,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left
FROM employee_attrition
GROUP BY Department;

-- Attrition by Gender
SELECT Gender,
       COUNT(*) AS Total_Employees,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left
FROM employee_attrition
GROUP BY Gender;

--  Attrition by Age Group
UPDATE employee_attrition
SET AgeGroup = CASE
    WHEN Age < 25 THEN '<25'
    WHEN Age BETWEEN 25 AND 34 THEN '25-34'
    WHEN Age BETWEEN 35 AND 44 THEN '35-44'
    WHEN Age BETWEEN 45 AND 54 THEN '45-54'
    ELSE '55+'
END;

SELECT AgeGroup,
       COUNT(*) AS Total_Employees,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left
FROM employee_attrition
GROUP BY AgeGroup
ORDER BY AgeGroup;

-- Average Monthly Income by Job Role
SELECT JobRole, 
      ConCat( ROUND(AVG(MonthlyIncome), 2), 'k' )AS Avg_Monthly_Income
FROM employee_attrition
GROUP BY JobRole
ORDER BY Avg_Monthly_Income DESC;











