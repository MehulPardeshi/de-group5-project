# NOAA daily weather raw load

Downloaded November 14, 2026 from [NOAA CDO v2](https://www.ncei.noaa.gov/cdo-web/webservices/v2). The run covers January 2025 through August 2026, the latest month in the [BTS flight-delay table](https://www.transtats.bts.gov/Homepage.asp) at the time of the load.

```sh
.venv/bin/python pipeline/noaa_weather/ingest.py --end 2026-08-31
```

Requests use the `/data` endpoint with `datasetid=GHCND`, one station and calendar month per window, `units=metric`, and up to 1,000 observations per page. The run requests all reported data types, including weather flags where available.

| Airport | GHCND station | JSON files | Bytes | Source observations | Atlas observations |
| --- | --- | ---: | ---: | ---: | ---: |
| ATL | USW00013874 | 20 | 706,351 | 6,266 | 6,266 |
| DFW | USW00003927 | 20 | 717,042 | 6,371 | 6,371 |
| JFK | USW00094789 | 20 | 729,047 | 6,457 | 6,457 |
| ORD | USW00094846 | 20 | 741,375 | 6,572 | 6,572 |
| PIT | USW00094823 | 20 | 735,153 | 6,534 | 6,534 |
| Total | | 100 | 3,628,968 | 32,200 | 32,200 |

The files are under `data/noaa_weather/` and use the pattern `AIRPORT_START_END_metric_OFFSET.json`. Each contains the original response bytes. Atlas stores one document per response in `de_group5.raw_noaa_daily`. Its SHA-256-based `_id` makes an identical response safe to reload. Each response contains `metadata.resultset` and a `results` array with `attributes`, `datatype`, `date`, `station`, and `value`. The loader reads each document back and compares its payload with the saved file before reporting counts.

## Profile and first cleaning

Run the profile and clean step after the raw load.

```sh
.venv/bin/python pipeline/noaa_weather/profile_and_clean.py
```

The script reads the Atlas copy of each saved response and checks it against the original file. It profiles the observations, then builds `clean.noaa_daily` in a PostgreSQL transaction. The table has one row per airport and date. Measurements without an observation stay NULL, and reported WT flags are stored as a JSON object.

The raw load contains 32,200 observations across 3,040 station-days. The checks found zero duplicate observation keys, invalid dates, nonnumeric values, negative precipitation, snow or wind values, and days with TMAX below TMIN. See the [data quality log](../../docs/data_quality_log.md) for the gaps and wind comparison.
