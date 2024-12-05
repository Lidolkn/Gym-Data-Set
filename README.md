# Gym Members Analysis Dashboard

## Overview
This project analyzes gym member data to uncover insights about workout habits, calorie burns, and churn risks. The Power BI dashboard includes key KPIs, demographics analysis, workout trends, and churn risk visualization.

## Files
- **SQL/**
  - `gym_analysis_create.sql`: Script to create and populate the database.
  - `advanced_queries.sql`: SQL queries used for data analysis.
- **Data/**
  - `gym_members_data.csv`: Raw dataset used for the analysis.


## Key Insights
1. Most popular workout type: Strength.
2. High churn risk observed in occasional gym-goers burning fewer than 500 calories weekly.
3. Recommendations:
   - Promote underutilized workout types.
   - Offer personalized plans for high-risk members.

## How to Run
1. Import `gym_members_data.csv` into the database using the `gym_analysis_create.sql` script.
2. Open `Gym_Members_Analysis.pbix` in Power BI.
3. Explore the visuals to analyze the data.
