-- Quality checks on raw.bts_on_time. Results go in docs/data_quality_log.md.
-- Run: docker compose exec -T postgres psql -U de -d de_group5 < pipeline/bts/profile.sql
-- Blank values come in two ways: unquoted blanks load as NULL and quoted "" loads
-- as ''. NULLIF(BTRIM(x), '') turns both into NULL so each check counts them once.

-- 1. Rows per source file, plus the total.
SELECT COALESCE(source_file, 'TOTAL') AS source_file, COUNT(*) AS rows
FROM raw.bts_on_time
GROUP BY ROLLUP (source_file)
ORDER BY source_file NULLS LAST;

-- 2. Date range, and any flight dates that aren't YYYY-MM-DD.
SELECT
    MIN(flightdate) AS first_date,
    MAX(flightdate) AS last_date,
    COUNT(DISTINCT flightdate) AS distinct_dates,
    COUNT(*) FILTER (WHERE flightdate !~ '^\d{4}-\d{2}-\d{2}$' OR flightdate IS NULL) AS bad_dates
FROM raw.bts_on_time;

-- 3. Duplicate flights: same date, airline, flight number, route and scheduled departure.
SELECT
    COUNT(*) AS duplicate_groups,
    COALESCE(SUM(copies - 1), 0) AS extra_rows
FROM (
    SELECT COUNT(*) AS copies
    FROM raw.bts_on_time
    GROUP BY flightdate, reporting_airline, flight_number_reporting_airline,
             origin, dest, crsdeptime
    HAVING COUNT(*) > 1
) AS dups;

-- 4. Cancelled and diverted flights.
SELECT
    COUNT(*) FILTER (WHERE cancelled::NUMERIC = 1) AS cancelled,
    COUNT(*) FILTER (WHERE diverted::NUMERIC = 1) AS diverted,
    COUNT(*) FILTER (WHERE cancelled::NUMERIC = 1 AND diverted::NUMERIC = 1) AS both
FROM raw.bts_on_time;

-- 5. Cancellation codes (A carrier, B weather, C NAS, D security), and codes that
--    don't line up with the Cancelled flag.
SELECT
    COALESCE(NULLIF(BTRIM(cancellationcode), ''), '(blank)') AS code,
    cancelled,
    COUNT(*) AS rows
FROM raw.bts_on_time
GROUP BY 1, 2
ORDER BY 1, 2;

-- 6. Missing values in the columns we need.
SELECT
    COUNT(*) FILTER (WHERE NULLIF(BTRIM(tail_number), '') IS NULL) AS blank_tail_number,
    COUNT(*) FILTER (WHERE NULLIF(BTRIM(origin), '') IS NULL
                        OR NULLIF(BTRIM(dest), '') IS NULL) AS blank_airport,
    COUNT(*) FILTER (WHERE cancelled::NUMERIC = 0 AND NULLIF(deptime, '') IS NULL) AS flown_no_dep_time,
    COUNT(*) FILTER (WHERE cancelled::NUMERIC = 0 AND diverted::NUMERIC = 0
                       AND arrdelay IS NULL) AS completed_no_arr_delay
FROM raw.bts_on_time;

-- 7. Delay causes are only filled when the arrival delay is 15+ minutes.
SELECT
    COUNT(*) FILTER (WHERE arrdel15::NUMERIC = 1) AS late_15_plus,
    COUNT(*) FILTER (WHERE arrdel15::NUMERIC = 1 AND carrierdelay IS NOT NULL) AS late_with_causes,
    COUNT(*) FILTER (WHERE arrdel15::NUMERIC = 1 AND carrierdelay IS NULL) AS late_without_causes,
    COUNT(*) FILTER (WHERE COALESCE(arrdel15::NUMERIC, 0) = 0
                       AND carrierdelay IS NOT NULL) AS causes_but_not_late
FROM raw.bts_on_time;

-- 8. Do the five causes add up to the arrival delay?
SELECT
    COUNT(*) AS rows_with_causes,
    COUNT(*) FILTER (WHERE carrierdelay::NUMERIC + weatherdelay::NUMERIC + nasdelay::NUMERIC
                         + securitydelay::NUMERIC + lateaircraftdelay::NUMERIC
                         = arrdelay::NUMERIC) AS causes_equal_delay,
    COUNT(*) FILTER (WHERE carrierdelay::NUMERIC + weatherdelay::NUMERIC + nasdelay::NUMERIC
                         + securitydelay::NUMERIC + lateaircraftdelay::NUMERIC
                         <> arrdelay::NUMERIC) AS causes_differ
