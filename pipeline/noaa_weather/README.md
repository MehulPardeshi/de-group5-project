# NOAA daily weather (JSON)

**Owner:** Yang · **Issue:** [#48](https://github.com/MehulPardeshi/de-group5-project/issues/48) · **Stored in:** MongoDB Atlas (`de_group5.raw_noaa_daily`), flattened into PostgreSQL `clean.noaa_daily`

## Start here (before Sat Nov 14 call, then raw load by Sun Nov 15)

1. **Setup (15 min):** follow [pipeline/setup](../setup/README.md). Put the MongoDB link Mehul sent you in `.env` as `MONGODB_URI="..."`. Done when `check_connections.py` prints both `PostgreSQL OK` and `MongoDB Atlas OK`.
2. **NOAA token:** request a free token at https://www.ncei.noaa.gov/cdo-web/token. It arrives by email. Put it in `.env` as `NOAA_TOKEN=...`.
3. **Pick the stations:** start with **5 big airports** (ATL, ORD, DFW, JFK, PIT). The coordinates are in `clean.airports` on Mehul's database, or ask Mehul. Find each airport's GHCND station with the CDO `stations` endpoint.
4. **Fetch and store:** request dataset `GHCND` for Jan 2025 onward. Store each JSON response **exactly as returned** in MongoDB `de_group5.raw_noaa_daily`. The API returns at most 1,000 results per call, so page through with `offset`. It allows 5 calls per second and 10,000 per day.
5. **Write down** in `notes.md`: the API URL, parameters, stations, date range, number of documents.
6. **For the call, have ready:** is setup working? Has the token arrived? Have you made a first successful API call?

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
