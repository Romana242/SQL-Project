 ===== 2. QUESTION =====
 
----- 1. step: Finding MIN AND MAX Years -----
 
 SELECT 
 	min (price_year),
 	max(price_year)
 FROM data_academy_content.t_romana_strnadova_project_sql_primary_final_2 trspspf ;
 
 
----- 2. step: Finding the proper food names -----
 
 SELECT DISTINCT food_category
 FROM data_academy_content.t_romana_strnadova_project_sql_primary_final_2 trspspf
 ORDER BY food_category;
 
 
----- 3. step: Verification of units of measurement and quantities for the food products in question -----
 
SELECT *
FROM data_academy_content.czechia_price_category
WHERE name IN (
    'Chléb konzumní kmínový',
    'Mléko polotučné pasterované'
);
 
----- 4. step: Calculation of average wages, food prices and  quantities of comodities possible to buy -----
 
 WITH wages AS (
 SELECT
 	price_year,
 	ROUND(AVG(avg_wages)::numeric,0) AS avg_wage
 FROM data_academy_content.t_romana_strnadova_project_sql_primary_final_2 trspspf 
 WHERE price_year IN (2006, 2018)
 GROUP BY price_year
 ),
 food_prices AS (
 	SELECT
 		food_category,
 		price_year,
 		ROUND(AVG(food_price)::NUMERIC,2) AS avg_price
 FROM data_academy_content.t_romana_strnadova_project_sql_primary_final_2 trspspf 
 WHERE food_category IN (
 	'Chléb konzumní kmínový',
 	'Mléko polotučné pasterované'
 )
 AND price_year IN (2006, 2018)
 GROUP BY
 	food_category,
 	price_year
 )
 SELECT
 	fp.food_category,
 	fp.price_year,
 	w.avg_wage,
 	fp.avg_price,
 	ROUND(w.avg_wage / fp.avg_price,0) AS quantity_can_buy
 FROM food_prices fp
 JOIN wages w
 	ON fp.price_year = w.price_year
 ORDER BY
 	fp.food_category,
 	fp.price_year;
 
 
 ----- Data Check: avg_wage x avg_bread_price x avg_milk_price -----

 SELECT
    price_year,
    ROUND(AVG(avg_wages)::numeric,0) AS avg_wage
FROM data_academy_content.t_romana_strnadova_project_sql_primary_final_2
WHERE price_year IN (2006, 2018)
GROUP BY price_year
ORDER BY price_year;

SELECT
    price_year,
    ROUND(AVG(food_price)::numeric,2) AS avg_bread_price
FROM data_academy_content.t_romana_strnadova_project_sql_primary_final_2
WHERE food_category = 'Chléb konzumní kmínový'
AND price_year IN (2006, 2018)
GROUP BY price_year
ORDER BY price_year;

SELECT
    price_year,
    ROUND(AVG(food_price)::numeric,2) AS avg_milk_price
FROM data_academy_content.t_romana_strnadova_project_sql_primary_final_2
WHERE food_category = 'Mléko polotučné pasterované'
AND price_year IN (2006, 2018)
GROUP BY price_year
ORDER BY price_year;


