-- Data Cleaning using world_layoffs dataset

SELECT * FROM layoffs;

# Creating a staging table where we do all the work and cleaning the data

CREATE TABLE layoffs_staging LIKE layoffs;

SELECT * FROM layoffs_staging;

INSERT INTO layoffs_staging
SELECT * FROM layoffs;

-- 1.Remove duplicates

# Checking for duplicates
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

# Creating a CTE 
WITH duplicate_cte AS
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num>1;

# Creating a table layoffs_staging2 with row_num as a new column to delete the duplicate rows

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
   `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging2
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT * FROM layoffs_staging2 WHERE row_num>1;

# To delete the duplicates
DELETE FROM layoffs_staging2 WHERE row_num>1;

SELECT * FROM layoffs_staging2;



-- 2. Standardize data

# To trim the spaces

SELECT company, TRIM(company) FROM layoffs_staging2;

UPDATE layoffs_staging2 
SET company= TRIM(company);

SELECT * FROM layoffs_staging2;

# Updating Crypto, CryptoCurrency and Crypto Currency as Crypto

SELECT DISTINCT industry FROM layoffs_staging2 ORDER BY 1;

SELECT * FROM layoffs_staging2 WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry='Crypto'
WHERE industry LIKE 'Crypto%';

# Updating country United States and United States. as United States

SELECT DISTINCT country FROM layoffs_staging2 ORDER BY 1;

SELECT * FROM layoffs_staging2 WHERE country LIKE 'United States%';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2 ORDER BY 1;

UPDATE layoffs_staging2
SET country= TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

# Update column 'date' from text to date

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date` FROM layoffs_staging2;

# Altering the datatype of the 'date' column from text to date

ALTER TABLE layoffs_staging2 MODIFY COLUMN `date` DATE;

SELECT * FROM layoffs_staging2;


-- 3. Null values or blank values

SELECT * FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_staging2 WHERE industry IS NULL OR industry='';

SELECT * FROM layoffs_staging2 WHERE company LIKE 'Bally%';

# To populate with values in the blank 'industry' column if the company and location are same values, use self join

SELECT t1.industry, t2.industry FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company=t2.company
WHERE (t1.industry IS NULL OR t1.industry='')
AND t2.industry IS NOT NULL;

# Update with values

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company=t2.company
SET t1.industry=t2.industry
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL;

# To update blank values with NULL values

UPDATE layoffs_staging2 SET industry=NULL WHERE industry='';

SELECT * FROM layoffs_staging2;


-- 4. Drop columns and Deleting rows

# Deleting rows where total_laid_off is null and %_laid_off is also null since that might indicate that layoffs couldn't have taken place in that company

SELECT * FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

DELETE FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_staging2;

# Dropping column row_num 

ALTER TABLE layoffs_staging2
DROP column row_num;

SELECT * FROM layoffs_staging2;



