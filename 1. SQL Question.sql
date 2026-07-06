 ===== 1. QUESTION =====
 
  WITH wages AS (
 	SELECT 
 		industry_name,
 		price_year,
 		ROUND(AVG(avg_wages),0) AS avg_wage
 	FROM data_academy_content.t_romana_strnadova_project_sql_primary_final_2 trspspf 
 	GROUP BY 
 		industry_name,
 		price_year
 )
 SELECT 
 	industry_name,
 	price_year,
 	avg_wage,
 	LAG(avg_wage) OVER (
 		PARTITION BY industry_name
 		ORDER BY price_year
 	) AS previous_year_wage,
 	avg_wage - 
 	LAG(avg_wage) OVER (
 	PARTITION BY industry_name
 	ORDER BY price_year
 	) AS wage_difference
 FROM wages
 ORDER BY 
 	industry_name,
 	price_year;
 
 