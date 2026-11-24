# Pipeline

One folder per dataset, so nobody edits the same files. Each owner keeps working in their own folder in Milestone 3.

| Folder | Dataset | Owner | Milestone 2 | Milestone 3 piece |
| --- | --- | --- | --- | --- |
| [setup](setup) | Local PostgreSQL (Docker) and shared MongoDB Atlas | Mehul | Done | Add `integrated` and `serving` schemas ([#98](https://github.com/MehulPardeshi/de-group5-project/issues/98)) |
| [bts](bts) | BTS on-time flights | Sowmya | Done | Daily rates by airport and airline ([#101](https://github.com/MehulPardeshi/de-group5-project/issues/101)) |
| [noaa_weather](noaa_weather) | NOAA daily weather (JSON) | Henry | Done | Add Denver, daily bad-weather flag ([#99](https://github.com/MehulPardeshi/de-group5-project/issues/99)) |
| [storm_events](storm_events) | NOAA Storm Events | Joshua | Done | Daily severe-weather flag for ORD, DEN, ATL ([#100](https://github.com/MehulPardeshi/de-group5-project/issues/100)) |
| [ourairports](ourairports) | OurAirports | Mehul | Done | Airport bridge to weather stations, counties and zones ([#98](https://github.com/MehulPardeshi/de-group5-project/issues/98)) |
| [serving](serving) | Tables the analysis reads from | Mehul | — | Serving tables ([#23](https://github.com/MehulPardeshi/de-group5-project/issues/23)) |

The analysis for each research question lives in [analysis/](../analysis).

## Layers

| Schema | What's in it | Milestone |
| --- | --- | --- |
| `raw` (PostgreSQL) or `raw_` collection (MongoDB) | Data exactly as downloaded. The course requires raw to stay separate from clean. | 2 |
| `clean` | Typed, deduplicated, cleaned tables, one dataset each | 2 |
| `integrated` | Datasets linked by airport and date, with the daily flags and rates from #98–#101 | 3 |
| `serving` | The tables the four questions are answered from (#23) | 3 |

Start every script with `CREATE SCHEMA IF NOT EXISTS ...`, because databases created before Milestone 3 won't rerun `setup/init.sql`.

## Rebuilding the whole database on one machine

For the serving tables (#23), one machine runs every script from scratch. Each owner keeps their own folder's README accurate about how to run it. The order is:

1. `setup`: `docker compose up -d`, then `check_connections.py`
2. Each dataset, in any order: download into `data/<dataset>/`, then `raw.sql` → `ingest.py` → `clean.sql` (NOAA: `ingest.py` → `profile_and_clean.py`)
3. `ourairports` bridge (#98)
4. Each dataset's integration script (#99, #100, #101)
5. `serving` (#23)

Owners: when you add an integration script, add its exact run command to your folder's README.

Log every data quality issue in [docs/data_quality_log.md](../docs/data_quality_log.md).
