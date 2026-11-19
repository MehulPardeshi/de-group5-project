# BTS on-time flights

**Owner:** Sowmya · **Issue:** [#47](https://github.com/MehulPardeshi/de-group5-project/issues/47) · **Stored in:** PostgreSQL `raw.bts_on_time`

## Status: raw load, profiling and first cleaning done ([PR #74](https://github.com/MehulPardeshi/de-group5-project/pull/74))

- 20 monthly files, Jan 2025 through Aug 2026: 11,730,351 flights in `raw.bts_on_time`, the same count in `clean.bts_flights` (no duplicates)
- 12 quality issues in [docs/data_quality_log.md](../../docs/data_quality_log.md); full profiling output in `profile_output.txt`
- Source details and how to run are in [notes.md](notes.md)

Left for Milestone 2: Sowmya's ~1 minute video clip (see [#47](https://github.com/MehulPardeshi/de-group5-project/issues/47)).

## Files in this folder

| File | What it does |
| --- | --- |
| `raw.sql` | Creates `raw.bts_on_time`: all 109 CSV columns as TEXT, plus `trailing_empty`, `source_file` and `loaded_at` |
| `ingest.py` | Loads the monthly zips from `data/bts/` with COPY and checks the row count (all months, or one month) |
| `profile.sql` | Quality checks on the raw table; results in `profile_output.txt` |
| `clean.sql` | Builds `clean.bts_flights`: typed, blanks to NULL, cancellation reasons, dedupe, join indexes |
| `notes.md` | Source, download date, size, columns, how to run |
| `quality_log_rows.md` | Copy of the BTS rows in the team quality log |

Never commit the data files or passwords. Downloads go in the top-level `data/` folder, which git ignores.
