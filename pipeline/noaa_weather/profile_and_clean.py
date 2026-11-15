"""Verify NOAA snapshots against Atlas, profile observations, and rebuild clean.noaa_daily."""

import hashlib
import json
import math
from collections import Counter, defaultdict
from datetime import datetime
from pathlib import Path

import psycopg2
from dotenv import dotenv_values
from psycopg2.extras import execute_values
from pymongo import MongoClient

from ingest import ROOT, STATIONS

METRICS = ("PRCP", "SNOW", "SNWD", "AWND", "WSF2", "WSF5", "TMAX", "TMIN")
NONNEGATIVE = set(METRICS) - {"TMAX", "TMIN"}
FIELDS = ("station", "date", "datatype", "value", "attributes")


def raw_rows(collection):
    output = ROOT / "data" / "noaa_weather"
    paths = sorted(output.glob("*.json"))
    if not paths:
        raise RuntimeError("Run NOAA ingestion before cleaning")
    for path in paths:
        airport = path.name.split("_", 1)[0]
        content = path.read_bytes()
        document_id = hashlib.sha256(content).hexdigest()
        payload = collection.find_one({"_id": document_id}, {"_id": False})
        if payload != json.loads(content):
            raise RuntimeError(f"Atlas payload differs from {path.name}")
        for observation in payload["results"]:
            yield airport, observation


def profile(rows):
    issues = Counter()
    observations = {}
    expected_days = set()
    for airport, row in rows:
        if any(row.get(field) in (None, "") for field in FIELDS):
            issues["missing raw field"] += 1
        station, datatype, value = (row.get(field) for field in ("station", "datatype", "value"))
        try:
            day = datetime.fromisoformat(row.get("date")).date()
        except (ValueError, TypeError):
            issues["invalid date"] += 1
            continue
        if station != STATIONS[airport] or not isinstance(datatype, str) or not datatype:
            issues["invalid station or datatype"] += 1
            continue
        expected_days.add((airport, station, day))
        key = (airport, station, day, datatype)
        if type(value) not in (int, float) or not math.isfinite(value):
            issues["invalid numeric value"] += 1
            value = None
        elif datatype in NONNEGATIVE and value < 0:
            issues["negative precipitation, snow or wind"] += 1
            value = None
        if key in observations:
            issues["duplicate observation key"] += 1
            if observations[key] != value:
                raise RuntimeError(f"Conflicting NOAA observations for {key}")
        observations[key] = value

    by_day = defaultdict(dict)
    for (airport, station, day, datatype), value in observations.items():
        by_day[airport, station, day][datatype] = value
    print("Raw observations:", len(rows))
    print("Station-days:", len(expected_days))
    for label in (
        "missing raw field", "invalid date", "invalid station or datatype",
        "invalid numeric value", "negative precipitation, snow or wind", "duplicate observation key",
    ):
        print(f"{label}: {issues[label]}")
    for datatype in METRICS:
        print(f"Missing {datatype}: {sum(day.get(datatype) is None for day in by_day.values())}")
    print("Station-days without reported WT flags:",
          sum(not any(key.startswith("WT") for key in day) for day in by_day.values()))
    print("TMAX below TMIN:", sum(
        day["TMAX"] < day["TMIN"] for day in by_day.values()
        if day.get("TMAX") is not None and day.get("TMIN") is not None
    ))
    print("WSF5 below WSF2:", sum(
        day["WSF5"] < day["WSF2"] for day in by_day.values()
        if day.get("WSF5") is not None and day.get("WSF2") is not None
    ))
    return [(*key, value) for key, value in observations.items()], len(expected_days)


def main():
    settings = dotenv_values(ROOT / ".env")
    with MongoClient(settings["MONGODB_URI"], serverSelectionTimeoutMS=10000) as mongo:
        rows = list(raw_rows(mongo.de_group5.raw_noaa_daily))
    observations, expected_days = profile(rows)
    with psycopg2.connect(
        host=settings["PGHOST"], port=settings["PGPORT"], dbname=settings["PGDATABASE"],
        user=settings["PGUSER"], password=settings["PGPASSWORD"],
    ) as connection, connection.cursor() as cursor:
        cursor.execute("""
            CREATE TEMP TABLE noaa_observations (
                airport text, station text, observation_date date, datatype text, value double precision
            ) ON COMMIT DROP
        """)
        execute_values(cursor, "INSERT INTO noaa_observations VALUES %s", observations, page_size=1000)
        cursor.execute(Path(__file__).with_name("clean.sql").read_text())
        cursor.execute("""
            SELECT airport, COUNT(*), MIN(weather_date), MAX(weather_date),
                   COUNT(*) FILTER (WHERE fastest_five_second_wind_mps IS NULL)
            FROM clean.noaa_daily GROUP BY airport ORDER BY airport
        """)
        counts = cursor.fetchall()
        total = sum(row[1] for row in counts)
        if total != expected_days:
            raise RuntimeError(f"Expected {expected_days} clean station-days, found {total}")
        print(f"Clean PostgreSQL rows: {total}")
        for airport, count, first, last, missing_wind in counts:
            print(f"{airport}: {count} days, {first} to {last}, {missing_wind} missing WSF5")


if __name__ == "__main__":

    main()
