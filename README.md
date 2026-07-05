# SQL Project

## 1. Assignment

The goal of this project was to provide the analytics department of a company focused on the standard of living of citizens with answers to several research questions concerning the availability of basic food products for the general public.

To present the results at an upcoming conference focused on this topic, it was necessary to prepare a robust dataset enabling comparison of food affordability relative to average income over a defined time period.

As a supplementary output, a dataset containing macroeconomic indicators (GDP, GINI coefficient, and population) for selected European countries was also created for the same time period as the primary dataset for the Czech Republic.

---

## 2. Data Preparation

### 2.1 Primary dataset creation

The primary analytical table was designed based on the requirements derived from the research questions. The following source tables were identified as relevant:

- `czechia_price` (columns: `value`, `date_from`)
- `czechia_price_category` (column: `name`)
- `czechia_payroll` (column: `value`)
- `czechia_payroll_industry_branch` (column: `name`)

The tables were combined using SQL `JOIN` operations to ensure that only matching and relevant records were included.

Based on data quality checks, the following findings were identified:

- the `czechia_payroll` table contains two types of values in the `value_type_code` column:
  - 316 = average number of employees
  - 5958 = average gross wage  
  Only records with value 5958 were used for further analysis,
- the time coverage of wages and prices is not fully aligned,
- the `region_code` column in `czechia_price` contains both national and regional data; only aggregated national-level data (`region_code IS NULL`) was used,
- time series analysis revealed that some food categories do not cover the full period 2006–2018 (e.g. “quality white wine”), which limits their use for long-term comparisons.

---

### 2.2 Secondary dataset creation

The secondary dataset was created to provide additional macroeconomic data for European countries.

The `countries` table contains a `continent` column, which was used to filter European countries according to the assignment requirements. The final dataset was created by joining:

- `economies` (columns: `year`, `gdp`, `population`, `gini`)
- `countries` (columns: `country`, `continent`)

A manual validation of the resulting country list was performed to ensure correct classification of European countries and to exclude incorrectly categorized entries.

---

## 3. Research Questions

### 3.1 Wage development over time

**Question:** Do wages increase over time in all industries, or do they decrease in some?

**Methodology:**
1. calculation of average wages per industry and year  
2. application of `LAG()` to retrieve previous year values  
3. calculation of year-over-year differences  

**Conclusion:**
Based on the presence of negative year-over-year values, wages do not increase continuously across all industries. In some industries, temporary declines were observed.

---

### 3.2 Purchasing power (food vs. wages)

**Question:** How many liters of milk and kilograms of bread could be purchased using the average wage in the first and last comparable periods?

**Methodology:**
1. identification of common years for wages and prices (2006 and 2018)
2. verification of food names and units 
3. calculation of average wage across the economy and food prices 
4. calculation of purchasing power ratios  
5. validation of results

**Note:**
For this question, I did not analyze wages at the level of individual industries, as the task focused on overall purchasing power. Therefore, I used the average wage across the entire economy for each year, which better reflects the concept of an average consumer.

**Conclusion:**
- 2006: approximately 1,287 kg of bread or 1,437 liters of milk  
- 2018: approximately 1,342 kg of bread or 1,642 liters of milk  

---

### 3.3 Slowest price growth among food categories

**Question:** Which food category shows the slowest price growth?

**Methodology:**
1. calculation of average annual prices per food category
2. inclusion of previous year values
3. computation of year-over-year percentage changes  
4. calculation of average annual growth rates

**Note:**
Time series validation revealed that some food categories (e.g. “quality white wine”) have incomplete historical coverage, which limits their suitability for long-term comparisons. Additionally, price development was checked to ensure that observed trends were not driven by extreme values but reflect long-term behavior.

**Conclusion:**
The lowest average annual growth rate was observed for bananas (+0.81%). Although some categories showed negative growth (e.g. sugar and tomatoes), the question focused on the lowest growth rate rather than price declines.

---

### 3.4 Difference between wage and price growth

**Question:** Is there a year in which food price growth exceeded wage growth by more than 10 percentage points?

**Methodology:**
1. calculation of year-over-year changes in wages and prices  
2. comparison of both growth rates

**Note:**
The analysis was based on aggregated average food prices and average wages across the economy. Although some categories (e.g. “quality white wine”) have incomplete data coverage, their impact on aggregated results is considered marginal and was not explicitly excluded.

**Conclusion:**
No year exceeded the threshold of a 10 percentage point difference between wage and price growth (maximum observed difference: approx. 7.11 p.p.).

---

### 3.5 Impact of GDP on wages and prices

**Question:** Does GDP growth influence changes in wages and food prices?

**Methodology:**
1. calculation of year-over-year changes in GDP, wages, and prices
2. comparison with previous-year GDP values  
3. comparison of trends across indicators

**Note:**
An additional manual validation was performed by exporting data to CSV format and verifying results using conditional formatting and visual inspection in a spreadsheet tool. This served as an independent check of the SQL outputs.

**Conclusion:**
No clear or consistent relationship between GDP growth and changes in wages or food prices was identified. While some periods show similar trends, the relationship is not stable, suggesting that other economic factors also play a significant role.

---

## 4. Summary

The project shows that the development of food prices and wages over time is neither linear nor directly determined by macroeconomic indicators.

A detailed data quality assessment and time series analysis revealed limitations in the dataset (e.g. incomplete coverage for certain food categories), which were taken into account during interpretation.

These findings were taken into account when interpreting the results and formulating conclusions for individual research questions.
