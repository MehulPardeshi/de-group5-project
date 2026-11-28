-- Daily delay and cancellation rates from clean.bts_flights (#101).
-- Run: docker compose exec -T postgres psql -U de -d de_group5 < pipeline/bts/integrate.sql
-- Rebuilt from scratch every run, so it is safe to re-run.
--
-- Two tables, both by origin airport (the airport the flight leaves from):
--   integrated.bts_daily_airport          one row per airport per day
--   integrated.bts_daily_airport_airline  one row per airport per airline per day (for Q3)
--
-- Definitions agreed in #76:
--   delay rate        = departures 15+ minutes late / non-cancelled flights
--   cancellation rate = cancelled flights / scheduled flights
-- Diverted flights count as non-cancelled, since they did leave.
-- The delay cause minutes are BTS's split of the ARRIVAL delay. They are only filled
-- for flights that arrived 15+ minutes late, and are added to the origin airport here.

CREATE SCHEMA IF NOT EXISTS integrated;

DROP TABLE IF EXISTS integrated.bts_daily_airport;

CREATE TABLE integrated.bts_daily_airport AS
SELECT
    origin AS airport,
    flight_date,
    COUNT(*) AS scheduled_flights,
    COUNT(*) FILTER (WHERE cancelled) AS cancelled_flights,
    COUNT(*) FILTER (WHERE NOT cancelled) AS non_cancelled_flights,
    COUNT(*) FILTER (WHERE NOT cancelled AND dep_del15) AS late_departures,
    ROUND(COUNT(*) FILTER (WHERE NOT cancelled AND dep_del15)::NUMERIC
          / NULLIF(COUNT(*) FILTER (WHERE NOT cancelled), 0), 4) AS delay_rate,
    ROUND(COUNT(*) FILTER (WHERE cancelled)::NUMERIC / COUNT(*), 4) AS cancellation_rate,
    COALESCE(SUM(carrier_delay), 0) AS carrier_delay_min,
    COALESCE(SUM(weather_delay), 0) AS weather_delay_min,
    COALESCE(SUM(nas_delay), 0) AS nas_delay_min,
    COALESCE(SUM(security_delay), 0) AS security_delay_min,
    COALESCE(SUM(late_aircraft_delay), 0) AS late_aircraft_delay_min
FROM clean.bts_flights
GROUP BY origin, flight_date;

ALTER TABLE integrated.bts_daily_airport ADD PRIMARY KEY (airport, flight_date);


DROP TABLE IF EXISTS integrated.bts_daily_airport_airline;

CREATE TABLE integrated.bts_daily_airport_airline AS
SELECT
    origin AS airport,
    flight_date,
    airline,
    COUNT(*) AS scheduled_flights,
    COUNT(*) FILTER (WHERE cancelled) AS cancelled_flights,
    COUNT(*) FILTER (WHERE NOT cancelled) AS non_cancelled_flights,
    COUNT(*) FILTER (WHERE NOT cancelled AND dep_del15) AS late_departures,
    ROUND(COUNT(*) FILTER (WHERE NOT cancelled AND dep_del15)::NUMERIC
          / NULLIF(COUNT(*) FILTER (WHERE NOT cancelled), 0), 4) AS delay_rate,
    ROUND(COUNT(*) FILTER (WHERE cancelled)::NUMERIC / COUNT(*), 4) AS cancellation_rate,
    COALESCE(SUM(carrier_delay), 0) AS carrier_delay_min,
    COALESCE(SUM(weather_delay), 0) AS weather_delay_min,
    COALESCE(SUM(nas_delay), 0) AS nas_delay_min,
    COALESCE(SUM(security_delay), 0) AS security_delay_min,
    COALESCE(SUM(late_aircraft_delay), 0) AS late_aircraft_delay_min
FROM clean.bts_flights
GROUP BY origin, flight_date, airline;

ALTER TABLE integrated.bts_daily_airport_airline ADD PRIMARY KEY (airport, flight_date, airline);


-- Checks after the build.

-- 1. Flights in each table should add up to the 11,730,351 in clean.bts_flights.
SELECT
    (SELECT COUNT(*) FROM clean.bts_flights) AS clean_flights,
    (SELECT SUM(scheduled_flights) FROM integrated.bts_daily_airport) AS airport_table_flights,
    (SELECT SUM(scheduled_flights) FROM integrated.bts_daily_airport_airline) AS airline_table_flights;

-- 2. The busiest airports by scheduled departures, Jan 2025 - Aug 2026.
--    #76 says the top three are ORD, DEN and ATL.
SELECT airport, SUM(scheduled_flights) AS scheduled_departures
FROM integrated.bts_daily_airport
GROUP BY airport
ORDER BY scheduled_departures DESC
LIMIT 5;
