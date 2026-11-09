# Pipeline

One folder per dataset, so nobody edits the same files:

| Folder | Dataset | Owner |
| --- | --- | --- |
| [setup](setup) | Local PostgreSQL (Docker) and shared MongoDB Atlas | Mehul |
| [bts](bts) | BTS on-time flights | Sowmya |
| [noaa_weather](noaa_weather) | NOAA daily weather (JSON) | Yang |
| [storm_events](storm_events) | NOAA Storm Events | Joshua |
| [ourairports](ourairports) | OurAirports | Mehul |

**Layers** (the course requires raw data to be kept separate from cleaned data):
- `raw` schema in PostgreSQL, or a `raw_` collection: data exactly as downloaded. Load columns as text if types cause rows to fail.
- `clean` schema: typed, deduplicated, cleaned tables.
- Integrated and serving tables come in Milestone 3.

Log every data quality issue in [docs/data_quality_log.md](../docs/data_quality_log.md).
