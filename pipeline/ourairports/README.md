# OurAirports

**Owner:** Mehul · **Issue:** [#50](https://github.com/MehulPardeshi/de-group5-project/issues/50) · **Stored in:** PostgreSQL `raw.ourairports_airports`

**Status (Nov 10):** raw load, profiling and `clean.airports` done ([#55](https://github.com/MehulPardeshi/de-group5-project/pull/55)). Still to do: include US territories, quality log rows.

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
