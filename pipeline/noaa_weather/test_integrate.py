"""Exercise the integration SQL in temporary tables; roll back every test row."""

import json
import unittest
from datetime import date, timedelta
from pathlib import Path

import psycopg2
from dotenv import dotenv_values
from psycopg2.extras import Json, execute_values

from ingest import ROOT


class WeatherRuleTest(unittest.TestCase):
    def test_thresholds_missingness_flags_and_rerun(self):
        settings = dotenv_values(ROOT / '.env')
        connection = psycopg2.connect(
            host=settings['PGHOST'], port=settings['PGPORT'], dbname=settings['PGDATABASE'],
            user=settings['PGUSER'], password=settings['PGPASSWORD'],
        )
        try:
            with connection.cursor() as cursor:
                cursor.execute('''CREATE TEMP TABLE test_noaa_clean (
                    airport text, station text, weather_date date, precipitation_mm float,
                    snowfall_mm float, fastest_five_second_wind_mps float, weather_flags jsonb
                )''')
                cases = [
                    (12.699, 25.399, 17.899, {}, 'no'),
                    (12.7, 0, 0, {}, 'yes'),
                    (0, 25.4, 0, {}, 'yes'),
                    (0, 0, 17.9, {}, 'yes'),
                    (None, 0, 0, {}, 'unknown'),
                    (0, None, 0, {}, 'unknown'),
                    (0, 0, None, {}, 'unknown'),
                    (12.7, None, None, {}, 'yes'),
                    (None, None, None, {'WT03': 1}, 'yes'),
                    (0, 0, 0, {'WT03': 0}, 'no'),
                    (0, 0, 0, {'WT08': 1}, 'no'),
                    *[(0, 0, 0, {flag: 1}, 'yes') for flag in
                      ('WT01', 'WT02', 'WT03', 'WT17', 'WT21', 'WT22')],
                ]
                start = date(2025, 1, 1)
                execute_values(cursor, 'INSERT INTO test_noaa_clean VALUES %s', [
                    ('TEST', 'TEST_STATION', start + timedelta(days=i), rain, snow, wind, Json(flags))
                    for i, (rain, snow, wind, flags, _) in enumerate(cases)
                ])
                sql = Path(__file__).with_name('integrate.sql').read_text()
                sql = sql.replace('clean.noaa_daily', 'test_noaa_clean')
                sql = sql.replace('integrated.noaa_daily', 'test_noaa_integrated')
                sql = sql.replace('CREATE TABLE IF NOT EXISTS test_noaa_integrated',
                                  'CREATE TEMP TABLE IF NOT EXISTS test_noaa_integrated')
                params = {'start': start, 'end': start + timedelta(days=len(cases)),
                          'stations': json.dumps({'TEST': 'TEST_STATION'})}
                expected = [case[-1] for case in cases] + ['unknown']
                for _ in range(2):
                    cursor.execute(sql, params)
                    cursor.execute('SELECT bad_weather FROM test_noaa_integrated ORDER BY weather_date')
                    self.assertEqual([row[0] for row in cursor.fetchall()], expected)
                cursor.execute('SELECT source_day_present FROM test_noaa_integrated ORDER BY weather_date DESC LIMIT 1')
                self.assertFalse(cursor.fetchone()[0])
        finally:
            connection.rollback()
            connection.close()


if __name__ == '__main__':
    unittest.main()
