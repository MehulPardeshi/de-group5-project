CREATE SCHEMA IF NOT EXISTS clean;

CREATE TABLE IF NOT EXISTS clean.noaa_daily (
    airport text NOT NULL,
    station text,
    weather_date date NOT NULL,
    precipitation_mm double precision,
    snowfall_mm double precision,
    snow_depth_mm double precision,
    average_wind_mps double precision,
    fastest_two_minute_wind_mps double precision,
    fastest_five_second_wind_mps double precision,
    max_temperature_c double precision,
    min_temperature_c double precision,
    weather_flags jsonb,
    PRIMARY KEY (airport, weather_date)
);

-- Keep the table identity so downstream views survive a rebuild.
DELETE FROM clean.noaa_daily;

INSERT INTO clean.noaa_daily
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
