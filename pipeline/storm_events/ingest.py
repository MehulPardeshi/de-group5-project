import csv
import gzip
import os
import re
from pathlib import Path

import psycopg2
from dotenv import load_dotenv

DATA_DIR = Path("data/storm_events")
TABLE = "raw.storm_events_details"
FILE_PATTERN = re.compile(r"StormEvents_details-ftp_v1\.0_d(\d{4})_c(\d{8})\.csv\.gz$")


def get_connection():
    load_dotenv()
    return psycopg2.connect(
        host=os.environ["PGHOST"],
        port=os.environ["PGPORT"],
        dbname=os.environ["PGDATABASE"],
        user=os.environ["PGUSER"],
        password=os.environ["PGPASSWORD"],
    )


def find_files(data_dir):
    """Return one file per year. If a year has several downloads, keep the newest (highest c date)."""
    newest = {}
    for path in sorted(data_dir.glob("StormEvents_details-*.csv.gz")):
        match = FILE_PATTERN.search(path.name)
        if match:
            year, created = match.groups()
            if year not in newest or created > newest[year][0]:
                newest[year] = (created, path)
    if not newest:
        raise FileNotFoundError(f"No StormEvents_details files found in {data_dir}")
    return [newest[year][1] for year in sorted(newest)]


def count_csv_rows(path):
    # Count CSV records, not lines: the narrative columns contain line breaks.
    with gzip.open(path, "rt", encoding="utf-8", newline="") as file:
        reader = csv.reader(file)
        next(reader)
        return sum(1 for row in reader)


def load_raw(conn, paths):
    sql_path = Path(__file__).with_name("raw.sql")

    with conn.cursor() as cur:
        with open(sql_path, "r", encoding="utf-8") as file:
            cur.execute(file.read())

        cur.execute(f"TRUNCATE TABLE {TABLE}")

        for path in paths:
            with gzip.open(path, "rt", encoding="utf-8", newline="") as file:
                cur.copy_expert(
                    f"COPY {TABLE} FROM STDIN WITH (FORMAT CSV, HEADER TRUE)",
                    file,
                )

    conn.commit()


def check_row_count(conn, expected):
    with conn.cursor() as cur:
        cur.execute(f"SELECT COUNT(*) FROM {TABLE}")
        actual = cur.fetchone()[0]

    if actual != expected:
        raise RuntimeError(f"Expected {expected} rows, but found {actual} rows")


if __name__ == "__main__":
    files = find_files(DATA_DIR)
    conn = get_connection()
    try:
        total = 0
        for path in files:
            rows = count_csv_rows(path)
            print(f"{path.name}: {rows} rows")
            total += rows
        load_raw(conn, files)
        check_row_count(conn, total)
        print(f"Loaded {total} rows into {TABLE}. Row count matches CSV.")
    finally:
        conn.close()
