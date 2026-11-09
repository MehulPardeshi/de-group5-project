# Shared setup

**Owner:** Mehul · **Issue:** [#13](https://github.com/MehulPardeshi/de-group5-project/issues/13)

## Storage choices
| Data | Where | Why |
| --- | --- | --- |
| Structured CSVs (BTS, Storm Events, OurAirports) | **PostgreSQL 16, run locally with Docker** (`docker-compose.yml`), schemas `raw` and `clean` | Tabular data that joins on airport code and date, so SQL is the natural fit. A year of BTS flights is several GB, more than free hosted Postgres allows. The managed cloud option (AWS RDS) was blocked on our account. Docker gives everyone an identical database from the same scripts, and the pipeline can be rebuilt from scratch anywhere. |
| NOAA weather API responses (JSON) | **MongoDB Atlas** (free cluster `de-group5`, database `de_group5`, collection `raw_noaa_daily`) | Keeps the API's JSON documents exactly as returned, nested fields and all. It's shared in the cloud, so the whole team reads the same raw copy, and it's small enough for the free 512 MB tier. Flattened results go into PostgreSQL `clean`. |

## One-time setup (about 15 minutes)
1. Install **Docker Desktop**: https://www.docker.com/products/docker-desktop/ and open it once.
2. In the repo folder: `cp .env.example .env`, then set any `PGPASSWORD` you like (it only exists on your laptop). Mehul sends the `MONGODB_URI` privately.
3. Start PostgreSQL: `docker compose up -d`. The first start runs `init.sql`, which creates the `raw` and `clean` schemas.
4. Python: `python3 -m venv .venv && .venv/bin/pip install -r requirements.txt`
5. Test it: `.venv/bin/python pipeline/setup/check_connections.py`

Stop the database with `docker compose down`. Your data is kept. `docker compose down -v` deletes it.

## How the combined database comes together
Each person loads their own dataset locally with their own scripts. For integration (Milestone 3), one machine runs every `ingest.py`, then every `clean.sql`, to build the full database. That's why every script must re-run cleanly from the raw download.
