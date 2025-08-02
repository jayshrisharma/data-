-- 1-Total Credit Amount
SELECT concat( ROUND(SUM(Amount) / 1000000, 2) , 'M')AS Total_Credit_in_Millions
FROM `debit and credit banking_data`
WHERE TransactionType = 'Credit';

-- 2-Total Debit Amount
SELECT concat( ROUND(SUM(Amount) / 1000000, 2) , 'M')AS Total_Debit_in_Millions
FROM `debit and credit banking_data`
WHERE TransactionType = 'Debit';

-- 3-Credit to Debit Ratio
SELECT 
    customerid,
    SUM(CASE WHEN transactiontype = 'credit' THEN amount ELSE 0 END) AS total_credit,
    SUM(CASE WHEN transactiontype = 'debit' THEN amount ELSE 0 END) AS total_debit,
    CASE 
        WHEN SUM(CASE WHEN transactiontype = 'debit' THEN amount ELSE 0 END) = 0 THEN NULL
        ELSE ROUND(
            SUM(CASE WHEN transactiontype = 'credit' THEN amount ELSE 0 END) / 
            SUM(CASE WHEN transactiontype = 'debit' THEN amount ELSE 0 END), 2)
    END AS credit_to_debit_ratio
FROM `debit and credit banking_data`
GROUP BY customerid;


-- 4-Net Transaction Amount
SELECT 
    customerid,
    SUM(CASE WHEN transactiontype = 'credit' THEN amount ELSE 0 END) AS total_credit,
    SUM(CASE WHEN transactiontype = 'debit' THEN amount ELSE 0 END) AS total_debit,
    SUM(CASE WHEN transactiontype = 'credit' THEN amount 
             WHEN transactiontype = 'debit' THEN -amount 
             ELSE 0 END) AS net_transaction_amount
FROM `debit and credit banking_data`
GROUP BY customerid;

-- 5-Account Activity Ratio
SELECT 
    customerid,
    COUNT(*) AS total_transactions,
    DATEDIFF(MAX(transactiondate), MIN(transactiondate)) + 1 AS total_days,
    ROUND(COUNT(*) * 1.0 / (DATEDIFF(MAX(transactiondate), MIN(transactiondate)) + 1), 2) AS account_activity_ratio
FROM `debit and credit banking_data`
GROUP BY customerid;

-- 6-Transactions per Day/Week/Month
-- Assume calendar has one row per date
SELECT
    DATE(transactiondate) AS day,
    WEEK(transactiondate, 1) AS week_number,
    DATE_FORMAT(transactiondate, '%Y-%m') AS month,
    customerid,
    COUNT(customerid) AS transaction_count
FROM `debit and credit banking_data`
GROUP BY day, week_number, month, customerid
ORDER BY month, week_number, day;

-- 7-Total Transaction Amount by Branch
SELECT 
    branch,
     concat( round(SUM(Amount) / 1000000, 2) ,'M')AS total_transaction_amount_millions
FROM `debit and credit banking_data`
GROUP BY branch
ORDER BY total_transaction_amount_millions DESC;

-- 8-Transaction Volume by Bank
SELECT 
    BankName,
    COUNT(CustomerID) AS transaction_volume
FROM `debit and credit banking_data`
GROUP BY  BankName
ORDER BY transaction_volume DESC;

-- 9-Transaction Method Distribution
SELECT 
    transactionmethod,
    COUNT(CustomerID) AS transaction_count,
    ROUND(COUNT(CustomerID) * 100.0 / SUM(COUNT(CustomerID)) OVER (), 2) AS percentage
FROM `debit and credit banking_data`
GROUP BY transactionmethod
ORDER BY transaction_count DESC;


-- 10-Branch Transaction Growth
SELECT
    branch,
    DATE_FORMAT(transactiondate, '%Y-%m') AS month,
    COUNT(CustomerID) AS transaction_count
FROM `debit and credit banking_data`
GROUP BY branch, month
ORDER BY branch, month;

-- 11-High-Risk Transaction Flag
SELECT
    CustomerID,
    AccountNumber,
    Amount,
    transactiondate,
    
    CASE
        WHEN Amount > 10000 THEN 'High-Risk'  -- High amount for Credit
        WHEN transactiondate > '2024-08-14' - INTERVAL 1 DAY THEN 'High-Risk'  -- Recent unusual transaction
        ELSE 'Normal'
    END AS transaction_risk_flag,
    
    CASE
        WHEN Amount < 0 THEN 'Debit'  -- Negative amounts represent Debit transactions
        WHEN Amount > 0 THEN 'Credit'  -- Positive amounts represent Credit transactions
        ELSE 'Unknown'
    END AS transaction_type
FROM
    `debit and credit banking_data`
WHERE
    transactiondate >= '2024-08-14' - INTERVAL 30 DAY;

    
  






-- 12-Suspicious Transaction Frequency
SELECT 
    CustomerID,
    COUNT(*) AS flagged_transaction_count,
    DATE(TransactionDate) AS transaction_date,
    CASE 
        WHEN COUNT(*) > 5 AND TIMESTAMPDIFF(HOUR, MIN(TransactionDate), MAX(TransactionDate)) < 1 THEN 'High-Risk'
        ELSE 'Normal'
    END AS transaction_risk_status
FROM `debit and credit banking_data`
WHERE TransactionDate IS NOT NULL
    AND (
        -- High-risk conditions: e.g., amount, timing, method
        Amount > 100000  -- Amount condition (can be adjusted)
        OR HOUR(TransactionDate) BETWEEN 0 AND 4  -- Odd hours condition (midnight to 4 AM)
    )
GROUP BY CustomerID, transaction_date
ORDER BY transaction_date DESC;













