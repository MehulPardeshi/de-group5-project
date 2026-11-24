"""Save NOAA CDO response pages and reconcile them with the raw Atlas collection."""

import argparse
import calendar
import hashlib
import json
import time
from datetime import date
from pathlib import Path

import requests
from dotenv import dotenv_values
from pymongo import MongoClient
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

ROOT = Path(__file__).resolve().parents[2]
BASE_URL = "https://www.ncei.noaa.gov/cdo-web/api/v2"
STATIONS = {
    "ATL": "GHCND:USW00013874",
    "DEN": "GHCND:USW00003017",
    "DFW": "GHCND:USW00003927",
    "JFK": "GHCND:USW00094789",
    "ORD": "GHCND:USW00094846",
    "PIT": "GHCND:USW00094823",
}
PAGE_SIZE = 1000


def fetch_json(session, endpoint, params):
    time.sleep(0.25)
    response = session.get(f"{BASE_URL}/{endpoint}", params=params, timeout=(10, 60))
    response.raise_for_status()
    return response.content, response.json()


def months(start, end):
    current = start
    while current <= end:
        last_day = calendar.monthrange(current.year, current.month)[1]
        yield current, min(end, current.replace(day=last_day))
        current = (current.replace(day=last_day) + date.resolution)


def pages(session, station, start, end):
    offset = 1
    expected = None
    while True:
        params = {
            "datasetid": "GHCND",
            "stationid": station,
            "startdate": start.isoformat(),
            "enddate": end.isoformat(),
            "units": "metric",
            "limit": PAGE_SIZE,
            "offset": offset,
        }
        content, payload = fetch_json(session, "data", params)
        records = payload.get("results", [])
        if not records and offset == 1 and not payload:
            return
        resultset = payload["metadata"]["resultset"]
        count = resultset["count"]
        if expected is None:
            expected = count
        if count != expected or resultset["offset"] != offset or offset - 1 + len(records) > count:
            raise RuntimeError(f"NOAA returned inconsistent pagination for {station} in {start:%Y-%m}")
        if not records:
            if count == 0:
                return
            raise RuntimeError(f"NOAA returned an empty page for {station} at offset {offset}")
        yield offset, content, payload
        offset += len(records)
        if offset > count:
            return


def load_airport(session, collection, output, airport, start, end):
    file_count = source_count = stored_count = total_bytes = 0
    fields = set()
    for first, last in months(start, end):
        for offset, content, payload in pages(session, STATIONS[airport], first, last):
            filename = f"{airport}_{first}_{last}_metric_{offset:05d}.json"
            path = output / filename
            temporary = path.with_suffix(".tmp")
            temporary.write_bytes(content)
            temporary.replace(path)
            # A content hash makes an identical download safe to replay.
            document_id = hashlib.sha256(content).hexdigest()
            document = {"_id": document_id, **payload}
            collection.replace_one({"_id": document_id}, document, upsert=True)
            stored = collection.find_one({"_id": document_id}, {"_id": False})
            if stored != json.loads(path.read_bytes()):
                raise RuntimeError(f"Stored JSON differs from {filename}")
            file_count += 1
            total_bytes += len(content)
            source_count += len(payload["results"])
            stored_count += len(stored["results"])
            for observation in payload["results"]:
                fields.update(observation)
    print(f"{airport}: {file_count} files, {total_bytes} bytes, "
          f"{source_count} source observations, {stored_count} verified in Atlas")
    return file_count, total_bytes, source_count, stored_count, fields


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--start", type=date.fromisoformat, default=date(2025, 1, 1))
    parser.add_argument("--end", type=date.fromisoformat, required=True, help="Last BTS date (YYYY-MM-DD)")
    parser.add_argument("--airports", nargs="+", choices=STATIONS, default=list(STATIONS))
    args = parser.parse_args()
    if args.start > args.end:
        parser.error("--start must be on or before --end")
    settings = dotenv_values(ROOT / ".env")
    if not settings.get("NOAA_TOKEN") or not settings.get("MONGODB_URI"):
        parser.error("Set NOAA_TOKEN and MONGODB_URI in the repo's .env")
    output = ROOT / "data" / "noaa_weather"
    output.mkdir(parents=True, exist_ok=True)
    retry = Retry(total=4, backoff_factor=1, status_forcelist=(429, 500, 502, 503, 504))
    fields = set()
    totals = [0, 0, 0, 0]
    with requests.Session() as session, MongoClient(
        settings["MONGODB_URI"], serverSelectionTimeoutMS=10_000
    ) as client:
        session.headers["token"] = settings["NOAA_TOKEN"]
        session.mount("https://", HTTPAdapter(max_retries=retry))
        collection = client.de_group5.raw_noaa_daily
        for airport in dict.fromkeys(args.airports):
            *counts, airport_fields = load_airport(session, collection, output, airport, args.start, args.end)
            totals = [total + count for total, count in zip(totals, counts)]
            fields.update(airport_fields)
    files, size, source, stored = totals
    print(f"Total: {files} files, {size} bytes, {source} source observations, {stored} verified in Atlas")
    print("Observation fields:", ", ".join(sorted(fields)))


if __name__ == "__main__":
    main()
