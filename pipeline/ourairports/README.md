# OurAirports

**Owner:** Mehul · **Issue:** [#50](https://github.com/MehulPardeshi/de-group5-project/issues/50) · **Stored in:** PostgreSQL `raw.ourairports_airports`

Put everything for this dataset in this folder:

| File | What goes in it |
| --- | --- |
| `ingest.py` (or a notebook) | Downloads or reads the source and loads it into raw storage |
| `raw.sql` | Creates the raw table, with no constraints that could drop rows |
| `clean.sql` | Builds the cleaned table in the `clean` schema from the raw one |
| `notes.md` | Source URL, download date, files, size, row count, columns |

Never commit the data files or passwords. Downloads go in the top-level `data/` folder, which git ignores.
