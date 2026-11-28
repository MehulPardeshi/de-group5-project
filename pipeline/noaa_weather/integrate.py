"""Build the six-airport daily weather indicators agreed in issue #76."""

import argparse
import json
from datetime import date
from pathlib import Path

import psycopg2
from dotenv import dotenv_values

from ingest import ROOT, STATIONS


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--start', type=date.fromisoformat, default=date(2025, 1, 1))
    parser.add_argument('--end', type=date.fromisoformat, default=date(2026, 8, 31))
    args = parser.parse_args()
    if args.end < args.start:
        parser.error('--end must be on or after --start')
    settings = dotenv_values(ROOT / '.env')
    with psycopg2.connect(
        host=settings['PGHOST'], port=settings['PGPORT'], dbname=settings['PGDATABASE'],
        user=settings['PGUSER'], password=settings['PGPASSWORD'],
    ) as connection, connection.cursor() as cursor:
        cursor.execute('''
            SELECT airport, station FROM clean.noaa_daily
            WHERE weather_date BETWEEN %s AND %s GROUP BY airport, station
        ''', (args.start, args.end))
        actual = set(cursor.fetchall())
        if actual != set(STATIONS.items()):
            raise RuntimeError(f'Clean station mapping differs: expected {STATIONS}, found {actual}')
        cursor.execute('''
            SELECT COUNT(*) FROM clean.noaa_daily
            WHERE weather_date BETWEEN %s AND %s AND
                  (weather_flags IS NULL OR jsonb_typeof(weather_flags) <> 'object')
        ''', (args.start, args.end))
        if cursor.fetchone()[0]:
            raise RuntimeError('Clean weather_flags must be JSON objects')
        cursor.execute(Path(__file__).with_suffix('.sql').read_text(), {
            'start': args.start, 'end': args.end, 'stations': json.dumps(STATIONS),
        })
        cursor.execute('SELECT COUNT(*) FROM integrated.noaa_daily')
        total = cursor.fetchone()[0]
        expected = len(STATIONS) * ((args.end - args.start).days + 1)
        if total != expected:
            raise RuntimeError(f'Expected {expected} integrated airport-days, found {total}')
        cursor.execute('''
            SELECT airport, COUNT(*),
                COUNT(*) FILTER (WHERE bad_weather = 'yes'),
                COUNT(*) FILTER (WHERE bad_weather = 'no'),
                COUNT(*) FILTER (WHERE bad_weather = 'unknown'),
                COUNT(*) FILTER (WHERE NOT source_day_present)
            FROM integrated.noaa_daily GROUP BY airport ORDER BY airport
        ''')
        print('airport | days | yes | no | unknown | no source day')
        for row in cursor.fetchall():
            print(' | '.join(map(str, row)))
        print(f'Integrated airport-days: {total}')


if __name__ == '__main__':
    main()
