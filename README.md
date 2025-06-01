Global Layoff Data Cleaning & Exploratory Data Analysis (EDA)

Project Overview:
This project analyzes global layoff data using MySQL to uncover key trends and insights. 
The dataset consists of 2,300 rows and includes information on company layoffs, industries, locations, and percentages of workforce reductions. 
The project covers data cleaning, exploratory data analysis (EDA), and insight generation.



Key Features:-

Data Cleaning:
* Removed duplicates using the `ROW_NUMBER()` window function.
* Standardized text fields and cleaned unnecessary spaces and punctuation.
* Converted date strings to proper `DATE` format.
* Replaced blank fields with `NULL` and filled missing industry data using company information.
* Removed rows with insufficient data.

Exploratory Data Analysis:
* Identified top layoffs by companies, industries, locations, and stages.
* Analyzed trends over time, including year-over-year and rolling monthly layoffs.
* Detected outliers exceeding the average layoff count.



Tools Used:-

MySQL: For database management, data cleaning, and executing EDA queries.
GitHub: For project version control and repository management.



Setup Instructions:

1. Clone the repository to your local machine:
2. Import the dataset into MySQL using the provided `.sql` file or `.csv` dataset.
3. Run the SQL queries in the order specified to clean the data and perform EDA.



Files Included:

* `layoffs.csv`: Raw dataset of global layoffs.
* `data_cleaning.sql`: SQL script for cleaning the data.
* `eda_queries.sql`: SQL queries for exploratory data analysis.



Insights Generated:

* Identified industries and locations with the highest layoffs.
* Detected seasonal patterns in layoffs and major events causing workforce reductions.
* Highlighted top companies based on cumulative layoffs and significant outliers.



---

Author: [Santhosh S](https://github.com/santhoshs002)

Contact: For questions or feedback, please reach out via email at `santhoshmail2002@gmail.com`.
