-- Create a clean storm events table for joining with flight and weather data.
-- Keeps Jan 2025 through Aug 2026 (the project's date range). Raw is never changed.
DROP TABLE IF EXISTS clean.storm_events;

CREATE TABLE clean.storm_events AS
WITH typed AS (
    SELECT
        BTRIM(event_id)::BIGINT AS event_id,
        BTRIM(episode_id)::BIGINT AS episode_id,
        NULLIF(BTRIM(state), '') AS state,
        NULLIF(BTRIM(state_fips), '')::INTEGER AS state_fips,
        NULLIF(BTRIM(event_type), '') AS event_type,
        -- Valid values are C (county), Z (forecast zone) and M (marine). Anything else becomes NULL.
        CASE WHEN BTRIM(cz_type) IN ('C', 'Z', 'M') THEN BTRIM(cz_type) END AS cz_type,
        NULLIF(BTRIM(cz_fips), '')::INTEGER AS cz_fips,
        NULLIF(BTRIM(cz_name), '') AS cz_name,
        NULLIF(BTRIM(wfo), '') AS wfo,
        -- Local clock time at the county or zone, as written in the source.
        TO_TIMESTAMP(BTRIM(begin_date_time), 'DD-MON-YY HH24:MI:SS')::TIMESTAMP AS begin_local,
        TO_TIMESTAMP(BTRIM(end_date_time), 'DD-MON-YY HH24:MI:SS')::TIMESTAMP AS end_local,
        NULLIF(BTRIM(cz_timezone), '') AS cz_timezone,
        -- 'EST-5' -> -5, 'GST10' -> 10 (the number in the label is the UTC offset in hours).
        SUBSTRING(BTRIM(cz_timezone) FROM '(-?[0-9]+)$')::INTEGER AS utc_offset_hours,
        injuries_direct::INTEGER AS injuries_direct,
        injuries_indirect::INTEGER AS injuries_indirect,
        deaths_direct::INTEGER AS deaths_direct,
        deaths_indirect::INTEGER AS deaths_indirect,
        -- '10.00K' -> 10000, '1.5M' -> 1500000, '1.60B' -> 1600000000. Missing stays NULL.
        CASE WHEN BTRIM(damage_property) ~ '^[0-9]*\.?[0-9]+[KMB]?$'
             THEN ROUND(SUBSTRING(BTRIM(damage_property) FROM '^[0-9]*\.?[0-9]+')::NUMERIC
                  * CASE RIGHT(BTRIM(damage_property), 1)
                        WHEN 'K' THEN 1000 WHEN 'M' THEN 1000000 WHEN 'B' THEN 1000000000 ELSE 1 END)
        END AS damage_property_usd,
        CASE WHEN BTRIM(damage_crops) ~ '^[0-9]*\.?[0-9]+[KMB]?$'
             THEN ROUND(SUBSTRING(BTRIM(damage_crops) FROM '^[0-9]*\.?[0-9]+')::NUMERIC
                  * CASE RIGHT(BTRIM(damage_crops), 1)
                        WHEN 'K' THEN 1000 WHEN 'M' THEN 1000000 WHEN 'B' THEN 1000000000 ELSE 1 END)
        END AS damage_crops_usd,
        NULLIF(BTRIM(source), '') AS source,
        NULLIF(BTRIM(magnitude), '')::NUMERIC AS magnitude,
        NULLIF(BTRIM(magnitude_type), '') AS magnitude_type,
        NULLIF(BTRIM(flood_cause), '') AS flood_cause,
        NULLIF(BTRIM(tor_f_scale), '') AS tor_f_scale,
        NULLIF(BTRIM(begin_lat), '')::DOUBLE PRECISION AS begin_lat,
        NULLIF(BTRIM(begin_lon), '')::DOUBLE PRECISION AS begin_lon,
        NULLIF(BTRIM(end_lat), '')::DOUBLE PRECISION AS end_lat,
        NULLIF(BTRIM(end_lon), '')::DOUBLE PRECISION AS end_lon,
        -- Narratives are quoted "" when blank, so treat empty text as missing.
        NULLIF(BTRIM(event_narrative), '') AS event_narrative
    FROM raw.storm_events_details
    WHERE begin_yearmonth BETWEEN '202501' AND '202608'
),
numbered AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY event_id ORDER BY episode_id) AS row_num
    FROM typed
)
SELECT
    event_id, episode_id, state, state_fips, event_type,
    cz_type, cz_fips, cz_name, wfo,
    begin_local, end_local, cz_timezone, utc_offset_hours,
    begin_local::DATE AS begin_date,
    (begin_local - utc_offset_hours * INTERVAL '1 hour') AS begin_utc,
    (end_local - utc_offset_hours * INTERVAL '1 hour') AS end_utc,
    injuries_direct, injuries_indirect, deaths_direct, deaths_indirect,
    damage_property_usd, damage_crops_usd,
    source, magnitude, magnitude_type, flood_cause, tor_f_scale,
    begin_lat, begin_lon, end_lat, end_lon,
    event_narrative
FROM numbered
WHERE row_num = 1;

ALTER TABLE clean.storm_events ADD PRIMARY KEY (event_id);
CREATE INDEX storm_events_state_date_idx ON clean.storm_events (state, begin_date);

-- Funnel: raw rows -> inside date range -> final.
SELECT 1 AS step, 'Raw total' AS stage, COUNT(*) AS rows FROM raw.storm_events_details
UNION ALL
SELECT 2, 'Jan 2025 - Aug 2026', COUNT(*) FROM raw.storm_events_details
    WHERE begin_yearmonth BETWEEN '202501' AND '202608'
UNION ALL
SELECT 3, 'Final (after duplicate removal)', COUNT(*) FROM clean.storm_events
ORDER BY step;

-- Check: the date parsed from the text matches the source year/month/day columns.
SELECT COUNT(*) AS date_mismatches
FROM clean.storm_events c
JOIN raw.storm_events_details r ON r.event_id = c.event_id::TEXT
WHERE TO_CHAR(c.begin_local, 'YYYYMM') <> r.begin_yearmonth
   OR EXTRACT(DAY FROM c.begin_local)::INTEGER <> r.begin_day::INTEGER;

-- Check: last month in the clean table (the source stops before August 2026).
SELECT TO_CHAR(MAX(begin_local), 'YYYY-MM-DD HH24:MI') AS latest_event_start FROM clean.storm_events;

-- Check: events with no coordinates and rows with unknown zone type.
SELECT COUNT(*) FILTER (WHERE begin_lat IS NULL) AS no_coordinates,
       COUNT(*) FILTER (WHERE cz_type IS NULL) AS unknown_cz_type,
       COUNT(*) FILTER (WHERE damage_property_usd IS NULL) AS damage_property_missing
FROM clean.storm_events;
