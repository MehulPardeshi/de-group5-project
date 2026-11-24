# NOAA daily weather (JSON)

**Owner:** Yang · **Issue:** [#48](https://github.com/MehulPardeshi/de-group5-project/issues/48) · **Stored in:** MongoDB Atlas (`de_group5.raw_noaa_daily`), flattened into PostgreSQL `clean.noaa_daily`

## Status: raw load and first cleaning done ([PR #62](https://github.com/MehulPardeshi/de-group5-project/pull/62))

- 5 airports (ATL, DFW, JFK, ORD, PIT), Jan 2025 through Aug 2026
- 100 JSON response pages and 32,200 observations in Atlas `de_group5.raw_noaa_daily`
- 3,040 airport-days in PostgreSQL `clean.noaa_daily`
- Quality issues are in [docs/data_quality_log.md](../../docs/data_quality_log.md); source details and how to run are in [notes.md](notes.md)

**Milestone 2:** done and submitted. **Milestone 3:** add Denver and a daily bad-weather flag ([#99](https://github.com/MehulPardeshi/de-group5-project/issues/99)), then Q2 ([#103](https://github.com/MehulPardeshi/de-group5-project/issues/103)).

## Files in this folder

| File | What it does |
| --- | --- |
| `ingest.py` | Fetches NOAA CDO pages, saves the original JSON to `data/noaa_weather/`, loads it into Atlas and checks the stored copy |
| `profile_and_clean.py` | Checks Atlas against the saved files, profiles the observations, rebuilds `clean.noaa_daily` |
| `clean.sql` | Pivots observations into one row per airport and day |
| `notes.md` | Source, parameters, counts per airport, how to run |

Never commit the data files or passwords. Downloads go in the top-level `data/` folder, which git ignores.
