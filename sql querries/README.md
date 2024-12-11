# SQL Queries Documentation

## Overview
This folder contains SQL scripts used to analyze the gym member exercise data. The goal of these scripts is to preprocess, wrangle, and analyze the dataset to extract actionable insights about workout habits, calorie burns, demographic trends, and membership churn risks. The queries also prepare the data for visualization in a Power BI dashboard.

---

## Workflow: Key Steps and Rationale

### 1. Data Ingestion
- **Action**: Created a database `gym_analysis` and a table `gym_members` to store the dataset.
- **Reason**: Organizing the data into a relational format ensures efficient processing and analysis.

### 2. Data Preprocessing
- **Handling Missing Values**:
  - Checked for missing values in key columns like `Calories_Burned` and `Session_Duration (hours)` using conditional aggregations.
  - **Reason**: Ensures data quality and prevents skewed results in the analysis.
- **Checking Data Consistency**:
  - Verified demographic columns (e.g., `Gender`, `Age`, `BMI`) for proper formatting.
  - **Reason**: Consistency is critical to avoid errors in downstream queries.

### 3. Data Wrangling
- **Derived Metrics**:
  - Created new metrics such as:
    - **Calorie Burn Rate** = `Calories_Burned / Session_Duration (hours)`
    - **Age Group**: Categorized members into bins like `Under 20`, `20-29`, etc.
  - **Reason**: These metrics enhance interpretability and provide deeper insights into member behaviors.
- **Binning Continuous Data**:
  - Grouped `Calories_Burned` into categories (`Low Burn`, `Moderate Burn`, `High Burn`) for visualization.
  - **Reason**: Summarizing continuous data aids in creating dashboard-ready insights.

### 4. Descriptive Statistics
- Calculated key statistics for numeric columns:
  - Mean, Median, Standard Deviation, Min, and Max for `Calories_Burned`.
- **Reason**: These statistics provide a baseline understanding of the data distribution and variability.

### 5. Data Segmentation
- **Experience Level Analysis**:
  - Segmented members by `Experience_Level` to compare metrics like average calories burned and session duration.
  - **Reason**: Helps tailor insights for novice and experienced members.
- **Workout Frequency Segmentation**:
  - Grouped members into categories:
    - `Occasional` (1-2 days/week), `Regular` (3-4 days/week), `Frequent` (5+ days/week).
  - **Reason**: Identifies different commitment levels and workout patterns.

### 6. Churn Prediction
- **Action**:
  - Identified members at risk of churn using:
    ```sql
    CASE WHEN Workout_Frequency <= 2 AND Calories_Burned < 500 THEN 'High Churn Risk'
         ELSE 'Low Churn Risk' END;
    ```
- **Reason**: Provides actionable insights for retaining at-risk members.

### 7. Advanced Analytics
- **Efficiency Analysis**:
  - Identified high-efficiency workouts by calculating:
    ```sql
    AVG(Calories_Burned / Session_Duration (hours));
    ```
  - **Reason**: Helps members optimize their workout routines.
- **Correlation Analysis**:
  - Explored the relationship between `Workout_Frequency` and `Water_Intake (liters)`.
  - **Reason**: Provides insights into how hydration impacts workout behavior.

### 8. Behavioral Analysis
- **Workout Preferences**:
  - Analyzed the popularity of workout types by gender and overall participation.
  - **Reason**: Helps fitness centers understand member preferences.
- **Fat Percentage and Experience**:
  - Examined how fat percentage varies by `Experience_Level`.
  - **Reason**: Highlights progress over time for members at different fitness levels.

### 9. Visualization Preparation
- Categorized metrics like `Calories_Burned` and `Workout_Frequency` into bins for dashboard-ready visualizations.
- Aggregated KPIs for summary dashboards (e.g., average calorie burn and session duration).
- **Reason**: Summarizing data in a structured format ensures easy integration with visualization tools like Power BI.

---

## SQL File Description
- **results sql.sql**:
  - Contains all the queries described above, demonstrating the complete workflow from raw data preprocessing to actionable insights.

---

## Why These Steps Were Chosen
The SQL workflow reflects the following analytical goals:
1. **Data Cleaning**: To ensure the dataset is free from inconsistencies or errors.
2. **Data Wrangling**: To create derived metrics and categories that enhance interpretability.
3. **Segmentation**: To understand member behavior across different groups (e.g., age, experience level).
4. **Churn Prediction**: To identify at-risk members and provide actionable insights.
5. **Advanced Analytics**: To uncover correlations and trends for optimizing gym operations.
6. **Visualization Preparation**: To structure the data for clear, actionable dashboards.

Each step demonstrates a real-world data analysis process, showcasing both technical SQL skills and the ability to derive business-relevant insights.