FROM raw.bts_on_time
WHERE carrierdelay IS NOT NULL;

-- 9. Midnight written as "2400".
SELECT
    COUNT(*) FILTER (WHERE crsdeptime = '2400') AS crs_dep_2400,
    COUNT(*) FILTER (WHERE deptime = '2400') AS dep_2400,
    COUNT(*) FILTER (WHERE crsarrtime = '2400') AS crs_arr_2400,
    COUNT(*) FILTER (WHERE arrtime = '2400') AS arr_2400
FROM raw.bts_on_time;

-- 10. Clock times that aren't a valid HHMM (0000-2359, or 2400). Blanks are skipped:
--     cancelled flights have "" for the times that never happened.
SELECT
    COUNT(*) FILTER (WHERE NULLIF(crsdeptime, '') !~ '^(([01]\d|2[0-3])[0-5]\d|2400)$') AS bad_crs_dep,
    COUNT(*) FILTER (WHERE NULLIF(deptime, '') !~ '^(([01]\d|2[0-3])[0-5]\d|2400)$') AS bad_dep,
    COUNT(*) FILTER (WHERE NULLIF(crsarrtime, '') !~ '^(([01]\d|2[0-3])[0-5]\d|2400)$') AS bad_crs_arr,
    COUNT(*) FILTER (WHERE NULLIF(arrtime, '') !~ '^(([01]\d|2[0-3])[0-5]\d|2400)$') AS bad_arr
FROM raw.bts_on_time;

-- 11. Ranges of the main numbers. Negative delays mean the flight was early.
SELECT
    MIN(depdelay::NUMERIC) AS min_dep_delay, MAX(depdelay::NUMERIC) AS max_dep_delay,
    MIN(arrdelay::NUMERIC) AS min_arr_delay, MAX(arrdelay::NUMERIC) AS max_arr_delay,
    MIN(distance::NUMERIC) AS min_distance, MAX(distance::NUMERIC) AS max_distance,
    MIN(airtime::NUMERIC) AS min_air_time, MAX(airtime::NUMERIC) AS max_air_time,
    COUNT(*) FILTER (WHERE distance::NUMERIC <= 0) AS non_positive_distance,
    COUNT(*) FILTER (WHERE airtime::NUMERIC <= 0) AS non_positive_air_time
FROM raw.bts_on_time;

-- 12. Delays of more than 24 hours (1,440 minutes).
SELECT
    COUNT(*) FILTER (WHERE depdelay::NUMERIC > 1440) AS dep_delay_over_24h,
    COUNT(*) FILTER (WHERE arrdelay::NUMERIC > 1440) AS arr_delay_over_24h
FROM raw.bts_on_time;

-- 12a. The ten longest arrival delays.
SELECT flightdate, reporting_airline, flight_number_reporting_airline,
       origin, dest, crsdeptime, deptime, arrdelay
FROM raw.bts_on_time
WHERE arrdelay::NUMERIC > 1440
ORDER BY arrdelay::NUMERIC DESC
LIMIT 10;

-- 13. Diversion columns: filled for diverted flights, empty for the rest?
--     In January, 86 non-diverted rows had DivAirportLandings = 9 (85 of them cancelled).
--     The BTS readme doesn't explain the value 9.
SELECT
    diverted,
    COUNT(*) AS rows,
    COUNT(*) FILTER (WHERE divairportlandings::NUMERIC > 0) AS has_div_landing,
    COUNT(*) FILTER (WHERE NULLIF(BTRIM(div1airport), '') IS NOT NULL) AS has_div1_airport,
    COUNT(*) FILTER (WHERE divreacheddest::NUMERIC = 1) AS reached_dest
FROM raw.bts_on_time
GROUP BY diverted
ORDER BY diverted;

-- 14. Rows per airline.
SELECT reporting_airline, COUNT(*) AS rows
FROM raw.bts_on_time
GROUP BY reporting_airline
ORDER BY rows DESC;

-- 15. Airport codes that aren't three letters, and flights with origin = destination.
SELECT
    COUNT(*) FILTER (WHERE origin !~ '^[A-Z0-9]{3}$' OR dest !~ '^[A-Z0-9]{3}$') AS bad_airport_code,
    COUNT(*) FILTER (WHERE origin = dest) AS same_origin_dest,
    COUNT(DISTINCT origin) AS origin_airports,
    COUNT(DISTINCT dest) AS dest_airports
FROM raw.bts_on_time;
