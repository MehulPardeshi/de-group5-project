"""Check that PostgreSQL and MongoDB are reachable with the settings in .env."""
import os

import psycopg2
from dotenv import load_dotenv
from pymongo import MongoClient

load_dotenv()

with psycopg2.connect(
    host=os.environ["PGHOST"], port=os.environ["PGPORT"], dbname=os.environ["PGDATABASE"],
    user=os.environ["PGUSER"], password=os.environ["PGPASSWORD"],
) as conn, conn.cursor() as cur:
    cur.execute("SELECT schema_name FROM information_schema.schemata WHERE schema_name IN ('raw', 'clean') ORDER BY 1")
    schemas = [r[0] for r in cur.fetchall()]
    print(f"PostgreSQL OK, schemas: {schemas}")
    if schemas != ["clean", "raw"]:
        raise SystemExit("Missing schemas: run `docker compose down -v && docker compose up -d` to re-run init.sql")

uri = os.environ.get("MONGODB_URI")
if uri:
    MongoClient(uri, serverSelectionTimeoutMS=8000).admin.command("ping")
    print("MongoDB Atlas OK")
else:
    print("MONGODB_URI not set (only needed for the NOAA weather data)")
