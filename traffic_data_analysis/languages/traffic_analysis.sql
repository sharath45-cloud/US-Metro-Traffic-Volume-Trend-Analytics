select*from traffic_data;

---overall summary
select
count(row) as total_records,
round(avg(traffic_volume ):: numeric,2) as avg_trf_vm,
max(traffic_volume) as max_trf_vm,
min(traffic_volume) as min_trf_vm
from traffic_data;

----Peak Traffic Hours---
select hour,
round(avg(traffic_volume) :: numeric,2) as avg_traffic
from traffic_data 
group by hour
order by avg_traffic desc;

-----working day vs weekend vs national holiday--
select is_holiday,
round(avg(traffic_volume) :: numeric,2) as avg_traffic
from traffic_data 
group by is_holiday
order by avg_traffic desc;

----impact of weather conditions--
select weather_main,
count(*) as total_records,
round(avg(traffic_volume) :: numeric,2) as avg_traffic
from traffic_data
group by weather_main
order by avg_traffic desc;

---year-over-year traffic growth--
select year,
round(avg(traffic_volume) :: numeric,2) as avg_traffic
from traffic_data
group by year 
order by year;

----top 5 holidays with lowest traffic---
select holiday,
round(avg(traffic_volume) :: numeric,2) as avg_traffic
from traffic_data
where is_holiday = 'National Holiday'
group by holiday
order by avg_traffic ASC 
limit 5;


---raining vs no rain analysis--
select  case 
when rain_1h > 0 then 'Raining'
else 'No Rain'
end as rain_status,
count(*) as total_records,
round(avg(traffic_volume)::numeric, 2) as avg_traffic
from traffic_data
group by 
case 
when rain_1h > 0 then 'Raining'
else 'No Rain'
end;


----monthly traffic patterns--
select month,
count(*) as total_records,
round(avg(traffic_volume)::numeric, 2) as avg_traffic
from traffic_data
group by month
order by month asc;