-- Runs once, the first time the database container starts.
-- raw: data exactly as downloaded (no constraints that could drop rows).
-- clean: typed, deduplicated, cleaned tables built from raw.
CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS clean;
