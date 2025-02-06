Select * 
FROM public.marketing_data;

Select * 
FROM public.ad_data;

CREATE TABLE marketing_data (
    ID INT PRIMARY KEY,
    Age INT,
    Age_Bracket VARCHAR(10),
    Education VARCHAR(20),
    Marital_Status VARCHAR(20),
    Income TEXT,
    Kidhome INT,
    Teenhome INT,
    Recency INT,
    AmtLiq INT,
    AmtVege INT,
    AmtNonVeg INT,
    AmtPes INT,
    AmtChocc INT,
    AmtComm INT,
    NumDeals INT,
    NumWebBuy INT,
    NumWalkinPur INT,
    NumVisits INT,
    Response BOOLEAN,
    Complain BOOLEAN,
    Country VARCHAR(3),
    Count_success INT
);

SELECT *
FROM public.marketing_data;

SELECT country,
    SUM(AmtLiq) AS Total_Liquor_Spend,
    SUM(AmtVege) AS Total_Vegetable_Spend,
    SUM(AmtNonVeg) AS Total_Meat_Spend,
    SUM(AmtPes) AS Total_Fish_Spend,
    SUM(AmtChocc) AS Total_Chocolate_Spend,
    SUM(AmtComm) AS Total_Commodities_Spend,
    SUM(AmtLiq + AmtVege + AmtNonVeg + AmtPes + AmtChocc + AmtComm) AS Total_Spend
FROM public.marketing_data
GROUP BY country
ORDER BY total_spend DESC;

SELECT country,
    SUM(AmtLiq) AS Total_Liquor_Spend,
    SUM(AmtVege) AS Total_Vegetable_Spend,
    SUM(AmtNonVeg) AS Total_Meat_Spend,
    SUM(AmtPes) AS Total_Fish_Spend,
    SUM(AmtChocc) AS Total_Chocolate_Spend,
    SUM(AmtComm) AS Total_Commodities_Spend,
    CONCAT('$', SUM(AmtLiq + AmtVege + AmtNonVeg + AmtPes + AmtChocc + AmtComm)) AS Total_Spend
FROM public.marketing_data
GROUP BY country
ORDER BY total_spend DESC;

WITH Total_Spend_Per_Country AS (SELECT Country,
        SUM(AmtLiq) AS Total_Liquor_Spend,
        SUM(AmtVege) AS Total_Vegetable_Spend,
        SUM(AmtNonVeg) AS Total_Meat_Spend,
        SUM(AmtPes) AS Total_Fish_Spend,
        SUM(AmtChocc) AS Total_Chocolate_Spend,
        SUM(AmtComm) AS Total_Commodities_Spend
    FROM marketing_data
    GROUP BY Country
),
Popular_Products AS (
    SELECT
        Country,
        'Liquor' AS Product,
        Total_Liquor_Spend AS Total_Spend
    FROM 
        Total_Spend_Per_Country
    UNION ALL
    SELECT
        Country,
        'Vegetable' AS Product,
        Total_Vegetable_Spend AS Total_Spend
    FROM 
        Total_Spend_Per_Country
    UNION ALL
    SELECT
        Country,
        'Meat' AS Product,
        Total_Meat_Spend AS Total_Spend
    FROM 
        Total_Spend_Per_Country
    UNION ALL
    SELECT
        Country,
        'Fish' AS Product,
        Total_Fish_Spend AS Total_Spend
    FROM 
        Total_Spend_Per_Country
    UNION ALL
    SELECT
        Country,
        'Chocolate' AS Product,
        Total_Chocolate_Spend AS Total_Spend
    FROM 
        Total_Spend_Per_Country
    UNION ALL
    SELECT
        Country,
        'Commodities' AS Product,
        Total_Commodities_Spend AS Total_Spend
    FROM 
        Total_Spend_Per_Country
),
Most_Popular_Products AS (
    SELECT
        Country,
        Product,
        Total_Spend,
        RANK() OVER (PARTITION BY Country ORDER BY Total_Spend DESC) AS Rank
    FROM 
        Popular_Products
)
SELECT
    Country,
    Product AS Most_Popular_Product,
    Total_Spend
FROM 
    Most_Popular_Products
WHERE 
    Rank = 1
ORDER BY Country;

WITH Total_Spend_Per_Country AS 
(SELECT country,
        SUM(AmtLiq) AS Total_Liquor_Spend,
        SUM(AmtVege) AS Total_Vegetable_Spend,
        SUM(AmtNonVeg) AS Total_Meat_Spend,
        SUM(AmtPes) AS Total_Fish_Spend,
        SUM(AmtChocc) AS Total_Chocolate_Spend,
        SUM(AmtComm) AS Total_Commodities_Spend
    FROM public.marketing_data
    GROUP BY country),
