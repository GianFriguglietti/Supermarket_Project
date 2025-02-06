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
