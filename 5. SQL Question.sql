 ===== 5. QUESTION =====
 
WITH wages AS (
    SELECT
        price_year,
        ROUND(AVG(avg_wages)::numeric, 0) AS avg_wage
    FROM data_academy_content.t_romana_strnadova_project_sql_primary_final_2
    GROUP BY price_year
),
wages_growth AS (
    SELECT
        price_year,
        avg_wage,
        LAG(avg_wage) OVER (ORDER BY price_year) AS previous_wage
    FROM wages
),
prices AS (
    SELECT
        price_year,
        ROUND(AVG(food_price)::numeric, 2) AS avg_price
    FROM data_academy_content.t_romana_strnadova_project_sql_primary_final_2
    GROUP BY price_year
),
prices_growth AS (
    SELECT
        price_year,
        avg_price,
        LAG(avg_price) OVER (ORDER BY price_year) AS previous_price
    FROM prices
),
gdp AS (
    SELECT
        year,
        ROUND(gdp::numeric, 0) AS gdp
    FROM data_academy_content.t_romana_strnadova_project_sql_secondary_final
    WHERE country = 'Czech Republic'
),
gdp_growth AS (
    SELECT
        year,
        gdp,
        LAG(gdp) OVER (ORDER BY year) AS previous_gdp
    FROM gdp
)
SELECT
    g.year,
    g.gdp,
    ROUND(((g.gdp - g.previous_gdp)/ g.previous_gdp * 100),2
    ) AS gdp_growth_percent,
    LAG(ROUND(((g.gdp - g.previous_gdp)/ g.previous_gdp * 100)::numeric,2)) OVER (ORDER BY g.year) AS previous_gdp_growth_percent,
    w.avg_wage,
    ROUND(((w.avg_wage - w.previous_wage)/ w.previous_wage * 100),2
    ) AS wage_growth_percent,
    p.avg_price,
    ROUND(((p.avg_price - p.previous_price)/ p.previous_price * 100),2
    ) AS price_growth_percent
FROM gdp_growth g
JOIN wages_growth w
    ON g.year = w.price_year
JOIN prices_growth p
    ON g.year = p.price_year
ORDER BY g.year;