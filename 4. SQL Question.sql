 ===== 4. QUESTION =====
  
  WITH yearly_data AS (
    SELECT
        price_year,
        AVG(avg_wages) AS avg_wage,
        AVG(food_price) AS avg_price
    FROM data_academy_content.t_romana_strnadova_project_sql_primary_final_2
    GROUP BY price_year
)
SELECT
    price_year,
    ROUND(avg_wage, 0) AS avg_wage,
    ROUND(avg_price::numeric, 2) AS avg_price,
    ROUND(((avg_wage - LAG(avg_wage) OVER (ORDER BY price_year))/
            LAG(avg_wage) OVER (ORDER BY price_year) * 100),2
    ) AS wage_growth_percent,
    ROUND(((avg_price - LAG(avg_price) OVER (ORDER BY price_year))/
            LAG(avg_price) OVER (ORDER BY price_year) * 100)::numeric,2
    ) AS price_growth_percent,
    ROUND((((avg_price - LAG(avg_price) OVER (ORDER BY price_year))/
                LAG(avg_price) OVER (ORDER BY price_year) * 100)
            -
            ((avg_wage - LAG(avg_wage) OVER (ORDER BY price_year))/
                LAG(avg_wage) OVER (ORDER BY price_year) * 100))::numeric,2
    ) AS difference
FROM yearly_data
ORDER BY price_year;



