CREATE TABLE public.afritech_data (
  CustomerID           BIGINT,
  CustomerName         TEXT,
  Region               TEXT,
  Age                  INT,
  Income               NUMERIC(12,2),
  CustomerType         TEXT,
  TransactionYear      INT,
  TransactionDate      TEXT,
  ProductPurchased     TEXT,
  PurchaseAmount       NUMERIC(12,2),
  ProductRecalled      BOOLEAN,
  Competitor_x         TEXT,
  InteractionDate      TEXT,
  Platform             TEXT,
  PostType             TEXT,
  EngagementLikes      INT,
  EngagementShares     INT,
  EngagementComments   INT,
  UserFollowers        INT,
  InfluencerScore      NUMERIC(10,2),
  BrandMention         BOOLEAN,
  CompetitorMention    BOOLEAN,
  Sentiment            TEXT,
  CrisisEventTime      TEXT,
  FirstResponseTime    TEXT,
  ResolutionStatus     BOOLEAN,
  NPSResponse          INT
);

SELECT * FROM afritech_data LIMIT 10;

1. Customer & Sales Insights
-- a. Total Sales and Average Purchase per Year

SELECT 
    TransactionYear,
    SUM(PurchaseAmount) AS Total_Sales,
    AVG(PurchaseAmount) AS Avg_Purchase
FROM AfriTech_Data
GROUP BY TransactionYear
ORDER BY TransactionYear;

--b. Top 5 Regions by Total Sales
SELECT 
    Region,
    SUM(PurchaseAmount) AS Total_Sales
FROM AfriTech_Data
GROUP BY Region
ORDER BY Total_Sales DESC
LIMIT 5;

--c. Product Performance (Top Products by Revenue)
SELECT 
    ProductPurchased,
    SUM(PurchaseAmount) AS Total_Revenue
FROM AfriTech_Data
GROUP BY ProductPurchased
ORDER BY Total_Revenue DESC;

--d. Customer Type Contribution to Revenue
SELECT 
    CustomerType,
    COUNT(DISTINCT CustomerID) AS Total_Customers,
    SUM(PurchaseAmount) AS Total_Revenue
FROM AfriTech_Data
GROUP BY CustomerType;

--e. Average Income per Customer Type
SELECT 
    CustomerType,
    AVG(Income) AS Avg_Income
FROM AfriTech_Data
GROUP BY CustomerType;

2. Brand Sentiment & Social Media Engagement

--a. Sentiment Distribution
SELECT 
    Sentiment,
    COUNT(*) AS Total_Posts,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM AfriTech_Data), 2) AS Percent_Share
FROM AfriTech_Data
GROUP BY Sentiment;

--b. Average Engagement per Platform
SELECT 
    Platform,
    AVG(EngagementLikes + EngagementShares + EngagementComments) AS Avg_Engagement
FROM AfriTech_Data
GROUP BY Platform
ORDER BY Avg_Engagement DESC;

--c. Influencer Impact (Average Influencer Score by Platform)
SELECT 
    Platform,
    AVG(InfluencerScore) AS Avg_Influence
FROM AfriTech_Data
GROUP BY Platform
ORDER BY Avg_Influence DESC;


--d. Competitor vs Brand Mentions
SELECT 
    SUM(CASE WHEN BrandMention = TRUE THEN 1 ELSE 0 END) AS Brand_Mentions,
    SUM(CASE WHEN CompetitorMention = TRUE THEN 1 ELSE 0 END) AS Competitor_Mentions
FROM AfriTech_Data;

--e. Sentiment Trend by Year
SELECT 
    TransactionYear,
    Sentiment,
    COUNT(*) AS Total_Posts
FROM AfriTech_Data
GROUP BY TransactionYear, Sentiment
ORDER BY TransactionYear, Sentiment;

3. Customer Complaints & Crisis Management

--a. Number of Crisis Events per Year
SELECT 
    EXTRACT(YEAR FROM TO_DATE(CrisisEventTime, 'MM/DD/YYYY')) AS Crisis_Year,
    COUNT(*) AS Total_Crises
FROM AfriTech_Data
WHERE CrisisEventTime IS NOT NULL
GROUP BY Crisis_Year
ORDER BY Crisis_Year;

--b. Average Crisis Response Time (Days)
SELECT 
    ROUND(AVG(
        (TO_DATE(FirstResponseTime, 'MM/DD/YYYY') - 
         TO_DATE(CrisisEventTime, 'MM/DD/YYYY'))
    ), 2) AS Avg_Response_Time_Days
FROM AfriTech_Data
WHERE CrisisEventTime IS NOT NULL 
  AND FirstResponseTime IS NOT NULL;

--c. Crisis Resolution Rate
SELECT 
    COUNT(CASE WHEN ResolutionStatus = 'True' THEN 1 END) * 100.0 / COUNT(*) AS Resolution_Rate
FROM AfriTech_Data
WHERE CrisisEventTime IS NOT NULL;


--d. NPS (Net Promoter Score) Overview
SELECT 
    ROUND(AVG(NPSResponse), 2) AS Avg_NPS,
    MIN(NPSResponse) AS Min_NPS,
    MAX(NPSResponse) AS Max_NPS
FROM AfriTech_Data;

--e. Crisis vs Sentiment Relationship
SELECT 
    Sentiment,
    COUNT(CrisisEventTime) AS Crisis_Count
FROM AfriTech_Data
GROUP BY Sentiment
ORDER BY Crisis_Count DESC;

SELECT COUNT(*) FROM public.afritech_data;










