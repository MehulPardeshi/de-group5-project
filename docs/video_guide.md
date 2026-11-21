# Milestone 2 video guide

The course asks for **one video, 5 minutes at most**, showing our data sources, ingestion and initial cleaning ([#20](https://github.com/MehulPardeshi/de-group5-project/issues/20)).

**Format (decided Nov 21):** voice-over only. The professor said faces are welcome but not graded. Each person sends Mehul **two things** for their part:
1. **Six screenshots** (or short screen recordings) of their own dataset, listed below
2. **Their own narration**, about 60 seconds, as an audio file (a phone voice memo or MP3 is fine)

Mehul puts the screenshots in order, lays the audio over them and joins the parts into one video.

**Team rule:** no AI tools for graded work, so **write and speak your own narration**. A few notes on paper in your own words is plenty. This page only says what to cover and for how long.

## Running order and timing (total 4:40, leaves 20 seconds spare)

| # | Part | Who | Length | Covers |
| --- | --- | --- | --- | --- |
| 1 | Intro | Mehul | 0:20 | Team and section, our question (how much flight delay is really caused by weather?), the four datasets |
| 2 | BTS on-time flights | Sowmya | 1:00 | The six points below |
| 3 | NOAA daily weather (JSON) | Henry | 1:00 | The six points below, plus why it's in MongoDB Atlas |
| 4 | NOAA Storm Events | Joshua | 1:00 | The six points below |
| 5 | OurAirports | Mehul | 1:00 | The six points below |
| 6 | Outro | Mehul | 0:20 | How the datasets connect (flights → airports by IATA code → weather and storms by place and date), and what's next for the final report |

Stay within your time: about **130–150 words** for 60 seconds at a normal pace. Time yourself once before recording.

## What your 60 seconds covers, with one screenshot each

| # | Point (about) | Screenshot | Sowmya, BTS | Henry, NOAA weather | Joshua, Storm Events | Mehul, OurAirports |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Where the data came from (5 s) | Source web page | BTS download page | NOAA CDO web services page | NCEI Storm Events CSV folder | ourairports.com/data |
| 2 | What the raw data looks like (10 s) | A few raw rows or one JSON document | First rows of one month's CSV | One JSON response page | First rows of the details CSV | First rows of `airports.csv` |
| 3 | How you loaded it (10 s) | Your script running, with its row count check | `ingest.py` output | `ingest.py` output: files and observations verified in Atlas | `ingest.py` output | `ingest.py`: 86,350 rows, "Row count matches CSV" |
| 4 | Where it's stored (10 s) | The raw table or collection | `raw.bts_on_time` in psql | `raw_noaa_daily` in the Atlas UI | `raw.storm_events_details` in psql | `raw.ourairports_airports` in psql |
| 5 | Quality problems (15 s) | One or two problems, with numbers | Your quality log rows | Missing measurements, empty WT flags, the DFW wind case | Your quality log rows | 30,673 US rows without IATA; territories fix |
| 6 | After cleaning (10 s) | The clean table and its count | `clean.bts_flights` and its count | `clean.noaa_daily`: 3,040 airport-days | Your clean table and its count | `clean.airports` funnel: 2,056 airports |

Also say in a sentence **why your dataset matters to our question**, and **why it's stored where it is** (PostgreSQL for tables, Atlas for the JSON).

## Recording tips

- Record somewhere quiet, phone about 20 cm from your mouth. One take is fine; small pauses are fine.
- Say your points in the same order as your screenshots, so Mehul can match them.
- Screenshots: Mac Cmd+Shift+4 (area) or Cmd+Shift+5 (recording); Windows Win+Shift+S. Make the terminal font big. Never show passwords, `.env` or the MongoDB link.
- Name files so they sort: `Sowmya_1_source.png` … `Sowmya_6_clean.png`, `Sowmya_voice.m4a`.

## Hand-in

Upload your six screenshots and your audio to one Google Drive folder, share it with Mehul, and post "done" on your dataset issue (#47–#50) by **Mon Nov 23, 12 pm**. Mehul shares the finished video by Mon 6 pm, and Sowmya submits by 9 pm (#21).
