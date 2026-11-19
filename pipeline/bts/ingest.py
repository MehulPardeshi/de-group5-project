"""Load the BTS on-time CSVs into raw.bts_on_time.

Put the monthly downloads in data/bts/ (git ignores data/). Each month can be
either the zip from https://www.transtats.bts.gov/PREZIP/ or the CSV inside it.
Zips are read directly, so there is no need to unzip 4.9 GB first.

Usage (run from the repo root):
    python pipeline/bts/ingest.py           # reload every month (TRUNCATEs first)
    python pipeline/bts/ingest.py 2025_1    # reload only January 2025

Both are safe to re-run: old rows for the month(s) being loaded are removed first.
"""
import os
import re
import sys
import zipfile
from pathlib import Path

import psycopg2
from dotenv import load_dotenv

DATA_DIR = Path("data/bts")
TABLE = "raw.bts_on_time"
# Jan 2025 - Aug 2026, counted from the 20 files downloaded on Nov 14, 2026.
EXPECTED_TOTAL_ROWS = 11_730_351
MONTH_PATTERN = re.compile(r"(\d{4}_\d{1,2})\.(zip|csv)$")


def get_connection():
    load_dotenv()
    return psycopg2.connect(
        host=os.environ["PGHOST"],
        port=os.environ["PGPORT"],
        dbname=os.environ["PGDATABASE"],
        user=os.environ["PGUSER"],
        password=os.environ["PGPASSWORD"]
    )


def find_files(month=None):
    """Return {month: path}, e.g. {"2025_1": Path(...zip)}, sorted by date."""
    files = {}
    for path in DATA_DIR.glob("*"):
        match = MONTH_PATTERN.search(path.name)
        if not match:
            continue
        key = match.group(1)
        # Prefer the CSV if both the zip and the unzipped CSV are present.
        if key not in files or path.suffix == ".csv":
            files[key] = path

    if month:
        if month not in files:
            raise FileNotFoundError(f"No file for {month} in {DATA_DIR}/")
        files = {month: files[month]}

    def sort_key(key):
        year, mon = key.split("_")
        return int(year), int(mon)

    return {key: files[key] for key in sorted(files, key=sort_key)}


class LineCounter:
    """Wraps a file and counts newlines while COPY reads it."""

    def __init__(self, file):
        self.file = file
        self.lines = 0

    def read(self, size=-1):
        chunk = self.file.read(size)
        self.lines += chunk.count(b"\n")
        return chunk

    def readline(self, size=-1):
        line = self.file.readline(size)
        self.lines += line.count(b"\n")
        return line


def open_csv(path):
    if path.suffix == ".zip":
        archive = zipfile.ZipFile(path)
        csv_name = next(n for n in archive.namelist() if n.endswith(".csv"))
        return archive.open(csv_name), csv_name
    return open(path, "rb"), path.name


def load_file(cur, path):
    """COPY one month in and return the number of data rows in the CSV."""
    stream, csv_name = open_csv(path)
    # Tag every row with its source file. Setting a column default is much
    # faster than running an UPDATE on half a million rows afterwards.
    cur.execute(
        f"ALTER TABLE {TABLE} ALTER COLUMN source_file SET DEFAULT %s",
        (csv_name,)
    )
    counter = LineCounter(stream)
    try:
        # The column list leaves out source_file and loaded_at, so they get
        # their defaults. Unquoted blanks become NULL; quoted "" stays ''.
        cur.copy_expert(
            f"COPY {TABLE} ({column_list(cur)}) "
            "FROM STDIN WITH (FORMAT CSV, HEADER TRUE)",
            counter
        )
    finally:
        stream.close()
    return counter.lines - 1, csv_name  # minus the header line


_columns = None


def column_list(cur):
    global _columns
    if _columns is None:
        cur.execute(
            """
            SELECT column_name FROM information_schema.columns
            WHERE table_schema = 'raw' AND table_name = 'bts_on_time'
              AND column_name NOT IN ('source_file', 'loaded_at')
            ORDER BY ordinal_position
            """
        )
        _columns = ", ".join(row[0] for row in cur.fetchall())
    return _columns


def main():
    month = sys.argv[1] if len(sys.argv) > 1 else None
    files = find_files(month)
    if not files:
        raise FileNotFoundError(f"No BTS zip or CSV files found in {DATA_DIR}/")

    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(Path(__file__).with_name("raw.sql").read_text())

            if month is None:
                cur.execute(f"TRUNCATE TABLE {TABLE}")

            expected = 0
            for key, path in files.items():
                if month is not None:
                    # Only replace this month's rows.
                    cur.execute(
                        f"DELETE FROM {TABLE} WHERE source_file LIKE %s",
                        (f"%\\_{key}.csv",)
                    )
                rows, csv_name = load_file(cur, path)
                expected += rows
                print(f"{key}: {rows:,} rows from {csv_name}")

            cur.execute(f"ALTER TABLE {TABLE} ALTER COLUMN source_file DROP DEFAULT")

            if month is None:
                cur.execute(f"SELECT COUNT(*) FROM {TABLE}")
            else:
                cur.execute(
                    f"SELECT COUNT(*) FROM {TABLE} WHERE source_file LIKE %s",
                    (f"%\\_{month}.csv",)
                )
            actual = cur.fetchone()[0]

        if actual != expected:
            raise RuntimeError(f"CSV has {expected:,} rows but the table has {actual:,}")
        # Everything is committed together, so a failed run leaves the old data in place.
        conn.commit()
    finally:
        conn.close()

    print(f"Loaded {actual:,} rows into {TABLE}. Row count matches the CSV files.")
    if month is None and actual != EXPECTED_TOTAL_ROWS:
        print(f"Warning: expected {EXPECTED_TOTAL_ROWS:,} rows for all 20 months. "
              f"Found {len(files)} files; check that none are missing.")


if __name__ == "__main__":
    main()