Popular_Products AS (
    SELECT 
        country,
        'Liquor' AS Product,
        Total_Liquor_Spend AS Total_Spend
    FROM Total_Spend_Per_Country
    UNION ALL
    SELECT 
        country,
        'Vegetable' AS Product,
        Total_Vegetable_Spend AS Total_Spend
    FROM Total_Spend_Per_Country
    UNION ALL
    SELECT 
        country,
        'Meat' AS Product,
        Total_Meat_Spend AS Total_Spend
    FROM Total_Spend_Per_Country
    UNION ALL
    SELECT 
        country,
        'Fish' AS Product,
        Total_Fish_Spend AS Total_Spend
    FROM Total_Spend_Per_Country
    UNION ALL
    SELECT 
        country,
        'Chocolate' AS Product,
        Total_Chocolate_Spend AS Total_Spend
    FROM Total_Spend_Per_Country
    UNION ALL
    SELECT 
        country,
        'Commodities' AS Product,
        Total_Commodities_Spend AS Total_Spend
    FROM Total_Spend_Per_Country
),
Ranked_Products AS (
    SELECT 
        country,
        product,
        total_spend,
        ROW_NUMBER() OVER (PARTITION BY country ORDER BY total_spend DESC) AS rank
    FROM Popular_Products
)
SELECT 
    country,
    product AS most_popular_product,
    total_spend
FROM 
    Ranked_Products
WHERE 
    rank = 1
ORDER BY 
    country;

SELECT *
FROM public.marketing_data;

SELECT SUM(amtliq)
FROM public.marketing_data;

SELECT country, SUM(amtliq) AS Total_Liquor
FROM public.marketing_data
GROUP BY country
ORDER BY country;

SELECT country, SUM(amtliq) AS Spend_Liquor
FROM public.marketing_data
GROUP BY country
ORDER BY SUM(amtliq) DESC;

WITH Total_Spend_Per_Marital_Status AS (
    SELECT 
        Marital_Status,
        SUM(AmtLiq) AS Total_Liquor_Spend,
        SUM(AmtVege) AS Total_Vegetable_Spend,
        SUM(AmtNonVeg) AS Total_Meat_Spend,
        SUM(AmtPes) AS Total_Fish_Spend,
        SUM(AmtChocc) AS Total_Chocolate_Spend,
        SUM(AmtComm) AS Total_Commodities_Spend
    FROM public.marketing_data
    GROUP BY Marital_Status
),
Spend_Spend AS (
    SELECT 
        Marital_Status,
        'Liquor' AS Product,
        Total_Liquor_Spend AS Total_Spend
    FROM Total_Spend_Per_Marital_Status
    UNION ALL
    SELECT 
        Marital_Status,
        'Vegetable' AS Product,
        Total_Vegetable_Spend AS Total_Spend
    FROM Total_Spend_Per_Marital_Status
    UNION ALL
    SELECT 
        Marital_Status,
        'Meat' AS Product,
        Total_Meat_Spend AS Total_Spend
    FROM Total_Spend_Per_Marital_Status
    UNION ALL
    SELECT 
        Marital_Status,
        'Fish' AS Product,
        Total_Fish_Spend AS Total_Spend
    FROM Total_Spend_Per_Marital_Status
    UNION ALL
    SELECT 
        Marital_Status,
        'Chocolate' AS Product,
        Total_Chocolate_Spend AS Total_Spend
    FROM Total_Spend_Per_Marital_Status
    UNION ALL
    SELECT 
        Marital_Status,
        'Commodities' AS Product,
        Total_Commodities_Spend AS Total_Spend
    FROM Total_Spend_Per_Marital_Status
),
Ranked_Products AS (
    SELECT 
        Marital_Status,
        Product,
        Total_Spend,
        ROW_NUMBER() OVER (PARTITION BY Marital_Status ORDER BY Total_Spend DESC) AS Rank
    FROM Spend_Spend
)
SELECT 
    Marital_Status,
    Product AS Most_Popular_Product,
    Total_Spend
FROM 
    Ranked_Products
WHERE 
    Rank = 1
ORDER BY 
    Marital_Status;

