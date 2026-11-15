CREATE SCHEMA IF NOT EXISTS clean;

DROP TABLE IF EXISTS clean.noaa_daily;

CREATE TABLE clean.noaa_daily AS
SELECT
    airport,
    station,
    observation_date AS weather_date,
    MAX(value) FILTER (WHERE datatype = 'PRCP') AS precipitation_mm,
    MAX(value) FILTER (WHERE datatype = 'SNOW') AS snowfall_mm,
    MAX(value) FILTER (WHERE datatype = 'SNWD') AS snow_depth_mm,
    MAX(value) FILTER (WHERE datatype = 'AWND') AS average_wind_mps,
    MAX(value) FILTER (WHERE datatype = 'WSF2') AS fastest_two_minute_wind_mps,
    MAX(value) FILTER (WHERE datatype = 'WSF5') AS fastest_five_second_wind_mps,
    MAX(value) FILTER (WHERE datatype = 'TMAX') AS max_temperature_c,
    MAX(value) FILTER (WHERE datatype = 'TMIN') AS min_temperature_c,
    COALESCE(
        jsonb_object_agg(datatype, value) FILTER (WHERE datatype ~ '^WT[0-9]{2}$'),
        '{}'::jsonb
    ) AS weather_flags
FROM noaa_observations
GROUP BY airport, station, observation_date;

ALTER TABLE clean.noaa_daily ADD PRIMARY KEY (airport, weather_date);
