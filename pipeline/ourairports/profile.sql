-- 1. Total rows and number of airports by type.
SELECT 'ALL' AS type, COUNT(*) AS rows
FROM raw.ourairports_airports
UNION ALL
SELECT COALESCE(NULLIF(BTRIM(type), ''), '(missing)'), COUNT(*)
FROM raw.ourairports_airports
GROUP BY COALESCE(NULLIF(BTRIM(type), ''), '(missing)')
ORDER BY type;

-- 2. US airports with and without an IATA code.
SELECT
    COUNT(*) AS total_us,
    COUNT(*) FILTER (WHERE NULLIF(BTRIM(iata_code), '') IS NOT NULL) AS with_iata,
    COUNT(*) FILTER (WHERE NULLIF(BTRIM(iata_code), '') IS NULL) AS without_iata
FROM raw.ourairports_airports
WHERE BTRIM(iso_country) = 'US';

-- 3. Number of IATA codes appearing more than once (all countries).
SELECT
    COUNT(*) AS duplicate_iata_codes,
    COALESCE(SUM(airport_rows - 1), 0) AS extra_rows
FROM (
    SELECT BTRIM(iata_code) AS iata_code, COUNT(*) AS airport_rows
    FROM raw.ourairports_airports
    WHERE NULLIF(BTRIM(iata_code), '') IS NOT NULL
    GROUP BY BTRIM(iata_code)
    HAVING COUNT(*) > 1
) AS duplicates;

-- 3a. Five example rows with duplicate IATA codes.
SELECT ident, name, iso_country, type, iata_code
FROM raw.ourairports_airports
WHERE BTRIM(iata_code) IN (
    SELECT BTRIM(iata_code)
    FROM raw.ourairports_airports
    WHERE NULLIF(BTRIM(iata_code), '') IS NOT NULL
    GROUP BY BTRIM(iata_code)
    HAVING COUNT(*) > 1
)
ORDER BY BTRIM(iata_code), ident
LIMIT 5;

-- 4. Non-blank IATA codes that are not three uppercase letters.
SELECT COUNT(*) AS invalid_iata_codes
FROM raw.ourairports_airports
WHERE NULLIF(BTRIM(iata_code), '') IS NOT NULL
  AND BTRIM(iata_code) !~ '^[A-Z]{3}$';

-- 5. Missing, non-numeric, or out-of-range coordinates.
-- The second count shows how many rows are excluded at the coordinate step.
WITH checked AS (
    SELECT iso_country, iata_code, type,
        CASE
            WHEN BTRIM(latitude_deg) ~ '^[-+]?[0-9]+(\.[0-9]+)?$'
            THEN BTRIM(latitude_deg)::DOUBLE PRECISION BETWEEN -90 AND 90
            ELSE FALSE
        END AS valid_lat,
        CASE
            WHEN BTRIM(longitude_deg) ~ '^[-+]?[0-9]+(\.[0-9]+)?$'
            THEN BTRIM(longitude_deg)::DOUBLE PRECISION BETWEEN -180 AND 180
            ELSE FALSE
        END AS valid_lon
    FROM raw.ourairports_airports
)
SELECT
    COUNT(*) FILTER (WHERE NOT valid_lat OR NOT valid_lon) AS invalid_coordinates,
    COUNT(*) FILTER (
        WHERE (NOT valid_lat OR NOT valid_lon)
          AND BTRIM(iso_country) = 'US'
          AND BTRIM(iata_code) ~ '^[A-Z]{3}$'
          AND BTRIM(type) <> 'closed'
    ) AS invalid_coordinates_excluded_from_clean
FROM checked;

-- 6. Missing elevations and elevations that are not integers.
SELECT
    COUNT(*) FILTER (WHERE NULLIF(BTRIM(elevation_ft), '') IS NULL) AS missing_elevation,
    COUNT(*) FILTER (
        WHERE NULLIF(BTRIM(elevation_ft), '') IS NOT NULL
          AND BTRIM(elevation_ft) !~ '^[-+]?[0-9]+$'
    ) AS invalid_elevation
FROM raw.ourairports_airports;

-- 7. Closed US airports that still have an IATA code.
SELECT COUNT(*) AS closed_us_with_iata
FROM raw.ourairports_airports
WHERE BTRIM(iso_country) = 'US'
  AND NULLIF(BTRIM(iata_code), '') IS NOT NULL
  AND BTRIM(type) = 'closed';
