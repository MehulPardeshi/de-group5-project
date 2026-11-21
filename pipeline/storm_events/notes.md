I am using the NOAA datasets for my part of our flight delay project. 
I downloaded the csv files from the Index of /pub/data/swdi/stormevents/csvfiles/ data page on November 14, 2026, at 20:36 UTC. 
The 2025 csv is around 12 MB and the 2026 csv is around 9 MB. 2025 contains 73,351 rows and 51 columns, while 2026 contains 50,489 rows and 51 columns.
The columns are: BEGIN_YEARMONTH	BEGIN_DAY	BEGIN_TIME	END_YEARMONTH	END_DAY	END_TIME	EPISODE_ID	EVENT_ID	STATE	STATE_FIPS	YEAR	MONTH_NAME	EVENT_TYPE	CZ_TYPE	CZ_FIPS	CZ_NAME	WFO	BEGIN_DATE_TIME	CZ_TIMEZONE	END_DATE_TIME	INJURIES_DIRECT	INJURIES_INDIRECT	DEATHS_DIRECT	DEATHS_INDIRECT	DAMAGE_PROPERTY	DAMAGE_CROPS	SOURCE	MAGNITUDE	MAGNITUDE_TYPE	FLOOD_CAUSE	CATEGORY	TOR_F_SCALE	TOR_LENGTH	TOR_WIDTH	TOR_OTHER_WFO	TOR_OTHER_CZ_STATE	TOR_OTHER_CZ_FIPS	TOR_OTHER_CZ_NAME	BEGIN_RANGE	BEGIN_AZIMUTH	BEGIN_LOCATION	END_RANGE	END_AZIMUTH	END_LOCATION BEGIN_LAT BEGIN_LON END_LAT END_LON EPISODE_NARRATIVE EVENT_NARRATIVE DATA_SOURCE. 
For me, this dataset is important critical weather data over time that can be used for data analysis to understand flight delay patterns.

Source file: https://www.ncei.noaa.gov/pub/data/swdi/stormevents/csvfiles/
