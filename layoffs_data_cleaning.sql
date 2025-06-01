create database world_layoffs;
use world_layoffs;
select * from layoffs;

-- im creating a staging table to keep the raw data from accidental changes or loss of data.
create table layoffs_staging like layoffs;
insert layoffs_staging select * from layoffs;




-- removing duplicates 
select *, row_number() over(partition by company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) 
as row_num from layoffs_staging;

with duplicate_cte as 
(
select *, row_number() over(partition by company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) as 
row_num from layoffs_staging
) 
select * from duplicate_cte where row_num > 1;
select * from layoffs_staging where company = 'Casper'; -- checking one of the duplicate rows company

/* we dont want to remove both rows if duplicates found, we can keep 1 original row. but in cte, we cant 
make permanent changes in tables, so we're creating another staging table*/

-- creating another table
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

insert into layoffs_staging2
select *, row_number() over(partition by company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) as 
row_num from layoffs_staging;

select * from layoffs_staging2;
delete from layoffs_staging2 where row_num > 1;




-- standardizing data in 4 steps
select * from layoffs_staging2;
-- 'step 1, removing unwanted extra spaces inside rows'
select company, trim(company) from layoffs_staging2;
update layoffs_staging2 set company = trim(company);

-- 'step 2, fixing same data with different names'
select distinct industry from layoffs_staging2 order by 1; 
select * from layoffs_staging2 where industry like 'crypto%';
update layoffs_staging2 set industry = 'Crypto' where industry like 'crypto%';

-- 'step 3, fixing datas with unwanted symbols in their names'
select distinct country from layoffs_staging2 order by 1; -- a period '.' found after united states
select * from layoffs_staging2 where country like "united states%";
select distinct country, trim( trailing '.' from country) from layoffs_staging2 order by 1;
update layoffs_staging2 set country = trim( trailing '.' from country) where country like 
"united states%";

-- 'step 4, correcting the datatypes of the columns'
select `date` from layoffs_staging2;
select `date`, str_to_date(`date`, '%m/%d/%Y') from layoffs_staging2; -- capital Y for 4 digit year
update layoffs_staging2 set `date` = str_to_date(`date`, '%m/%d/%Y');
alter table layoffs_staging2 modify `date` date;

-- Handling Null/Blank Values
select * from layoffs_staging2 where industry is null or industry = '';
-- finding industry name of possible companies from other datas available to populate
select * from layoffs_staging2 where company = 'airbnb';
select * from layoffs_staging2 where company like 'Bally%'; -- industry name unavailable
update layoffs_staging2 set industry = null where industry = ''; -- changing blanks to nulls
select t1.industry, t2.industry from layoffs_staging2 t1 join layoffs_staging2 t2 on 
t1.company = t2.company where t1.industry is null and t2.industry is not null;
update layoffs_staging2 t1 join layoffs_staging2 t2 on t1.company = t2.company set 
t1.industry = t2.industry where t1.industry is null and t2.industry is not null;
-- if both total_laid_off and percentage_laid_off is null, then its an useless row

-- Removing Unnecessary Columns/Rows 
select * from layoffs_staging2 where total_laid_off is null and percentage_laid_off is null;
-- but we cant populate for total_laid_off and percentage_laid_off as there's no total so delete it
delete from layoffs_staging2 where total_laid_off is null and percentage_laid_off is null;
alter table layoffs_staging2 drop row_num;

select * from layoffs_staging2;