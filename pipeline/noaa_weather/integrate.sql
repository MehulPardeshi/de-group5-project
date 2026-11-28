CREATE SCHEMA IF NOT EXISTS integrated;

CREATE TABLE IF NOT EXISTS integrated.noaa_daily (
    airport text NOT NULL,
    station text NOT NULL,
    weather_date date NOT NULL,
    precipitation_mm double precision,
    snowfall_mm double precision,
    fastest_five_second_wind_mps double precision,
    weather_flags jsonb NOT NULL,
    rain_threshold_met boolean NOT NULL,
    snow_threshold_met boolean NOT NULL,
    wind_threshold_met boolean NOT NULL,
    selected_weather_flag_present boolean NOT NULL,
    missing_required_measurement boolean NOT NULL,
    source_day_present boolean NOT NULL,
    bad_weather text NOT NULL CHECK (bad_weather IN ('yes', 'no', 'unknown')),
    PRIMARY KEY (airport, weather_date)
);

TRUNCATE integrated.noaa_daily;

INSERT INTO integrated.noaa_daily
WITH calendar AS (
    SELECT d::date AS weather_date
    FROM generate_series(%(start)s::date, %(end)s::date, interval '1 day') d
), airports AS (
    SELECT * FROM jsonb_each_text(%(stations)s::jsonb) AS a(airport, station)
), indicators AS (
    SELECT a.airport, a.station, c.weather_date,
           n.precipitation_mm, n.snowfall_mm, n.fastest_five_second_wind_mps,
           COALESCE(n.weather_flags, '{}'::jsonb) AS weather_flags,
           COALESCE(n.precipitation_mm >= 12.7, false) AS rain_threshold_met,
           COALESCE(n.snowfall_mm >= 25.4, false) AS snow_threshold_met,
           COALESCE(n.fastest_five_second_wind_mps >= 17.9, false) AS wind_threshold_met,
           EXISTS (
               SELECT 1 FROM jsonb_each(COALESCE(n.weather_flags, '{}'::jsonb)) f
               WHERE f.key IN ('WT01', 'WT02', 'WT03', 'WT17', 'WT21', 'WT22')
                 AND f.value = '1'::jsonb
           ) AS selected_weather_flag_present,
           (n.precipitation_mm IS NULL OR n.snowfall_mm IS NULL
            OR n.fastest_five_second_wind_mps IS NULL) AS missing_required_measurement,
           n.airport IS NOT NULL AS source_day_present
    FROM airports a CROSS JOIN calendar c
    LEFT JOIN clean.noaa_daily n
      ON n.airport = a.airport AND n.weather_date = c.weather_date
)
SELECT *, CASE
    WHEN rain_threshold_met OR snow_threshold_met OR wind_threshold_met
         OR selected_weather_flag_present THEN 'yes'
    WHEN missing_required_measurement THEN 'unknown'
    ELSE 'no'
END AS bad_weather
FROM indicators;
