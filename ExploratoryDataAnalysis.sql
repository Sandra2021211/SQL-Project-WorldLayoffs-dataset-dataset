-- Exploratory Data Analysis

SELECT * FROM layoffs_staging2;

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

#Maximum layoff % per company

SELECT company, MAX(percentage_laid_off) AS max_laid_off
FROM layoffs_staging2
GROUP BY company ORDER BY 2 DESC;

#Filter for companies with 100% layoffs

SELECT company, `date` FROM layoffs_staging2 WHERE percentage_laid_off=1;

#Overview of the companies that had the highest layoffs and how severe was it

SELECT company, SUM(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


