#Data Cleaning using world_layoffs dataset

SELECT * FROM layoffs;

# Creating a staging table where we do all the work and cleaning the data

CREATE TABLE layoffs_staging LIKE layoffs;

SELECT * FROM layoffs_staging;

INSERT layoffs_staging
SELECT * FROM layoffs;

# 1.Remove duplicates




# 2. Standardize data



# 3. Null values or blank values


# 4. Remove any columns


