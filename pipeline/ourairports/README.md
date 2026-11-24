# OurAirports

**Owner:** Mehul · **Issue:** [#50](https://github.com/MehulPardeshi/de-group5-project/issues/50) · **Stored in:** PostgreSQL `raw.ourairports_airports`

**Status:** raw load, profiling, `clean.airports` (with US territories) and quality log rows done ([#55](https://github.com/MehulPardeshi/de-group5-project/pull/55), [#57](https://github.com/MehulPardeshi/de-group5-project/pull/57)). **Milestone 3:** airport bridge to weather stations, counties and zones ([#98](https://github.com/MehulPardeshi/de-group5-project/issues/98)), then Q1 ([#102](https://github.com/MehulPardeshi/de-group5-project/issues/102)).

**Run it** (from the repo root, with Docker running):
```bash
.venv/bin/python pipeline/ourairports/ingest.py   # loads raw, checks 86,350 rows
psql ... -f pipeline/ourairports/profile.sql       # quality checks
psql ... -f pipeline/ourairports/clean.sql         # builds clean.airports + funnel
```

Files in this folder:

| File | What goes in it |
| --- | --- |
| `ingest.py` (or a notebook) | Downloads or reads the source and loads it into raw storage |
| `raw.sql` | Creates the raw table, with no constraints that could drop rows |
| `profile.sql` | Quality checks on the raw table (missing values, duplicates, bad formats). Results go in `docs/data_quality_log.md` |
| `clean.sql` | Builds the cleaned table in the `clean` schema from the raw one |
| `notes.md` | Source URL, download date, files, size, row count, columns |

Never commit the data files or passwords. Downloads go in the top-level `data/` folder, which git ignores.
