# NOAA Storm Events

**Owner:** Joshua · **Issue:** [#49](https://github.com/MehulPardeshi/de-group5-project/issues/49) · **Stored in:** PostgreSQL `raw.storm_events_details`

## Start here (before Sat Nov 14 call, then raw load by Sun Nov 15)

1. **Setup (15 min):** follow [pipeline/setup](../setup/README.md). Done when `check_connections.py` prints `PostgreSQL OK`.
2. **Download:** from https://www.ncei.noaa.gov/pub/data/swdi/stormevents/csvfiles/ get the two `StormEvents_details-ftp_v1.0_d2025_c....csv.gz` and `..._d2026_c....csv.gz` files (the newest `c` date). Save them to `data/storm_events/` (git ignores `data/`).
3. **Write down** in `notes.md`: the URL, the download date, file names and sizes, row count, column names.
4. **Raw table and load:** `raw.sql` creates `raw.storm_events_details` with every column as TEXT. `ingest.py` loads the CSVs with COPY and checks the row count. This is the same pattern as `pipeline/ourairports/`.
5. **For the call, have ready:** is setup working? Are the files downloaded? Anything blocking you? You're also note-taker: the agenda is in the Google Doc's minutes tab.

**Stuck?** Say so in WhatsApp or on the call. Mehul's [ourairports](../ourairports) folder is a finished example of the same steps.

## Files in this folder


| File | What goes in it |
| --- | --- |
| `ingest.py` (or a notebook) | Downloads or reads the source and loads it into raw storage |
| `raw.sql` | Creates the raw table, with no constraints that could drop rows |
| `profile.sql` | Quality checks on the raw table (missing values, duplicates, bad formats). Results go in `docs/data_quality_log.md` |
| `clean.sql` | Builds the cleaned table in the `clean` schema from the raw one |
| `notes.md` | Source URL, download date, files, size, row count, columns |

Never commit the data files or passwords. Downloads go in the top-level `data/` folder, which git ignores.
