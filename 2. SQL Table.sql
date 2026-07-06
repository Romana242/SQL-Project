CREATE TABLE t_romana_strnadova_project_sql_secondary_final AS
SELECT
    c.country,
    e.year,
    e.gdp,
    e.population,
    e.gini
FROM countries AS c
JOIN economies AS e
    ON c.country = e.country
WHERE c.continent = 'Europe';


----- Data Check - European Countries -----

SELECT DISTINCT country
FROM data_academy_content.t_romana_strnadova_project_sql_secondary_final
ORDER BY country;


