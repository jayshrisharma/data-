CREATE TABLE `lead` (
  `Alyssa has been Notified` text,
  `Auto Convert All Leads From This Company` text,
  `Bio Reactors used` text,
  `Cell Culture Media` text,
  `Cell Type` text,
  `City` text,
  `Companion Lead` text,
  `Converted` text,
  `Converted Account ID` text,
  `Converted Opportunity ID` text,
  `Country` text,
  `Create in Zendesk` text,
  `Created By eContacts` text,
  `Created Date` text,
  `Dead Reason` text,
  `Email Opt Out` text,
  `Google Analytics Campaign` text,
  `Google Analytics Content` text,
  `Google Analytics Medium` text,
  `Google Analytics Source` text,
  `Google Analytics Term` text,
  `Incompatible MS Details` text,
  `Industry` text,
  `isCreatedUpdatedFlag` text,
  `Key Account` text,
  `Last Status Change` text,
  `Last Sync Date` text,
  `Last Sync Status` text,
  `Lead Application` text,
  `Lead ID` text,
  `Lead Source` text,
  `Lead Status at Conversion` text,
  `Lead Status Automation Override` text,
  `Lead Type` text,
  `LeadConSource` text,
  `LeadRecordType` text,
  `Location Text` text,
  `LS Other Research Area` text,
  `LS Research Area` text,
  `LS Team Notified` text,
  `Marketing Segmentation` text,
  `Mass Spec Manufacturer` text,
  `Mass Spec Type` text,
  `Media Provider` text,
  `Needs Score Synced` text,
  `Next_Step__c (Leads)` text,
  `Notes` text,
  `Opted Out of Email` text,
  `Organization` text,
  `Other Application` text,
  `Other Dead Reason` text,
  `Other Mass Spec Type` text,
  `Other Research Area` text,
  `Pardot Conversion Date` text,
  `Pardot Conversion Object Type` text,
  `Pardot Created Date` text,
  `Pardot First Activity` text,
  `Pardot First Referrer Query` text,
  `Pardot First Referrer Type` text,
  `Pardot Grade` text,
  `Pardot Hard Bounced` text,
  `Pardot Last Activity` text,
  `Pardot Last Scored At` text,
  `Pre-Act-on Working Lead` text,
  `Primary Application` text,
  `Product Category` text,
  `Record Type ID` text,
  `Region` text,
  `Research Area` text,
  `Secondary Application` text,
  `Secondary Email` text,
  `SS Team Notified` text,
  `State/Province` text,
  `Status` text,
  `Status (Simplified)` text,
  `Trained` text,
  `Web Form Applications` text,
  `Web Lead Notification Sent` text,
  `Zendesk Result` text,
  `Zendesk User Id` text,
  `Zendesk_OutofSync` text,
  `# Converted Accounts` int DEFAULT NULL,
  `# Converted Opportunities` int DEFAULT NULL,
  `Campaign Membership Count` text,
  `Conversion Rate` text,
  `Lead Score` text,
  `Lead Score1` text,
  `Location (Latitude)` text,
  `Location (Longitude)` text,
  `Number of Records` int DEFAULT NULL,
  `Pardot Score` text,
  `Population Density` text,
   `Total Leads` int DEFAULT NULL,
   Expected_Amount text
);
LOAD DATA LOCAL INFILE 'C:/Users/jayshri/OneDrive/Desktop/First Project/second project/3rd/DA_P939 Dataset/DA_P939 Dataset/Dataset/Lead.csv'
INTO TABLE `Lead`
CHARACTER SET latin1
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;





SELECT COUNT(*) AS Total_Leads FROM `Lead`;


SELECT 
   concat( ROUND(
        SUM(
            CAST(REPLACE(REPLACE(Expected_Amount, '$', ''), ',', '') AS DECIMAL(18,2))
        ) / 1000000, 1  ) ,'M'
    ) AS Expected_Amount_Million
FROM 
    `lead`;


SELECT 
   concat( ROUND(
        (COUNT(CASE WHEN `# Converted Accounts` = '1' THEN 1 END) / COUNT(*)) * 100,
        2),'%'
    ) AS Conversion_Rate_Percent
FROM `Lead`;

SELECT 
    COUNT(`Converted Account ID`) AS Converted_Accounts
FROM `Lead`
WHERE `# Converted Accounts`= '1'
  AND `Converted Account ID` IS NOT NULL;
  
  SELECT 
    COUNT(TRIM(`Converted Opportunity ID`)) AS Converted_Opportunities
FROM `Lead`
WHERE CAST(`# Converted Accounts` AS UNSIGNED) = 1
  AND TRIM(`Converted Opportunity ID`) != '';
  
  SELECT 
    `Lead Source`,
    COUNT(*) AS Total_Leads
FROM `Lead`
GROUP BY `Lead Source`
ORDER BY Total_Leads DESC;


SELECT 
    `Industry`,
    COUNT(*) AS Total_Leads
FROM `Lead`
GROUP BY `Industry`
ORDER BY Total_Leads DESC;

SELECT 
  `Status (Simplified)` ,
    COUNT(*) AS Total_Leads
FROM `Lead`
GROUP BY `Status (Simplified)`
ORDER BY Total_Leads DESC;

