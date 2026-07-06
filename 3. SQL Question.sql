===== 3. QUESTION =====
 
 WITH year_prices AS (
    SELECT
        food_category,
        price_year,
        ROUND(AVG(food_price)::numeric,2) AS avg_price
    FROM data_academy_content.t_romana_strnadova_project_sql_primary_final_2
    GROUP BY
        food_category,
        price_year
),
price_changes AS (
    SELECT
        food_category,
        price_year,
        avg_price,
        LAG(avg_price) OVER (
            PARTITION BY food_category
            ORDER BY price_year
        ) AS prev_avg_price
    FROM year_prices  
)
SELECT
    food_category,
    ROUND(AVG(((avg_price - prev_avg_price) / prev_avg_price) * 100)::numeric,2) AS avg_year_change_percentage
FROM price_changes
WHERE prev_avg_price IS NOT NULL
GROUP BY food_category
ORDER BY avg_year_change_percentage;


----- Data Check -----
 	
----- 1. Time series check for negative commodities -----
 	
 SELECT DISTINCT
    food_category,
    price_year
FROM data_academy_content.t_romana_strnadova_project_sql_primary_final_2
WHERE food_category IN (
    'Cukr krystalový',
    'Rajská jablka červená kulatá'
)
ORDER BY
    food_category,
    price_year;
 	
 
 ----- 2. Determination of the annual average price for negative commodities -----
 
 WITH yearly_prices AS (
    SELECT
        food_category,
        price_year,
        ROUND(AVG(food_price)::numeric,2) AS avg_price
    FROM data_academy_content.t_romana_strnadova_project_sql_primary_final_2
    WHERE food_category IN (
        'Cukr krystalový',
        'Rajská jablka červená kulatá'
    )
    GROUP BY
        food_category,
        price_year
)
SELECT *
FROM yearly_prices
ORDER BY
    food_category,
    price_year;
 
 
 ----- 3. Verification of the number of price records for negative commodities -----
 
 SELECT
    food_category,
    price_year,
    COUNT(*) AS pocet_zaznamu,
    COUNT(food_price) AS pocet_cen
FROM data_academy_content.t_romana_strnadova_project_sql_primary_final_2
WHERE food_category IN (
    'Cukr krystalový',
    'Rajská jablka červená kulatá'
)
GROUP BY
    food_category,
    price_year
ORDER BY
    food_category,
    price_year;
 
 
 ----- 4. Verification of missing prices for negative commodities -----
 
 SELECT
    food_category,
    price_year,
    COUNT(*) AS null_prices
FROM data_academy_content.t_romana_strnadova_project_sql_primary_final_2
WHERE food_category IN (
    'Cukr krystalový',
    'Rajská jablka červená kulatá'
)
AND food_price IS NULL
GROUP BY
    food_category,
    price_year;
 

 ----- 5. Verification of missing prices for all food items -----
 
 SELECT
    food_category,
    price_year,
    COUNT(*) AS null_prices
FROM data_academy_content.t_romana_strnadova_project_sql_primary_final_2
WHERE food_price IS NULL
GROUP BY
    food_category,
    price_year;
 
 