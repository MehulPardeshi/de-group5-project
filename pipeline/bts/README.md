# BTS on-time flights

**Owner:** Sowmya · **Issue:** [#47](https://github.com/MehulPardeshi/de-group5-project/issues/47) · **Stored in:** PostgreSQL `raw.bts_on_time`

## Status: raw load, profiling and first cleaning done ([PR #74](https://github.com/MehulPardeshi/de-group5-project/pull/74))

- 20 monthly files, Jan 2025 through Aug 2026: 11,730,351 flights in `raw.bts_on_time`, the same count in `clean.bts_flights` (no duplicates)
- 12 quality issues in [docs/data_quality_log.md](../../docs/data_quality_log.md); full profiling output in `profile_output.txt`
- Source details and how to run are in [notes.md](notes.md)

**Milestone 2:** done and submitted. **Milestone 3:** daily rates by airport and airline ([#101](https://github.com/MehulPardeshi/de-group5-project/issues/101)), then Q3 ([#104](https://github.com/MehulPardeshi/de-group5-project/issues/104)).

## Files in this folder

| File | What it does |
| --- | --- |
| `raw.sql` | Creates `raw.bts_on_time`: all 109 CSV columns as TEXT, plus `trailing_empty`, `source_file` and `loaded_at` |
| `ingest.py` | Loads the monthly zips from `data/bts/` with COPY and checks the row count (all months, or one month) |
| `profile.sql` | Quality checks on the raw table; results in `profile_output.txt` |
| `clean.sql` | Builds `clean.bts_flights`: typed, blanks to NULL, cancellation reasons, dedupe, join indexes |
| `integrate.sql` | Builds `integrated.bts_daily_airport` and `integrated.bts_daily_airport_airline`: flights, cancellations, late departures, delay and cancellation rates, and delay cause minutes per airport per day ([#101](https://github.com/MehulPardeshi/de-group5-project/issues/101)) |
| `notes.md` | Source, download date, size, columns, how to run |
| `quality_log_rows.md` | Copy of the BTS rows in the team quality log |

## How to run (after `clean.sql`)

```
docker compose exec -T postgres psql -U de -d de_group5 < pipeline/bts/integrate.sql
```

It takes about 15 seconds, rebuilds both tables from scratch, and ends with two checks: the flight totals (should be 11,730,351 in both tables) and the five busiest airports.

Never commit the data files or passwords. Downloads go in the top-level `data/` folder, which git ignores.
