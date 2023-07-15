
/* Creation of the table. */

create table bike_data
(
	ride_id varchar(255) primary key,
	rideable_type varchar(255),
	started_at timestamp,
	ended_at timestamp,
	start_station_name varchar(255),
	start_station_id varchar(255),
	end_station_name varchar(255),
	end_station_id varchar(255),
	start_lat float(10),
	start_lng float(10),
	end_lat float(10),
	end_lng float(10),
	member_casual varchar(50)
);

SELECT * FROM bike_data;

/* Inserting all the data from the 12 CVS files into the bike_data table. */

COPY Public."bike_data" FROM 'C:\Users\Public\Documents\Bike_Share_Company\202201-divvy-tripdata.csv' DELIMITER ',' CSV HEADER;

COPY Public."bike_data" FROM 'C:\Users\Public\Documents\Bike_Share_Company\202202-divvy-tripdata.csv' DELIMITER ',' CSV HEADER;

COPY Public."bike_data" FROM 'C:\Users\Public\Documents\Bike_Share_Company\202203-divvy-tripdata.csv' DELIMITER ',' CSV HEADER;

COPY Public."bike_data" FROM 'C:\Users\Public\Documents\Bike_Share_Company\202204-divvy-tripdata.csv' DELIMITER ',' CSV HEADER;

COPY Public."bike_data" FROM 'C:\Users\Public\Documents\Bike_Share_Company\202205-divvy-tripdata.csv' DELIMITER ',' CSV HEADER;

COPY Public."bike_data" FROM 'C:\Users\Public\Documents\Bike_Share_Company\202206-divvy-tripdata.csv' DELIMITER ',' CSV HEADER;

COPY Public."bike_data" FROM 'C:\Users\Public\Documents\Bike_Share_Company\202207-divvy-tripdata.csv' DELIMITER ',' CSV HEADER;

COPY Public."bike_data" FROM 'C:\Users\Public\Documents\Bike_Share_Company\202208-divvy-tripdata.csv' DELIMITER ',' CSV HEADER;

COPY Public."bike_data" FROM 'C:\Users\Public\Documents\Bike_Share_Company\202209-divvy-publictripdata.csv' DELIMITER ',' CSV HEADER;

COPY Public."bike_data" FROM 'C:\Users\Public\Documents\Bike_Share_Company\202210-divvy-tripdata.csv' DELIMITER ',' CSV HEADER;

COPY Public."bike_data" FROM 'C:\Users\Public\Documents\Bike_Share_Company\202211-divvy-tripdata.csv' DELIMITER ',' CSV HEADER;

COPY Public."bike_data" FROM 'C:\Users\Public\Documents\Bike_Share_Company\202212-divvy-tripdata.csv' DELIMITER ',' CSV HEADER;


insert into bike_data
(ride_id, member_casual)
values (9, 'member');

select * from bike_data 
where ride_id = '9';

select * 
from bike_data
limit 10;

select ride_id, started_at, ended_at,
	round(extract(epoch from (ended_at - started_at))/60) as duration,
	to_char(started_at, 'Month') as month_of_year
from bike_data
where cast(started_at as date) = cast(ended_at as date)
order by duration desc;

/* Calculating number of rides per months*/

select 
	to_char(started_at, 'Month') as month_of_year, 
	count(ride_id), 
	member_casual
from bike_data
where cast(started_at as date) = cast(ended_at as date)
group by month_of_year, member_casual;

/* Calculating number of rides per per week days */

select 
	to_char(started_at, 'Month') as month_of_year,
	to_char(started_at, 'Day') as day_of_week, 
	count(ride_id), 
	member_casual
from bike_data
where cast(started_at as date) = cast(ended_at as date)
group by month_of_year, day_of_week, member_casual;



/* Creating a temporary table */

create temporary table monthly_ride
(
	select ride_id, started_at, ended_at,
	round(extract(epoch from (ended_at - started_at))/60) as duration,
	to_char(started_at, 'Month') as month_of_year
	from bike_data
	where cast(started_at as date) = cast(ended_at as date)
	order by duration desc;
);

/* Request NULLs */

select count(*) 
from bike_data
where start_station_name IS NULL;

select * 
from bike_data
where ride_id IS NULL;

select * 
from bike_data
where start_station_name IS NULL;

select * 
from bike_data
where rideable_type IS NULL;

select * 
from bike_data
where started_at IS NULL;

select * 
from bike_data
where ended_at IS NULL;

/* Calculating the average ride time */

select member_casual, 
	avg(round(extract(epoch from (ended_at - started_at))/60)) as avg_duration_min
from bike_data
group by member_casual
order by avg_duration_min desc;


/*(ended_at - started_at) as ride_duration */

select * 
from bike_data
limit 10;

/* Keeping columns I need */

select ride_id, member_casual as membership_type, rideable_type as bike_type, 
	started_at as started_date, to_char(started_at, 'Day') as start_day, to_char(started_at, 'Month') as start_month,
	ended_at as ended_date, to_char(ended_at, 'Day') as end_day, to_char(ended_at, 'Month') as end_month, 
	round(extract(epoch from (ended_at - started_at))/60) as duration_min
from bike_data
order by duration_min desc;

/* Saving the table as temp table */

/* Saving table as a CSV file */

COPY (select ride_id, member_casual as membership_type, rideable_type as bike_type, 
	started_at as started_date, to_char(started_at, 'Day') as start_day, to_char(started_at, 'Month') as start_month,
	ended_at as ended_date, to_char(ended_at, 'Day') as end_day, to_char(ended_at, 'Month') as end_month, 
	round(extract(epoch from (ended_at - started_at))/60) as duration_min
	from bike_data
	order by duration_min desc)
TO 'C:\Users\Public\Documents\Bike_Share_Company\bike_data_2022_2.csv' DELIMITER ',' CSV HEADER;

