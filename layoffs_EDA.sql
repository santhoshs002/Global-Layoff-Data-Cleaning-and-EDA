-- checking everything in the data looks right
SELECT * FROM world_layoffs.layoffs_staging2;

-- finding best and worst numbers
-- I)finding the largest layoff count
SELECT MAX(total_laid_off) FROM world_layoffs.layoffs_staging2;
-- II)finding the highest and lowest layoff percent while ignoring the missing data.
SELECT MAX(percentage_laid_off), MIN(percentage_laid_off) FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off IS NOT NULL;

-- companies with 100%(everyone) layoffs
SELECT * FROM layoffs_staging2 WHERE percentage_laid_off = 1;
SELECT * FROM layoffs_staging2 WHERE percentage_laid_off = 1 ORDER BY total_laid_off DESC;	
SELECT * FROM layoffs_staging2 WHERE percentage_laid_off = 1 ORDER BY funds_raised_millions DESC;

-- top items by size
-- I) five biggest one-row layoffs
SELECT company, total_laid_off FROM layoffs_staging2 ORDER BY total_laid_off DESC LIMIT 5;
-- II)top ten by adding each company’s layoffs 
SELECT company, SUM(total_laid_off) FROM layoffs_staging2 GROUP BY company 
ORDER BY 2 DESC LIMIT 10;

-- layoff dataset's start date to end date
SELECT MIN(`date`), MAX(`date`) from layoffs_staging2; -- layoffs during covid pandemic (3 years)

-- Groups sums - total layoffs for that category, sorted biggest first
SELECT location, SUM(total_laid_off) FROM layoffs_staging2 GROUP BY location ORDER BY 2 DESC LIMIT 10;
SELECT country, SUM(total_laid_off) FROM layoffs_staging2 GROUP BY country ORDER BY 2 DESC;
SELECT industry, SUM(total_laid_off) FROM layoffs_staging2 GROUP BY industry ORDER BY 2 DESC;
SELECT stage, SUM(total_laid_off) FROM layoffs_staging2 GROUP BY stage ORDER BY 2 DESC;

-- trends over time
-- I) each date
SELECT `date`, SUM(total_laid_off) FROM layoffs_staging2 GROUP BY `date` ORDER BY 2 DESC;
SELECT `date`, SUM(total_laid_off) FROM layoffs_staging2 GROUP BY `date` ORDER BY 1 DESC; -- recent order
-- II) each year
SELECT YEAR(`date`), SUM(total_laid_off) FROM layoffs_staging2 GROUP BY 1 ORDER BY 1 DESC;
-- III) top 3 companies each year
WITH C AS (SELECT company, YEAR(date) AS yr, SUM(total_laid_off) AS tot FROM layoffs_staging2
GROUP BY company, yr), 
R AS (SELECT company, yr, tot, DENSE_RANK() OVER (PARTITION BY yr ORDER BY tot DESC) AS rnk FROM C)
SELECT company, yr, tot FROM R WHERE rnk <= 3 ORDER BY yr, tot DESC;

-- Running total by month
WITH DATE_CTE AS (SELECT SUBSTRING(date,1,7) as months, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2 where SUBSTRING(date,1,7) IS NOT NULL GROUP BY months ORDER BY months ASC)
SELECT months, total_laid_off, SUM(total_laid_off) OVER (ORDER BY months ASC) as rolling_total_layoffs
FROM DATE_CTE ORDER BY months ASC;

-- companies where the layoffs are greater than the average
SELECT company, total_laid_off FROM layoffs_staging2 
WHERE total_laid_off > (SELECT AVG(total_laid_off) FROM layoffs_staging2);

-- counts how many blank (NULL) entries
SELECT SUM(CASE WHEN total_laid_off IS NULL THEN 1 ELSE 0 END) AS missing_laid_off,
SUM(CASE WHEN percentage_laid_off IS NULL THEN 1 ELSE 0 END) AS missing_percent,
SUM(CASE WHEN industry IS NULL THEN 1 ELSE 0 END) AS missing_industry
FROM layoffs_staging2;