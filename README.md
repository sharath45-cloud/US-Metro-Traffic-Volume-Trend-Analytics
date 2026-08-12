# 🚦 Metro Traffic Data Analytics & ETL Pipeline

An end-to-end Data Engineering and SQL Analytics pipeline that processes urban traffic volume datasets, integrates spatial-temporal variables with environmental conditions, and evaluates key drivers of road congestion across hourly, holiday, and weather metrics.

---

## 📌 Executive Summary

Urban traffic infrastructure demands granular analysis to balance congestion mitigation, optimize signal timings, and schedule public transit effectively. This project establishes an automated Python ETL pipeline that extracts raw urban traffic records, standardizes schema headers, programmatically loads data into a PostgreSQL database, and performs high-level SQL analytics to evaluate volume patterns across peak hours, weather conditions, holidays, and multi-year trends.

---

## 🏗️ Architecture & Pipeline Workflow

[ Raw Traffic CSV Data ] -> [ Header Cleaning & Standardization (Pandas) ] -> [ PostgreSQL Ingestion (SQLAlchemy) ] -> [ Relational SQL Analytics & Insights ]

1. Data Extraction: Ingest raw traffic flow records containing timestamps, weather metrics, holiday flags, and traffic volume counts.
2. Data Preprocessing & Cleaning: Convert schema headers to lower_snake_case for PostgreSQL relational compatibility.
3. Automated ETL Database Ingestion: Programmatically load cleaned records into PostgreSQL (traffic_data table) using SQLAlchemy.
4. SQL Business Analytics: Execute targeted PostgreSQL queries to analyze total volume stats, peak rush hours, weather impact, holiday metrics, and temporal growth.

---

## 📊 Data Dictionary

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| holiday | Varchar | Name of the national holiday (if applicable) |
| temp | Float | Temperature recorded in Kelvin |
| rain_1h | Float | Amount of rainfall in mm over the past hour |
| snow_1h | Float | Amount of snowfall in mm over the past hour |
| clouds_all | Integer | Percentage of cloud coverage |
| weather_main | Varchar | Short textual description of general weather (e.g., Rain, Clear) |
| weather_description | Varchar | Detailed weather condition description |
| date_time | Timestamp | Recorded timestamp of traffic observation |
| traffic_volume | Integer | Total vehicle count per hour |
| is_holiday | Varchar | Flag categorizing day as Working Day, Weekend, or National Holiday |
| hour | Varchar / Int | Hour of the day extracted from date_time |
| year | Integer | Year extracted from date_time |
| month | Integer | Month extracted from date_time |

---

## 🧹 Complete Python ETL Pipeline Script (traffic_pipeline.py)

import os
import pandas as pd
from sqlalchemy import create_engine

# Database Connection Parameters
Db_user = 'postgres'
Db_Name = 'postgres'
Db_host = 'localhost'
Db_port = '5432'
Db_password = 'your_password'

CSV_file_path = r'traffic_data_final.csv'

def load_and_clean_data(file_path):
    if not os.path.exists(file_path):
        print(f"[ERROR] Source file not found at: {file_path}")
        return None
    try:
        df = pd.read_csv(file_path)               
        df.columns = df.columns.str.lower()
        print(f"[INFO] Successfully loaded and cleaned {len(df)} rows.")
        return df
    except Exception as e:
        print(f"[ERROR] Failed to read or clean file: {e}")
        return None

def main():
    print("[INFO] Starting Data Pipeline...")
    
    df = load_and_clean_data(CSV_file_path)
    if df is None:
        return
        
    try:
        connection_string = f'postgresql://{Db_user}:{Db_password}@{Db_host}:{Db_port}/{Db_Name}'
        engine = create_engine(connection_string)
        
        print("[INFO] Ingesting data into PostgreSQL...")
        df.columns = df.columns.str.lower().str.replace(' ', '_').str.replace('-', '_')
        df.to_sql('traffic_data', con=engine, if_exists='replace', index=False)
        
        print("[SUCCESS] Data Pipeline executed successfully. Data loaded to pgAdmin.")
        
    except Exception as e:
        print(f"[CRITICAL] Pipeline execution failed: {e}")

if __name__ == "__main__":
    main()

---

## 📈 All SQL Analytics Queries & Outputs (traffic_analysis.sql)

-- 1. Overall Traffic Volume Summary
SELECT
    COUNT(*) AS total_records,
    ROUND(AVG(traffic_volume)::numeric, 2) AS avg_trf_vm,
    MAX(traffic_volume) AS max_trf_vm,
    MIN(traffic_volume) AS min_trf_vm
FROM traffic_data;

/*
Output:
total_records | avg_trf_vm | max_trf_vm | min_trf_vm
--------------+------------+------------+-----------
40255         | 3259.76    | 7280       | 0
*/

-- 2. Peak Traffic Hours Analysis
SELECT 
    hour,
    ROUND(AVG(traffic_volume)::numeric, 2) AS avg_traffic
FROM traffic_data 
GROUP BY hour
ORDER BY avg_traffic DESC;

/*
Top Peak Hours Output:
hour  | avg_traffic
------+------------
16:00 | 5662.93
17:00 | 5328.98
15:00 | 5246.87
14:00 | 4946.54
07:00 | 4730.94
...
03:00 | 371.30 (Lowest)
*/

