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

## Denver extension, November 24, 2026 (#99)

The [NOAA station endpoint](https://www.ncei.noaa.gov/cdo-web/api/v2/stations/GHCND:USW00003017) identifies `GHCND:USW00003017` as Denver International Airport, Colorado (39.84657, -104.65623; elevation 1,647.2 m). Its record starts July 1, 1994. It covers the full study period and matches DEN, rather than Denver's older airport. NOAA's [station inventory](https://www.ncei.noaa.gov/pub/data/ghcn/daily/ghcnd-stations.txt) is a second source for this mapping. These are the station details needed by Mehul's bridge in #98, which is still pending.

```sh
.venv/bin/python pipeline/noaa_weather/ingest.py --airports DEN --end 2026-08-31
```

| Added airport | GHCND station | JSON files | Bytes | Source observations | Atlas observations | Airport-days |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| DEN | USW00003017 | 20 | 719,989 | 6,419 | 6,419 | 608 |

The existing five-airport snapshots are unchanged. The combined raw input now has 120 response files, 4,348,957 bytes and 38,619 observations. Raw JSON remains in `data/noaa_weather/` and Atlas `de_group5.raw_noaa_daily`, separate from the clean and integrated tables.

Denver has one missing SNOW reading, seven missing SNWD readings, two missing WSF5 readings, and 405 days without reported WT flags. No Denver records have a nonblank NOAA quality flag. On August 20, 2026, WSF5 is 10.3 m/s while WSF2 is 12.1 m/s. Both remain as reported; the reason is unverified. Snow depth does not enter the team's bad-weather rule.

The six-airport profile finds no duplicate observation keys, invalid dates, invalid numeric values, negative rain/snow/wind measurements or TMAX below TMIN. Missing measurements total PRCP 2, SNOW 19, SNWD 315, AWND 2, WSF2 2 and WSF5 11; counts overlap. There are 2,188 days without reported WT flags and two WSF5-below-WSF2 cases including the existing DFW case.

The clean rebuild now preserves the table object. The old DROP/CREATE approach failed because a local analysis view depended on it; PostgreSQL rolled back that failed attempt. The replacement refreshes the contents transactionally without dropping the view. Run commands and classification rules are in [README.md](README.md).

The verified rebuild has 3,648 clean rows and 3,648 integrated rows, 608 per airport, with no absent source days. Two integration runs returned the same counts:

| Airport | Days | Bad weather: yes | No | Unknown |
| --- | ---: | ---: | ---: | ---: |
| ATL | 608 | 273 | 329 | 6 |
| DEN | 608 | 267 | 339 | 2 |
| DFW | 608 | 196 | 408 | 4 |
| JFK | 608 | 290 | 317 | 1 |
| ORD | 608 | 280 | 328 | 0 |
| PIT | 608 | 283 | 325 | 0 |
| Total | 3,648 | 1,589 | 2,046 | 13 |
