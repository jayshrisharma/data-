-- Total Loan Amount Funded
select sum(LoanAmount ) as Total_Loan_Amount_Funded
from bankdata where LoanAmount is not null;
 select concat ('₹', round(sum(LoanAmount)/ 1000000,2),'M')as Total_Loan_Amount_Funded
 from bankdata where LoanAmount is not null;
  -- Total Loans
 select count(*) as Total_Loans from bankdata where LoanAmount is not null;
 select concat ('₹', round(count(LoanAmount)/ 10000,2),'K')as Total_Loans
 from bankdata where LoanAmount is not null;
 -- Total Collection
 SELECT 
  CONCAT('₹ ', ROUND(SUM(TotalPymnt) / 1000000, 2), ' M') AS Total_Collection
FROM bankdata
WHERE TotalPymnt IS NOT NULL;
-- Total Interest
SELECT 
  CONCAT('₹ ', ROUND(SUM(TotalRrecint) / 1000000, 2), ' M') AS Total_Interest_Collected
FROM bankdata;

-- Branch-Wise Performance
SELECT 
  BranchName,
  ROUND(SUM(TotalRrecint) / 1000, 2) AS Total_Interest_K,
  ROUND(SUM(TotalRecLatefee) / 1000, 2) AS Total_Late_Fee_K,
  ROUND(SUM(CollectionRecoveryfee) / 1000, 2) AS Total_Recovery_Fee_K,
  ROUND(SUM(TotalRrecint + TotalRecLatefee + CollectionRecoveryfee) / 1000, 2) AS Total_Revenue_K
FROM 
  bankdata
GROUP BY 
  BranchName
ORDER BY 
  Total_Revenue_K DESC;

-- State-Wise Loan
SELECT 
  StateName,
  CONCAT('₹ ', ROUND(SUM(LoanAmount) / 1000000, 2), ' M') AS Total_Loan_Amount_M
FROM bankdata
WHERE LoanAmount IS NOT NULL
GROUP BY 
StateName
ORDER BY SUM(LoanAmount) DESC;

-- Religion-Wise Loan
SELECT 
  Religion,
  CONCAT('₹ ', ROUND(SUM(LoanAmount) / 1000000, 2), ' M') AS Total_Loan_Amount_M
FROM bankdata
WHERE LoanAmount IS NOT NULL
GROUP BY Religion
ORDER BY SUM(LoanAmount) DESC;

-- Product Group-Wise Loan
SELECT 
 ProductCode,
  CONCAT('₹ ', ROUND(SUM(LoanAmount) / 1000000, 2), ' M') AS Total_Loan_Amount_M
FROM bankdata
WHERE LoanAmount IS NOT NULL
GROUP BY ProductCode
ORDER BY SUM(LoanAmount) DESC;

-- Disbursement Trend
SELECT 
Disbursement_Date AS Year,
  CONCAT('₹ ', ROUND(SUM(LoanAmount) / 10000, 2), ' k') AS Total_Disbursed
FROM bankdata
WHERE LoanAmount IS NOT NULL
GROUP BY Disbursement_Date
ORDER BY Year;

-- Grade-Wise Loan
SELECT 
  Grrade AS Grade,
  CONCAT('₹ ', ROUND(SUM(LoanAmount) / 1000000, 2), ' M') AS Total_Loan_Amount
FROM bankdata
WHERE LoanAmount IS NOT NULL AND Grrade IS NOT NULL
GROUP BY Grrade
ORDER BY SUM(LoanAmount) DESC;

-- Default Loan Count
SELECT 
  COUNT(*) AS Default_Loan_Count
FROM bankdata
WHERE IsDefaultLoan ='Y';

-- Delinquent Client Count
SELECT COUNT(DISTINCT Clientid) AS Delinquent_Clients 
FROM bankdata 
WHERE IsDefaultLoan = 'Y';
DESCRIBE bankdata;

-- Delinquent Loan Rate
SELECT 
  ROUND(
    (SUM(CASE WHEN IsDefaultLoan = 'Y' THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
    2
  ) AS Delinquent_Loan_Rate_Percent
FROM bankdata;

-- Default Loan Rate
SELECT
  ROUND(
    100.0 * SUM(CASE 
                  WHEN TotalRecPrncp < 0.8 * FundedAmount THEN 1 
                  ELSE 0 
               END) / COUNT(*), 
    2
  ) AS Default_Loan_Rate_Percent
FROM bankdata;



-- Loan Status-Wise Loan
SELECT 
  LoanStatus,
  COUNT(*) AS Total_Loans,
  CONCAT('₹ ', ROUND(SUM(LoanAmount) / 1000000, 2), ' M') AS Total_Loan_Amount
FROM bankdata
WHERE LoanAmount IS NOT NULL AND LoanStatus IS NOT NULL
GROUP BY LoanStatus
ORDER BY SUM(LoanAmount) DESC;

-- Age Group-Wise Loan
SELECT
  CASE
    WHEN Age BETWEEN 18 AND 25 THEN '18-25'
    WHEN Age BETWEEN 26 AND 35 THEN '26-35'
    WHEN Age BETWEEN 36 AND 45 THEN '36-45'
    WHEN Age BETWEEN 46 AND 60 THEN '46-60'
    ELSE '60+'
  END AS Age_Group,
  COUNT(*) AS Total_Loans,
  CONCAT('₹ ', ROUND(SUM(LoanAmount) / 1000000, 2), ' M') AS Total_Loan_Amount
FROM bankdata
WHERE Age IS NOT NULL AND LoanAmount IS NOT NULL
GROUP BY Age_Group
ORDER BY Age_Group;

-- Loan Maturity
SELECT 
  Clientid,
  Disbursement_Date,
  Term,
  LENGTH(Term) AS Term_Length,
  REGEXP_SUBSTR(Term, '[0-9]+') AS Extracted_Number,
  CAST(REGEXP_SUBSTR(Term, '[0-9]+') AS UNSIGNED) AS Term_Months
FROM bankdata
WHERE Term IS NOT NULL AND Term != ''
LIMIT 10;




SELECT DISTINCT Term FROM bankdata;






-- No Verified Loans
SELECT 
  COUNT(*) AS No_Verified_Loans
FROM bankdata
WHERE Verification_Status = 'Not Verified';

SELECT 
  CASE
    WHEN TIMESTAMPDIFF(YEAR, DateofBirth, CURDATE()) BETWEEN 18 AND 25 THEN '18-25'
    WHEN TIMESTAMPDIFF(YEAR, DateofBirth, CURDATE()) BETWEEN 26 AND 35 THEN '26-35'
    WHEN TIMESTAMPDIFF(YEAR,DateofBirth, CURDATE()) BETWEEN 36 AND 45 THEN '36-45'
    WHEN TIMESTAMPDIFF(YEAR, DateofBirth, CURDATE()) BETWEEN 46 AND 60 THEN '46-60'
    ELSE '60+'
  END AS Age_Group,
  COUNT(*) AS Total_Loans,
  CONCAT('₹ ', ROUND(SUM(LoanAmount) / 1000000, 2), ' M') AS Total_Loan_Amount
FROM bankdata
GROUP BY Age_Group
ORDER BY Age_Group;

