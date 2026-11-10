import csv
import os
from pathlib import Path

import psycopg2
from dotenv import load_dotenv

CSV_PATH = Path("data/ourairports/airports.csv")
TABLE = "raw.ourairports_airports"


def get_connection():
    load_dotenv()
    return psycopg2.connect(
        host=os.environ["PGHOST"],
        port=os.environ["PGPORT"],
        dbname=os.environ["PGDATABASE"],
        user=os.environ["PGUSER"],
        password=os.environ["PGPASSWORD"]
    )


def count_csv_rows(path):
    with open(path, "r", encoding="utf-8", newline="") as file:
        reader = csv.reader(file)
        next(reader)
        return sum(1 for row in reader)


def load_raw(conn, path):
    sql_path = Path(__file__).with_name("raw.sql")

    with conn.cursor() as cur:
        with open(sql_path, "r", encoding="utf-8") as file:
            cur.execute(file.read())

        cur.execute(f"TRUNCATE TABLE {TABLE}")

        with open(path, "r", encoding="utf-8", newline="") as file:
            cur.copy_expert(
                f"COPY {TABLE} FROM STDIN WITH (FORMAT CSV, HEADER TRUE)",
                file
            )

    conn.commit()


def check_row_count(conn, expected):
    with conn.cursor() as cur:
        cur.execute(f"SELECT COUNT(*) FROM {TABLE}")
        actual = cur.fetchone()[0]

    if actual != expected:
        raise RuntimeError(f"Expected {expected} rows, but found {actual} rows")


if __name__ == "__main__":
    conn = get_connection()
    try:
        expected = count_csv_rows(CSV_PATH)
        load_raw(conn, CSV_PATH)
        check_row_count(conn, expected)
        print(f"Loaded {expected} rows into {TABLE}. Row count matches CSV.")
    finally:
        conn.close()
