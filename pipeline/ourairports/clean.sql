-- Create a clean US airport table for joining with flight data.
DROP TABLE IF EXISTS clean.airports;

CREATE TABLE clean.airports AS
WITH airports AS (
    SELECT
        NULLIF(BTRIM(iata_code), '') AS iata_code,
        COALESCE(NULLIF(BTRIM(icao_code), ''), NULLIF(BTRIM(gps_code), '')) AS icao_code,
        NULLIF(BTRIM(name), '') AS name,
        NULLIF(BTRIM(type), '') AS type,
        NULLIF(BTRIM(municipality), '') AS city,
        NULLIF(SPLIT_PART(BTRIM(iso_region), '-', 2), '') AS state,
        CASE
            WHEN BTRIM(latitude_deg) ~ '^[-+]?[0-9]+(\.[0-9]+)?$'
            THEN BTRIM(latitude_deg)::DOUBLE PRECISION
            ELSE NULL
        END AS latitude,
        CASE
            WHEN BTRIM(longitude_deg) ~ '^[-+]?[0-9]+(\.[0-9]+)?$'
            THEN BTRIM(longitude_deg)::DOUBLE PRECISION
            ELSE NULL
        END AS longitude,
        CASE
            WHEN BTRIM(elevation_ft) ~ '^[-+]?[0-9]+$'
            THEN BTRIM(elevation_ft)::INTEGER
            ELSE NULL
        END AS elevation_ft,
        CASE
            WHEN BTRIM(scheduled_service) = 'yes' THEN TRUE
            WHEN BTRIM(scheduled_service) = 'no' THEN FALSE
            ELSE NULL
        END AS scheduled_service,
        id
    FROM raw.ourairports_airports
    WHERE BTRIM(iso_country) = 'US'
      AND BTRIM(iata_code) ~ '^[A-Z]{3}$'
      AND BTRIM(type) <> 'closed'
),
numbered AS (
    SELECT *,
        -- Keep scheduled-service airports first, then larger airports, then the lowest numeric ID.
        ROW_NUMBER() OVER (
            PARTITION BY iata_code
            ORDER BY
                CASE WHEN scheduled_service = TRUE THEN 0 ELSE 1 END,
                CASE type
                    WHEN 'large_airport' THEN 0
                    WHEN 'medium_airport' THEN 1
                    WHEN 'small_airport' THEN 2
                    ELSE 3
                END,
                id::INTEGER
        ) AS row_num
    FROM airports
    WHERE latitude BETWEEN -90 AND 90
      AND longitude BETWEEN -180 AND 180
)
SELECT
    iata_code, icao_code, name, type, city, state,
    latitude, longitude, elevation_ft, scheduled_service
FROM numbered
WHERE row_num = 1;

ALTER TABLE clean.airports ADD PRIMARY KEY (iata_code);

-- Funnel: raw rows -> US -> valid IATA -> open -> valid coordinates -> final.
WITH us AS (
    SELECT * FROM raw.ourairports_airports
    WHERE BTRIM(iso_country) = 'US'
),
valid_iata AS (
    SELECT * FROM us
    WHERE BTRIM(iata_code) ~ '^[A-Z]{3}$'
),
open_airports AS (
    SELECT * FROM valid_iata
    WHERE BTRIM(type) <> 'closed'
),
valid_coordinates AS (
    SELECT * FROM open_airports
    WHERE
        CASE
            WHEN BTRIM(latitude_deg) ~ '^[-+]?[0-9]+(\.[0-9]+)?$'
            THEN BTRIM(latitude_deg)::DOUBLE PRECISION BETWEEN -90 AND 90
            ELSE FALSE
        END
        AND
        CASE
            WHEN BTRIM(longitude_deg) ~ '^[-+]?[0-9]+(\.[0-9]+)?$'
            THEN BTRIM(longitude_deg)::DOUBLE PRECISION BETWEEN -180 AND 180
            ELSE FALSE
        END
)
SELECT 1 AS step, 'Raw total' AS stage, COUNT(*) AS rows FROM raw.ourairports_airports
UNION ALL
SELECT 2, 'US airports', COUNT(*) FROM us
UNION ALL
SELECT 3, 'Valid IATA code', COUNT(*) FROM valid_iata
UNION ALL
SELECT 4, 'Not closed', COUNT(*) FROM open_airports
UNION ALL
SELECT 5, 'Valid coordinates', COUNT(*) FROM valid_coordinates
UNION ALL
SELECT 6, 'Final (after duplicate removal)', COUNT(*) FROM clean.airports
ORDER BY step;