WITH Total_Spend_Per_Household AS (
    SELECT 
        CASE 
            WHEN Kidhome > 0 OR Teenhome > 0 THEN 'With_Children'
            ELSE 'Without_Children'
        END AS Household,
        SUM(AmtLiq) AS TotalLiquor,
        SUM(AmtVege) AS TotalVegetable,
        SUM(AmtNonVeg) AS TotalMeat,
        SUM(AmtPes) AS TotalFish,
        SUM(AmtChocc) AS TotalChocolate,
        SUM(AmtComm) AS TotalCommodities
    FROM public.marketing_data
    GROUP BY 
        CASE 
            WHEN Kidhome > 0 OR Teenhome > 0 THEN 'With_Children'
            ELSE 'Without_Children'
        END
),
Spend_Summary AS (
    SELECT 
        Household,
        'Liquor' AS Product,
        TotalLiquor AS Total_Spend
    FROM Total_Spend_Per_Household
    UNION ALL
    SELECT 
        Household,
        'Vegetable' AS Product,
        TotalVegetable AS Total_Spend
    FROM Total_Spend_Per_Household
    UNION ALL
    SELECT 
        Household,
        'Meat' AS Product,
        TotalMeat AS Total_Spend
    FROM Total_Spend_Per_Household
    UNION ALL
    SELECT 
        Household,
        'Fish' AS Product,
        TotalFish AS Total_Spend
    FROM Total_Spend_Per_Household
    UNION ALL
    SELECT 
        Household,
        'Chocolate' AS Product,
        TotalChocolate AS Total_Spend
    FROM Total_Spend_Per_Household
    UNION ALL
    SELECT 
        Household,
        'Commodities' AS Product,
        TotalCommodities AS Total_Spend
    FROM Total_Spend_Per_Household
),
Ranked_Products AS (
    SELECT 
        Household,
        Product,
        Total_Spend,
        ROW_NUMBER() OVER (PARTITION BY Household ORDER BY Total_Spend DESC) AS Rank
    FROM Spend_Summary
)
SELECT 
    Household,
    Product AS Most_Popular_Product,
    Total_Spend
FROM 
    Ranked_Products
WHERE 
    Rank = 1
ORDER BY 
    Household;


SELECT 
    m.Country, 
    SUM(CASE WHEN a.Twitter_ad THEN 1 ELSE 0 END) AS Twitter_Leads, 
    SUM(CASE WHEN a.Instagram_ad THEN 1 ELSE 0 END) AS Instagram_Leads, 
    SUM(CASE WHEN a.Facebook_ad THEN 1 ELSE 0 END) AS Facebook_Leads,
    CASE 
        WHEN SUM(CASE WHEN a.Twitter_ad THEN 1 ELSE 0 END) >= SUM(CASE WHEN a.Instagram_ad THEN 1 ELSE 0 END) AND 
             SUM(CASE WHEN a.Twitter_ad THEN 1 ELSE 0 END) >= SUM(CASE WHEN a.Facebook_ad THEN 1 ELSE 0 END) THEN 'Twitter'
        WHEN SUM(CASE WHEN a.Instagram_ad THEN 1 ELSE 0 END) >= SUM(CASE WHEN a.Facebook_ad THEN 1 ELSE 0 END) THEN 'Instagram'
        ELSE 'Facebook'
    END AS Most_Effective_Platform
FROM 
    marketing_data m
JOIN 
    ad_data a ON m.ID = a.ID
GROUP BY 
    m.Country
ORDER BY 
    m.Country;


WITH AdConversions AS (
    SELECT 
        m.Country,
        SUM(CASE WHEN a.Twitter_ad THEN 1 ELSE 0 END) + 
        SUM(CASE WHEN a.Instagram_ad THEN 1 ELSE 0 END) + 
        SUM(CASE WHEN a.Facebook_ad THEN 1 ELSE 0 END) AS Total_Conversions
    FROM 
        marketing_data m
    JOIN 
        ad_data a ON m.ID = a.ID
    GROUP BY 
        m.Country
),
Spending AS (
    SELECT 
        Country,
        SUM(AmtLiq + AmtVege + AmtNonVeg + AmtPes + AmtChocc + AmtComm) AS Total_Spending
    FROM 
        marketing_data
    GROUP BY 
        Country
)
SELECT 
    s.Country,
    s.Total_Spending,
    ac.Total_Conversions
FROM 
    Spending s
JOIN 
    AdConversions ac ON s.Country = ac.Country
ORDER BY 
    s.Country;


/*
*/
SELECT 
    m.Marital_Status, 
    SUM(CASE WHEN a.Twitter_ad THEN 1 ELSE 0 END) AS Twitter_Conversions, 
    SUM(CASE WHEN a.Instagram_ad THEN 1 ELSE 0 END) AS Instagram_Conversions, 
    SUM(CASE WHEN a.Facebook_ad THEN 1 ELSE 0 END) AS Facebook_Conversions,
    CASE 
        WHEN SUM(CASE WHEN a.Twitter_ad THEN 1 ELSE 0 END) >= SUM(CASE WHEN a.Instagram_ad THEN 1 ELSE 0 END) AND 
             SUM(CASE WHEN a.Twitter_ad THEN 1 ELSE 0 END) >= SUM(CASE WHEN a.Facebook_ad THEN 1 ELSE 0 END) THEN 'Twitter'
        WHEN SUM(CASE WHEN a.Instagram_ad THEN 1 ELSE 0 END) >= SUM(CASE WHEN a.Facebook_ad THEN 1 ELSE 0 END) THEN 'Instagram'
        ELSE 'Facebook'
    END AS Most_Effective_Platform
FROM 
    marketing_data m
JOIN 
    ad_data a ON m.ID = a.ID
GROUP BY 
    m.Marital_Status
ORDER BY 
    m.Marital_Status;