-- 3. Working Day vs Weekend vs National Holiday Impact
SELECT 
    is_holiday,
    ROUND(AVG(traffic_volume)::numeric, 2) AS avg_traffic
FROM traffic_data 
GROUP BY is_holiday
ORDER BY avg_traffic DESC;

/*
Output:
is_holiday       | avg_traffic
-----------------+------------
Working Day      | 3542.67
Weekend          | 2570.26
National Holiday | 1923.52
*/

-- 4. Impact of Weather Conditions on Traffic
SELECT 
    weather_main,
    COUNT(*) AS total_records,
    ROUND(AVG(traffic_volume)::numeric, 2) AS avg_traffic
FROM traffic_data
GROUP BY weather_main
ORDER BY avg_traffic DESC;

/*
Output:
weather_main | total_records | avg_traffic
-------------+---------------+------------
Haze         | 1088          | 3574.33
Clouds       | 13167         | 3572.05
Rain         | 4680          | 3302.27
Drizzle      | 1543          | 3240.58
Clear        | 11063         | 3069.86
Squall       | 4             | 2061.75
*/

-- 5. Year-Over-Year Traffic Growth
SELECT 
    year,
    ROUND(AVG(traffic_volume)::numeric, 2) AS avg_traffic
FROM traffic_data
GROUP BY year 
ORDER BY year;

/*
Output:
year | avg_traffic
-----+------------
2012 | 3207.80
2013 | 3286.76
2014 | 3250.94
2015 | 3242.90
2016 | 3169.44
2017 | 3340.70
*/

-- 6. Top 5 Holidays with Lowest Traffic Volume
SELECT 
    holiday,
    ROUND(AVG(traffic_volume)::numeric, 2) AS avg_traffic
FROM traffic_data
WHERE is_holiday = 'National Holiday'
GROUP BY holiday
ORDER BY avg_traffic ASC 
LIMIT 5;

/*
Output:
holiday                   | avg_traffic
--------------------------+------------
Martin Luther King Jr Day | 625.33
Washingtons Birthday     | 638.25
State Fair                | 644.50
Labor Day                 | 1033.60
Independence Day          | 1089.75
*/

-- 7. Raining vs No Rain Analysis
SELECT 
    CASE 
        WHEN rain_1h > 0 THEN 'Raining'
        ELSE 'No Rain'
    END AS rain_status,
    COUNT(*) AS total_records,
    ROUND(AVG(traffic_volume)::numeric, 2) AS avg_traffic
FROM traffic_data
GROUP BY 
    CASE 
        WHEN rain_1h > 0 THEN 'Raining'
        ELSE 'No Rain'
    END;

/*
Output:
rain_status | total_records | avg_traffic
------------+---------------+------------
Raining     | 2754          | 3289.28
No Rain     | 37501         | 3257.59
*/

-- 8. Monthly Traffic Patterns
SELECT 
    month,
    COUNT(*) AS total_records,
    ROUND(AVG(traffic_volume)::numeric, 2) AS avg_traffic
FROM traffic_data
GROUP BY month
ORDER BY month ASC;

---

## 🔍 Major Business Insights

| Dimension | Analytical Insight | Strategic Business Application |
| :--- | :--- | :--- |
| **Peak Traffic Hours** | Congestion peaks heavily between **16:00 and 17:00 (Evening Rush Hour)** averaging over 5,300–5,662 vehicles/hr, and at **07:00 (Morning Rush Hour)** averaging 4,730 vehicles/hr. | Optimize traffic signal timings and activate reversible lanes during key rush hours (7 AM & 4–5 PM). |
| **Day Type Impact** | **Working Days** average 3,542 vehicles/hr, whereas **National Holidays** experience a ~45% reduction (1,923 vehicles/hr). | Schedule roadway maintenance and infrastructure repairs on National Holidays or early morning hours (2 AM – 4 AM). |
| **Holiday Drops** | **Martin Luther King Jr Day** and **Washington's Birthday** record the lowest average traffic volume (~625–638 vehicles/hr). | Reduce public transit frequency on major federal holidays to minimize municipal operational costs. |
| **Weather Dependency** | Haze and Clouds show slightly higher volume (~3,572 vehicles/hr) compared to Clear days (~3,069 vehicles/hr), while Raining status records 3,289 vehicles/hr. | Deploy traffic alert messaging and lower speed limits dynamically during adverse weather events (Fog, Squalls). |

---

## 📁 Project Structure

├── traffic_data_final.csv       # Raw metro traffic dataset
├── traffic_pipeline.py          # Python script for ETL & PostgreSQL ingestion
├── traffic_analysis.sql         # SQL analytical queries and performance scripts
└── README.md                     # Project documentation

---

## 🚀 How to Run

### Prerequisites
- Python 3.10+
- PostgreSQL Server & pgAdmin 4
- Required Libraries: pandas, sqlalchemy, psycopg2

### Execution Steps

1. Clone the Repository:
   git clone <your-repository-url>
   cd metro-traffic-pipeline

2. Install Dependencies:
   pip install pandas sqlalchemy psycopg2

3. Execute Data Pipeline:
   python traffic_pipeline.py

4. Run Analytics Queries:
   Execute traffic_analysis.sql in pgAdmin to view aggregated traffic insights.

---

## 📄 License
This project is open-source and released under the MIT License.
