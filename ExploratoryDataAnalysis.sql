-- Exploratory Data Analysis

SELECT * FROM layoffs_staging2;

#Null value and Data Quality checks 

SELECT COUNT(*) AS total_rows,
SUM(total_laid_off IS NULL) AS null_laid_off, SUM(percentage_laid_off IS NULL) AS null_percent,
SUM(`date` IS NULL) AS null_date
FROM layoffs_staging2;

# to find out maximum employees laid off and max % of employees laid off

SELECT MAX(total_laid_off), MAX(percentage_laid_off) FROM layoffs_staging2;

# to find out the companies where all the employees were laid off which means the company went under

SELECT * FROM layoffs_staging2 WHERE percentage_laid_off=1 ORDER BY total_laid_off DESC;

SELECT * FROM layoffs_staging2 WHERE percentage_laid_off=1 ORDER BY funds_raised_millions DESC;

#Top companies by layoffs

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company ORDER BY 2 DESC;

# to find out the starting and ending date of the layoff period

SELECT MIN(`date`), MAX(`date`) FROM layoffs_staging2;

#Top industries by layoff

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry ORDER BY 2 DESC;

#Top countries by layoff

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country ORDER BY 2 DESC;

#Top years by layoff

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`) ORDER BY 1 DESC;

#Top stage by layoffs

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage ORDER BY 2 DESC;

#Maximum layoff % per company - layoff rate analysis

SELECT company, MAX(percentage_laid_off) AS max_laid_off
FROM layoffs_staging2
WHERE percentage_laid_off IS NOT NULL
GROUP BY company ORDER BY 2 DESC;

#Filter for companies with 100% layoffs

SELECT company, `date` FROM layoffs_staging2 WHERE percentage_laid_off=1;

#Overview of the companies that had the highest layoffs and how severe was it

SELECT company, SUM(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

# Layoffs over time(trend)

SELECT YEAR(`date`), MONTH(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`), MONTH(`date`)
ORDER BY 1,2;

SELECT * FROM layoffs_staging2;

# Rolling sum

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_total;

# to rank the year that has the highest layoffs

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

With Company_Year(company, years, total_laid_off) AS     # first CTE to get the people laid off grouping by company and years
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS      # second CTE to filter based on the rank
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY Ranking
)
SELECT * FROM Company_Year_Rank
WHERE Ranking<=5;

