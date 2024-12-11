-- Create the database and switch to it
CREATE DATABASE gym_analysis;

USE gym_analysis;

-- Create the gym_members table
CREATE TABLE gym_members (
    Age INT,
    Gender VARCHAR(10),
    `Weight (kg)` FLOAT,
    `Height (m)` FLOAT,
    Max_BPM INT,
    Avg_BPM INT,
    Resting_BPM INT,
    `Session_Duration (hours)` FLOAT,
    `Calories_Burned` FLOAT,
    Workout_Type VARCHAR(20),
    Fat_Percentage FLOAT,
    `Water_Intake (liters)` FLOAT,
    `Workout_Frequency (days/week)` INT,
    Experience_Level INT,
    BMI FLOAT
);

SELECT * FROM gym_members LIMIT 10;

-- Check for missing values
SELECT 
    COUNT(*) AS Total_Records,
    SUM(CASE WHEN `Calories_Burned` IS NULL THEN 1 ELSE 0 END) AS Missing_Calories_Burned,
    SUM(CASE WHEN `Session_Duration (hours)` IS NULL THEN 1 ELSE 0 END) AS Missing_Session_Duration
FROM gym_members;

-- Demographic summary: Gender, Age, Weight, and BMI
SELECT 
    Gender, 
    AVG(Age) AS Avg_Age, 
    AVG(`Weight (kg)`) AS Avg_Weight, 
    AVG(BMI) AS Avg_BMI
FROM gym_members
GROUP BY Gender;

-- Age distribution
SELECT 
    CASE 
        WHEN Age < 20 THEN 'Under 20'
        WHEN Age BETWEEN 20 AND 29 THEN '20-29'
        WHEN Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN Age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+'
    END AS Age_Group,
    COUNT(*) AS Member_Count
FROM gym_members
GROUP BY Age_Group;

-- Descriptive statistics for key metrics
SELECT 
    AVG(`Calories_Burned`) AS Avg_Calories_Burned,
    MEDIAN(`Calories_Burned`) AS Median_Calories_Burned,
    STDDEV(`Calories_Burned`) AS StdDev_Calories_Burned,
    MIN(`Calories_Burned`) AS Min_Calories_Burned,
    MAX(`Calories_Burned`) AS Max_Calories_Burned
FROM gym_members;


SELECT COUNT(*) AS Total_Rows FROM gym_members;

SELECT Calories_Burned AS Median_Calories_Burned
FROM gym_members
ORDER BY Calories_Burned
LIMIT 1 OFFSET 4; -- Replace 4 with the calculated offset

SELECT AVG(Calories_Burned) AS Median_Calories_Burned
FROM (
    SELECT Calories_Burned
    FROM gym_members
    ORDER BY Calories_Burned
    LIMIT 2 OFFSET 4 -- Replace 4 with the calculated offset
) AS Median_Table;

-- -- Segment members by experience level
SELECT 
    Experience_Level,
    COUNT(*) AS Member_Count,
    AVG(`Calories_Burned`) AS Avg_Calories_Burned,
    AVG(`Session_Duration (hours)`) AS Avg_Session_Duration
FROM gym_members
GROUP BY Experience_Level
ORDER BY Experience_Level;

-- Segment members by workout frequency
SELECT 
    CASE 
        WHEN `Workout_Frequency (days/week)` <= 2 THEN 'Occasional'
        WHEN `Workout_Frequency (days/week)` BETWEEN 3 AND 4 THEN 'Regular'
        ELSE 'Frequent'
    END AS Frequency_Category,
    COUNT(*) AS Member_Count,
    AVG(`Calories_Burned`) AS Avg_Calories_Burned
FROM gym_members
GROUP BY Frequency_Category;

-- Most popular workout types
SELECT 
    Workout_Type,
    COUNT(*) AS Member_Count
FROM gym_members
GROUP BY Workout_Type
ORDER BY Member_Count DESC;

-- Workout preferences by gender
SELECT 
    Workout_Type,
    Gender,
    COUNT(*) AS Member_Count
FROM gym_members
GROUP BY Workout_Type, Gender
ORDER BY Workout_Type, Member_Count DESC;

-- Calories burned efficiency by workout type
SELECT 
    Workout_Type,
    AVG(`Calories_Burned` / `Session_Duration (hours)`) AS Avg_Calorie_Burn_Rate
FROM gym_members
GROUP BY Workout_Type
ORDER BY Avg_Calorie_Burn_Rate DESC;

