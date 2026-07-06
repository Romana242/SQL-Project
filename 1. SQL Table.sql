  
 CREATE TABLE t_romana_strnadova_project_SQL_primary_final_2 AS
 SELECT 
 	cpc.name AS food_category,
 	cp.value AS food_price,
 	cpib.name AS industry_name,
 	cpay.value AS avg_wages,
 	cp.date_from,
 	date_part ('year', cp.date_from) AS price_year
 FROM data_academy_content.czechia_price cp
 JOIN data_academy_content.czechia_payroll cpay
 	ON date_part('year', cp.date_from) = cpay.payroll_year
 	AND cpay.value_type_code = 5958
 	AND cp.region_code IS NULL
 JOIN data_academy_content.czechia_price_category cpc
 	ON cpc.code = cp.category_code
 JOIN data_academy_content.czechia_payroll_industry_branch cpib
 	ON cpib.code = cpay.industry_branch_code;
 
----- Data Check -----
 
 WITH years AS (
    SELECT generate_series(
        (SELECT MIN(price_year)::int FROM data_academy_content.t_romana_strnadova_project_sql_primary_final_2),
        (SELECT MAX(price_year)::int FROM data_academy_content.t_romana_strnadova_project_sql_primary_final_2)) AS price_year
),
foods AS (
    SELECT DISTINCT
        food_category
    FROM data_academy_content.t_romana_strnadova_project_sql_primary_final_2
),
food_years AS (
    SELECT DISTINCT
        food_category,
        price_year
    FROM data_academy_content.t_romana_strnadova_project_sql_primary_final_2
)
SELECT
    f.food_category,
    y.price_year AS missing_year
FROM foods f
CROSS JOIN years y
LEFT JOIN food_years fy
    ON fy.food_category = f.food_category
   AND fy.price_year = y.price_year
WHERE fy.food_category IS NULL
ORDER BY
    f.food_category,
    y.price_year;
 
 