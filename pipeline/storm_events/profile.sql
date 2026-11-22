-- Quality checks on raw.storm_events_details. Results go in docs/data_quality_log.md.

-- 1. Total rows and rows per source file year.
SELECT year, COUNT(*) AS rows
FROM raw.storm_events_details
GROUP BY year
ORDER BY year;

-- 2. Date coverage: first and last month with events, and rows per month in 2026.
SELECT MIN(begin_yearmonth) AS first_month, MAX(begin_yearmonth) AS last_month
FROM raw.storm_events_details;

SELECT begin_yearmonth, COUNT(*) AS rows
FROM raw.storm_events_details
WHERE begin_yearmonth >= '202601'
GROUP BY begin_yearmonth
ORDER BY begin_yearmonth;

-- 3. Duplicate event IDs.
SELECT COUNT(*) AS duplicate_event_ids
FROM (
    SELECT event_id FROM raw.storm_events_details GROUP BY event_id HAVING COUNT(*) > 1
) AS d;

-- 4. Rows with no coordinates, by county/zone type (C = county, Z = forecast zone, M = marine).
SELECT cz_type,
       COUNT(*) AS rows,
       COUNT(*) FILTER (WHERE begin_lat IS NULL) AS no_coordinates
FROM raw.storm_events_details
GROUP BY cz_type
ORDER BY cz_type;

-- 5. Damage values are text such as '10.00K', '1.5M', '1.00B'. Count by suffix.
SELECT 'DAMAGE_PROPERTY' AS column_name,
       COALESCE(SUBSTRING(BTRIM(damage_property) FROM '[A-Za-z]$'), '(no suffix)') AS suffix,
       COUNT(*) AS rows
FROM raw.storm_events_details
WHERE damage_property IS NOT NULL
GROUP BY 2
UNION ALL
SELECT 'DAMAGE_CROPS',
       COALESCE(SUBSTRING(BTRIM(damage_crops) FROM '[A-Za-z]$'), '(no suffix)'),
       COUNT(*)
FROM raw.storm_events_details
WHERE damage_crops IS NOT NULL
GROUP BY 2
ORDER BY 1, 2;

-- 6. Missing damage values (NULL, not zero).
SELECT COUNT(*) FILTER (WHERE damage_property IS NULL) AS property_null,
       COUNT(*) FILTER (WHERE damage_crops IS NULL) AS crops_null
FROM raw.storm_events_details;

-- 7. Dates are text like '31-MAR-25 11:04:00'. Rows that do not match that format.
SELECT COUNT(*) AS bad_begin_format
FROM raw.storm_events_details
WHERE begin_date_time !~ '^[0-9]{2}-[A-Z]{3}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$';

-- 8. Time zone labels. They are local to the county or zone, and a few use daylight-time labels.
SELECT cz_timezone, COUNT(*) AS rows
FROM raw.storm_events_details
GROUP BY cz_timezone
ORDER BY rows DESC;

-- 9. Invalid CZ_TYPE values (expected C, Z or M).
SELECT event_id, state, cz_type, cz_name, event_type, begin_date_time
FROM raw.storm_events_details
WHERE cz_type NOT IN ('C', 'Z', 'M')
ORDER BY event_id;

-- 10. Impossible values: end before begin, negative or non-numeric counts, bad coordinates.
SELECT
    COUNT(*) FILTER (
        WHERE TO_TIMESTAMP(end_date_time, 'DD-MON-YY HH24:MI:SS')
            < TO_TIMESTAMP(begin_date_time, 'DD-MON-YY HH24:MI:SS')
    ) AS end_before_begin,
    COUNT(*) FILTER (WHERE deaths_direct !~ '^[0-9]+$' OR injuries_direct !~ '^[0-9]+$') AS bad_counts,
    COUNT(*) FILTER (WHERE begin_lat IS NOT NULL
        AND (begin_lat::DOUBLE PRECISION NOT BETWEEN -90 AND 90
          OR begin_lon::DOUBLE PRECISION NOT BETWEEN -180 AND 180)) AS bad_coordinates
FROM raw.storm_events_details;

-- 11. Event types (needed later to decide which count as "bad weather").
SELECT event_type, COUNT(*) AS rows
FROM raw.storm_events_details
GROUP BY event_type
ORDER BY rows DESC;

-- 12. Columns that are almost entirely empty.
SELECT COUNT(*) AS rows,
       COUNT(*) FILTER (WHERE category IS NULL) AS category_null,
       COUNT(*) FILTER (WHERE tor_f_scale IS NULL) AS tor_f_scale_null,
       COUNT(*) FILTER (WHERE flood_cause IS NULL) AS flood_cause_null,
       COUNT(*) FILTER (WHERE event_narrative IS NULL) AS event_narrative_null
FROM raw.storm_events_details;