-- Rank members by calorie burn within each workout type (Window Function)
WITH Ranked_Calories AS (
    SELECT 
        Gender,
        Workout_Type,
        `Calories_Burned`,
        RANK() OVER (PARTITION BY Workout_Type ORDER BY `Calories_Burned` DESC) AS Rank_By_Calories
    FROM gym_members
)
SELECT * 
FROM Ranked_Calories 
WHERE Rank_By_Calories <= 3;

-- Heart rate analysis by workout type
SELECT 
    Workout_Type,
    AVG(Resting_BPM) AS Avg_Resting_BPM,
    AVG(Max_BPM) AS Avg_Max_BPM
FROM gym_members
GROUP BY Workout_Type;

-- Identify high-efficiency workouts
WITH Avg_Calories AS (
    SELECT 
        Workout_Type, 
        AVG(`Calories_Burned` / `Session_Duration (hours)`) AS Avg_Efficiency
    FROM gym_members
    GROUP BY Workout_Type
)
SELECT * 
FROM Avg_Calories
WHERE Avg_Efficiency > 500;


-- Predict churn risk based on low workout frequency and calorie burn
SELECT 
    CASE 
        WHEN `Workout_Frequency (days/week)` <= 2 AND `Calories_Burned` < 500 THEN 'High Churn Risk'
        ELSE 'Low Churn Risk'
    END AS Churn_Risk,
    COUNT(*) AS Member_Count
FROM gym_members
GROUP BY Churn_Risk;

-- Identify underutilized workout programs
SELECT 
    Workout_Type,
    COUNT(*) AS Members_Count
FROM gym_members
GROUP BY Workout_Type
ORDER BY Members_Count ASC;

-- Suggest high-efficiency workouts for members
WITH High_Efficiency_Workouts AS (
    SELECT 
        Workout_Type,
        AVG(`Calories_Burned` / `Session_Duration (hours)`) AS Calorie_Burn_Rate
    FROM gym_members
    GROUP BY Workout_Type
)
SELECT Workout_Type 
FROM High_Efficiency_Workouts
WHERE Calorie_Burn_Rate > (
    SELECT AVG(`Calories_Burned` / `Session_Duration (hours)`) FROM gym_members
);

-- viz metric ready to read
SELECT 
    CASE
        WHEN Calories_Burned < 500 THEN 'Low Burn (<500)'
        WHEN Calories_Burned BETWEEN 500 AND 1000 THEN 'Moderate Burn (500-1000)'
        ELSE 'High Burn (>1000)'
    END AS Calorie_Burn_Category,
    COUNT(*) AS Member_Count
FROM gym_members
GROUP BY Calorie_Burn_Category;

-- Correlation between water intake and workout frequency:
SELECT 
    `Workout_Frequency (days/week)` AS Workout_Frequency,
    AVG(`Water_Intake (liters)`) AS Avg_Water_Intake
FROM gym_members
GROUP BY `Workout_Frequency (days/week)`;

-- Analyze fat percentage across experience levels
SELECT 
    Experience_Level,
    AVG(Fat_Percentage) AS Avg_Fat_Percentage
FROM gym_members
GROUP BY Experience_Level;


SELECT 
    `Workout_Frequency (days/week)`,
    `Calories_Burned`,
    CASE 
        WHEN `Workout_Frequency (days/week)` >= 3 AND `Calories_Burned` < 500 THEN 'At Risk of Stagnation'
        ELSE 'Consistent Progress'
    END AS Performance_Status
FROM gym_members;


SELECT 
    'Demographics' AS Analysis,
    AVG(Age) AS Avg_Value,
    NULL AS Secondary_Value
FROM gym_members
UNION ALL
SELECT 
    'Calories Burned',
    AVG(`Calories_Burned`),
    NULL
FROM gym_members
UNION ALL
SELECT 
    'Session Duration',
    AVG(`Session_Duration (hours)`),
    NULL
FROM gym_members;

SELECT 
    'Demographics' AS Analysis,
    AVG(Age) AS Avg_Value,
    'N/A' AS Secondary_Value
FROM gym_members
UNION ALL
SELECT 
    'Calories Burned',
    AVG(`Calories_Burned`),
    700 -- Replace with the calculated median
FROM gym_members
UNION ALL
SELECT 
    'Session Duration',
    AVG(`Session_Duration (hours)`),
    'N/A'
FROM gym_members;
