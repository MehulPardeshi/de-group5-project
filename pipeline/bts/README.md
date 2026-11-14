# BTS on-time flights

**Owner:** Sowmya · **Issue:** [#47](https://github.com/MehulPardeshi/de-group5-project/issues/47) · **Stored in:** PostgreSQL `raw.bts_on_time`

## Start here (before Sat Nov 14 call, then raw load by Sun Nov 15)

1. **Setup (15 min):** follow [pipeline/setup](../setup/README.md). Done when `check_connections.py` prints `PostgreSQL OK`.
2. **Download one month first:** on the [BTS download page](https://www.transtats.bts.gov/DL_SelectFields.aspx?gnoyr_VQ=FGJ), get **January 2025** (one zip is about 500-600k flights). Save it to `data/bts/` (git ignores `data/`). Once one month loads, get the rest (Jan 2025 to the latest month).
3. **Write down** in `notes.md`: the URL, the download date, file names and sizes, row count, column names.
4. **Raw table and load:** `raw.sql` creates `raw.bts_on_time` with every column as TEXT. `ingest.py` loads the CSV with COPY and checks the row count. This is the same pattern as `pipeline/ourairports/`.
5. **For the call, have ready:** is setup working? Is the data downloaded? Anything blocking you?

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
