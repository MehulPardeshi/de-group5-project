# NOAA daily weather (JSON)

**Owner:** Yang · **Issue:** [#48](https://github.com/MehulPardeshi/de-group5-project/issues/48) · **Stored in:** MongoDB Atlas (`de_group5.raw_noaa_daily`), flattened into PostgreSQL `clean.noaa_daily`

## Status: raw load and first cleaning done ([PR #62](https://github.com/MehulPardeshi/de-group5-project/pull/62))

- 5 airports (ATL, DFW, JFK, ORD, PIT), Jan 2025 through Aug 2026
- 100 JSON response pages and 32,200 observations in Atlas `de_group5.raw_noaa_daily`
- 3,040 airport-days in PostgreSQL `clean.noaa_daily`
- Quality issues are in [docs/data_quality_log.md](../../docs/data_quality_log.md); source details and how to run are in [notes.md](notes.md)

**Milestone 2:** done and submitted. **Milestone 3:** add Denver and a daily bad-weather flag ([#99](https://github.com/MehulPardeshi/de-group5-project/issues/99)), then Q2 ([#103](https://github.com/MehulPardeshi/de-group5-project/issues/103)).

## Milestone 3: six-airport weather integration

Denver uses `GHCND:USW00003017` (Denver International Airport), verified with NOAA's station endpoint. The existing five airports keep their original snapshots. The commands below run from the repository root after the database setup and `.env` configuration.

```sh
# New machine: download all six airports. Existing five-airport setup: add --airports DEN.
.venv/bin/python pipeline/noaa_weather/ingest.py --end 2026-08-31
.venv/bin/python pipeline/noaa_weather/profile_and_clean.py
.venv/bin/python pipeline/noaa_weather/integrate.py
.venv/bin/python pipeline/noaa_weather/test_integrate.py
```

`integrate.py` builds `integrated.noaa_daily` for Jan 1, 2025 through Aug 31, 2026. Its primary key is `(airport, weather_date)`. It contains the station ID, rain, snow, gust, reported WT flags, separate trigger indicators, source-day presence, missing-measurement indicator and `bad_weather` (`yes`, `no`, `unknown`). Its default calendar has 608 days per airport, including an explicit unknown row if a source day is absent. Repeating it replaces the table contents in one transaction. A station mismatch or unexpected output count stops the run and rolls back the replacement.

The rule follows [#76](https://github.com/MehulPardeshi/de-group5-project/issues/76):

- `yes`: precipitation ≥ 12.7 mm, snowfall ≥ 25.4 mm, five-second wind ≥ 17.9 m/s, or a selected WT flag has value 1. A positive trigger takes priority over other missing readings.
- `unknown`: no trigger qualifies and precipitation, snowfall or five-second wind is missing.
- `no`: those three measurements are present and below the cutoffs, and no selected flag is reported.

Selected flags are WT01, WT02, WT21 and WT22 (fog variants), WT03 (thunder), and WT17 (freezing rain), using the [NOAA GHCND codebook](https://www.ncei.noaa.gov/pub/data/ghcn/daily/readme.txt). An unreported WT code is not a positive flag. An empty WT object means no weather-type records were supplied; it is not independent proof of clear weather. Missing snow depth, temperature or average wind does not make this particular rule unknown because those fields are not inputs to it. PRCP is total precipitation, so the team's rain proxy can include liquid-equivalent frozen precipitation. These are team analysis cutoffs, not official aviation warning thresholds.

Mehul's airport bridge (#98) is still pending. These verified station IDs are documented in `notes.md` for that bridge; this step does not invent a county/zone mapping or change his files. Downstream serving tables can join by airport and date, and cross-check station IDs against the bridge once available.

The test uses temporary PostgreSQL tables and rolls back every test record. It checks cutoff boundaries, selected and unselected flags, missing inputs, an absent source day, and an identical second run. Test fixtures never enter the project tables or Atlas.

## Files in this folder

| File | What it does |
| --- | --- |
| `ingest.py` | Fetches NOAA CDO pages, saves the original JSON to `data/noaa_weather/`, loads it into Atlas and checks the stored copy |
| `profile_and_clean.py` | Checks Atlas against the saved files, profiles the observations, rebuilds `clean.noaa_daily` |
| `clean.sql` | Pivots observations into one row per airport and day |
| `integrate.py`, `integrate.sql` | Builds and validates the daily yes/no/unknown weather indicators |
| `test_integrate.py` | Checks classification and repeat runs with temporary tables |
| `notes.md` | Source, parameters, counts per airport, how to run |

Never commit the data files or passwords. Downloads go in the top-level `data/` folder, which git ignores.
