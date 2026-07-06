===== DATA CHECK =====


----- 1. Do the columns contain NULL values? -----

SELECT
    COUNT(*) AS row_number,
    COUNT(value) AS value_filled,
    COUNT(*) - COUNT(value) AS value_null,
    COUNT(date_from) AS date_from_filled,
    COUNT(*) - COUNT(date_from) AS date_from_null
FROM data_academy_content.czechia_price;


SELECT
    COUNT(*) AS row_number,
    COUNT(name) AS name_filled,
    COUNT(*) - COUNT(name) AS name_null
FROM data_academy_content.czechia_price_category;


SELECT
    COUNT(*) AS row_number,
    COUNT(value) AS value_filled,
    COUNT(*) - COUNT(value) AS value_null
FROM data_academy_content.czechia_payroll
WHERE value_type_code = 5958;


SELECT
    COUNT(*) AS row_number,
    COUNT(name) AS name_filled,
    COUNT(*) - COUNT(name) AS name_null
FROM data_academy_content.czechia_payroll_industry_branch;


----- 2. Are the prices zero or negative? -----

SELECT
    COUNT(*) AS zero_or_negative_prices
FROM data_academy_content.czechia_price
WHERE value <= 0;


SELECT
    COUNT(*) AS zero_or_negative_values
FROM data_academy_content.czechia_payroll
WHERE value <= 0;



----- 3. What are the minimum and maximum values? -----

SELECT
    MIN(value) AS minimum,
    MAX(value) AS maximum,
    AVG(value) AS average
FROM data_academy_content.czechia_price;


SELECT
    MIN(value) AS minimum,
    MAX(value) AS maximum,
    AVG(value) AS average
FROM data_academy_content.czechia_payroll
WHERE value_type_code = 5958;



----- 4. What period does the table cover? -----

SELECT
    MIN(date_from) AS first_date,
    MAX(date_from) AS last_date
FROM data_academy_content.czechia_price;


SELECT
    MIN(payroll_year) AS first_date,
    MAX(payroll_year) AS last_date
FROM data_academy_content.czechia_payroll;



----- 5. How many records are there for each year? -----

SELECT
    EXTRACT(YEAR FROM date_from) AS year,
    COUNT(*) AS number_of_records
FROM data_academy_content.czechia_price
GROUP BY year
ORDER BY year;


SELECT
    payroll_year AS year,
    COUNT(*) AS number_of_records
FROM data_academy_content.czechia_payroll
GROUP BY year
ORDER BY year;



----- 6. Are there any duplicates? -----

SELECT
    *,
    COUNT(*) AS number
FROM data_academy_content.czechia_price
GROUP BY
    id,
	value,
    category_code,
    date_from,
    date_to,
    region_code
HAVING COUNT(*) > 1;


SELECT
    *,
    COUNT(*) AS number
FROM data_academy_content.czechia_price_category
GROUP BY
    code,
	name,
    price_value,
    price_unit
HAVING COUNT(*) > 1;


SELECT
    *,
    COUNT(*) AS number
FROM data_academy_content.czechia_payroll
WHERE value_type_code = 5958
GROUP BY
    id,
	value,
    industry_branch_code,
    payroll_year,
    payroll_quarter,
    calculation_code,
    unit_code
HAVING COUNT(*) > 1;


SELECT
    *,
    COUNT(*) AS number
FROM data_academy_content.czechia_payroll_industry_branch
GROUP BY
    code,
	name
HAVING COUNT(*) > 1;


