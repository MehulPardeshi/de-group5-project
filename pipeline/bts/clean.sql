-- Build clean.bts_flights from raw.bts_on_time: typed columns, one row per flight.
-- Run: docker compose exec -T postgres psql -U de -d de_group5 < pipeline/bts/clean.sql
-- Rebuilt from scratch every run, so it is safe to re-run.
--
-- What changes from raw:
--   * Text becomes dates, times, integers and booleans. Values that don't parse become NULL.
--   * Blank text ('' or NULL) becomes NULL.
--   * "2400" (how BTS writes midnight) becomes 00:00.
--   * Cancellation codes get a readable reason (A carrier, B weather, C NAS, D security).
--   * Duplicate flights are removed, keeping the most recently loaded copy.
--   * Columns we don't need (Div1-Div5 details, delay groups, IDs we don't join on) are left out.
--     They stay in raw if we need them later.

DROP TABLE IF EXISTS clean.bts_flights;

CREATE TABLE clean.bts_flights AS
WITH typed AS (
    SELECT
        flightdate::DATE AS flight_date,
        dayofweek::SMALLINT AS day_of_week,
        NULLIF(BTRIM(reporting_airline), '') AS airline,
        NULLIF(BTRIM(tail_number), '') AS tail_number,
        NULLIF(BTRIM(flight_number_reporting_airline), '') AS flight_number,
        originairportid::INTEGER AS origin_airport_id,
        NULLIF(BTRIM(origin), '') AS origin,
        NULLIF(BTRIM(origincityname), '') AS origin_city,
        NULLIF(BTRIM(originstate), '') AS origin_state,
        destairportid::INTEGER AS dest_airport_id,
        NULLIF(BTRIM(dest), '') AS dest,
        NULLIF(BTRIM(destcityname), '') AS dest_city,
        NULLIF(BTRIM(deststate), '') AS dest_state,

        -- HHMM text to TIME. "2400" means midnight; anything else invalid becomes NULL.
        CASE WHEN crsdeptime = '2400' THEN TIME '00:00'
             WHEN crsdeptime ~ '^([01]\d|2[0-3])[0-5]\d$'
             THEN MAKE_TIME(LEFT(crsdeptime, 2)::INT, RIGHT(crsdeptime, 2)::INT, 0) END AS crs_dep_time,
        CASE WHEN deptime = '2400' THEN TIME '00:00'
             WHEN deptime ~ '^([01]\d|2[0-3])[0-5]\d$'
             THEN MAKE_TIME(LEFT(deptime, 2)::INT, RIGHT(deptime, 2)::INT, 0) END AS dep_time,
        ROUND(depdelay::NUMERIC)::INTEGER AS dep_delay,
        (depdel15::NUMERIC = 1) AS dep_del15,
        ROUND(taxiout::NUMERIC)::INTEGER AS taxi_out,
        ROUND(taxiin::NUMERIC)::INTEGER AS taxi_in,
        CASE WHEN crsarrtime = '2400' THEN TIME '00:00'
             WHEN crsarrtime ~ '^([01]\d|2[0-3])[0-5]\d$'
             THEN MAKE_TIME(LEFT(crsarrtime, 2)::INT, RIGHT(crsarrtime, 2)::INT, 0) END AS crs_arr_time,
        CASE WHEN arrtime = '2400' THEN TIME '00:00'
             WHEN arrtime ~ '^([01]\d|2[0-3])[0-5]\d$'
             THEN MAKE_TIME(LEFT(arrtime, 2)::INT, RIGHT(arrtime, 2)::INT, 0) END AS arr_time,
        ROUND(arrdelay::NUMERIC)::INTEGER AS arr_delay,
        (arrdel15::NUMERIC = 1) AS arr_del15,

        (cancelled::NUMERIC = 1) AS cancelled,
        NULLIF(BTRIM(cancellationcode), '') AS cancellation_code,
        CASE NULLIF(BTRIM(cancellationcode), '')
            WHEN 'A' THEN 'carrier'
            WHEN 'B' THEN 'weather'
            WHEN 'C' THEN 'national air system'
            WHEN 'D' THEN 'security'
        END AS cancellation_reason,
        (diverted::NUMERIC = 1) AS diverted,

        ROUND(crselapsedtime::NUMERIC)::INTEGER AS crs_elapsed_time,
        ROUND(actualelapsedtime::NUMERIC)::INTEGER AS actual_elapsed_time,
        ROUND(airtime::NUMERIC)::INTEGER AS air_time,
        ROUND(distance::NUMERIC)::INTEGER AS distance,

        -- Delay causes (minutes). BTS only fills these when the arrival delay is 15+ minutes.
        ROUND(carrierdelay::NUMERIC)::INTEGER AS carrier_delay,
        ROUND(weatherdelay::NUMERIC)::INTEGER AS weather_delay,
        ROUND(nasdelay::NUMERIC)::INTEGER AS nas_delay,
        ROUND(securitydelay::NUMERIC)::INTEGER AS security_delay,
        ROUND(lateaircraftdelay::NUMERIC)::INTEGER AS late_aircraft_delay,

        source_file,
        loaded_at
    FROM raw.bts_on_time
),
numbered AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY flight_date, airline, flight_number, origin, dest, crs_dep_time
            ORDER BY loaded_at DESC
        ) AS copy_number
    FROM typed
)
SELECT
    flight_date, day_of_week, airline, tail_number, flight_number,
    origin_airport_id, origin, origin_city, origin_state,
    dest_airport_id, dest, dest_city, dest_state,
    crs_dep_time, dep_time, dep_delay, dep_del15, taxi_out, taxi_in,
    crs_arr_time, arr_time, arr_delay, arr_del15,
    cancelled, cancellation_code, cancellation_reason, diverted,
    crs_elapsed_time, actual_elapsed_time, air_time, distance,
    carrier_delay, weather_delay, nas_delay, security_delay, late_aircraft_delay,
    source_file
FROM numbered
WHERE copy_number = 1;

-- Indexes for joining flights to weather by airport and day.
CREATE INDEX bts_flights_origin_date_idx ON clean.bts_flights (origin, flight_date);
CREATE INDEX bts_flights_dest_date_idx ON clean.bts_flights (dest, flight_date);

-- Quick check after the build.
SELECT COUNT(*) AS clean_rows,
       MIN(flight_date) AS first_date,
       MAX(flight_date) AS last_date
FROM clean.bts_flights;
