<img width="391" height="275" alt="Screenshot 2026-08-09 084529" src="https://github.com/user-attachments/assets/193bfb24-1e31-4f51-bffd-811d1ca5bc28" /># 🚗 US Metro Traffic Volume & Trend Analytics

An end-to-end **Power BI** data visualization and analytics project designed to evaluate traffic patterns, analyze peak commute hours, and uncover environmental impacts using urban interstate traffic datasets.

---

## 📁 Dashboard Access & Download
> 💡 **How to download:** Click the link below to open the Power BI file page, then click the **Download** button on GitHub.
> 
> 📥 [Click Here to Download Power BI File (.pbix)](r'C:\Users\shara\Downloads\traffic_analysis1.pbix')
---

## 🖼️ Dashboard Preview & Screenshots

### Page 1: Weather & Environmental Impact
![Page 1](<img width="391" height="275" alt="Screenshot 2026-08-09 084529" src="https://github.com/user-attachments/assets/8b7af6f4-ebe4-4e8b-b55e-0c1edaaf4e1e" />)

### Page 2: Year-over-Year Growth
![Page 2](<img width="388" height="283" alt="Screenshot 2026-08-09 084516" src="https://github.com/user-attachments/assets/61d84c3d-8c1c-4177-becf-d7399a19519c" />)

### Page 3: 24-Hour Peak Trends
![Page 3](<img width="387" height="278" alt="Screenshot 2026-08-09 084454" src="https://github.com/user-attachments/assets/9fd9a905-8a49-4220-ad0e-fca6fe82ac5f" />)
---

## 📊 Business & Urban Mobility Problem
The primary objective of this project is to evaluate traffic flow dynamics across key operational parameters:
1. **Period (Peak Hours & Day Types):** Identifying high-density rush hours vs. low-density periods across Working Days, Weekends, and Holidays.
2. **Environment (Weather Conditions):** Understanding how precipitation, temperature, and atmospheric visibility impact traffic volume.
3. **Trends (Historical Growth):** Analyzing year-over-year traffic volume changes to detect urban mobility patterns.

---

## 🎯 Key Features & Dashboard Pages

### Page 1: Weather & Environmental Impact on Traffic Volume
* **KPI Cards:** Total Traffic Volume, Average Hourly Traffic, Total Records, and Peak Metrics at a glance.
* **Weather Impact Bar Chart:** Horizontal bar chart highlighting total traffic volume across different weather conditions (Clouds, Clear, Rain, etc.).
* **Interactive Year Slicer:** Button-style dynamic filtering for deep-dive yearly weather analysis.

### Page 2: Year-over-Year Traffic Growth & Day-Type Distribution
* **Yearly Breakdown (Stacked Column Chart):** Distribution of traffic volume categorized across Working Days, Weekends, and National Holidays (2012–2017).
* **Holiday Traffic Comparison:** Visualizing traffic reduction during major public holidays.

### Page 3: 24-Hour Peak Traffic Trends & Holiday Analysis
* **24-Hour Peak Trend (Line Chart):** Visualizing hourly traffic trajectories to identify morning and evening rush-hour spikes.
* **Interactive Holiday Slicers:** Granular selection for individual holidays (Christmas, Thanksgiving, New Year's Day, etc.) to examine holiday commute behavior.

---

## 🗄️ Core SQL Analytics
Includes PostgreSQL / MySQL queries for data aggregation and validation:

```sql
-- 1. Overall Traffic Volume Summary
select 
    count(row) as total_records,
    round(avg(traffic_volume)::numeric, 2) as avg_traffic_volume,
    max(traffic_volume) as max_traffic_volume,
    min(traffic_volume) as min_traffic_volume
from traffic_data;

-- 2. Peak Traffic Hours Analysis
select 
    hour,
    round(avg(traffic_volume)::numeric, 2) as avg_traffic
from traffic_data
group by hour
order by avg_traffic desc;
