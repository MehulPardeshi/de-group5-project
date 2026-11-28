# NOAA Storm Events

**Owner:** Joshua · **Issue:** [#49](https://github.com/MehulPardeshi/de-group5-project/issues/49) · **Stored in:** PostgreSQL `raw.storm_events_details`

## Status: raw load, profiling and first cleaning done ([PR #83](https://github.com/MehulPardeshi/de-group5-project/pull/83))

- Two yearly files (2025 and 2026), 122,848 events, Jan 1, 2025 – Jul 31, 2026 (August 2026 isn't published yet)
- `clean.storm_events` built by `clean.sql`; quality issues in [docs/data_quality_log.md](../../docs/data_quality_log.md); source details in [notes.md](notes.md)

**Milestone 2:** done and submitted. **Milestone 3:** daily severe-weather flag for ORD, DEN, ATL and DFW ([#100](https://github.com/MehulPardeshi/de-group5-project/issues/100)), then Q4 ([#105](https://github.com/MehulPardeshi/de-group5-project/issues/105)).

## Files in this folder


| File | What goes in it |
| --- | --- |
| `ingest.py` (or a notebook) | Downloads or reads the source and loads it into raw storage |
| `raw.sql` | Creates the raw table, with no constraints that could drop rows |
| `profile.sql` | Quality checks on the raw table (missing values, duplicates, bad formats). Results go in `docs/data_quality_log.md` |
| `clean.sql` | Builds the cleaned table in the `clean` schema from the raw one |
| `notes.md` | Source URL, download date, files, size, row count, columns |

Never commit the data files or passwords. Downloads go in the top-level `data/` folder, which git ignores.
