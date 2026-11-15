# Milestone 2 video guide

The course asks for **one 5-minute video** showing our data sources, ingestion and initial cleaning. Each dataset owner records about **1 minute** of their own dataset, and Joshua joins the clips ([#20](https://github.com/MehulPardeshi/de-group5-project/issues/20)).

This page lists **what to show**, not what to say. Under our team rule (no AI tools for graded work), everyone writes and speaks their own narration. A few notes on paper in your own words is plenty.

## What the course wants to see (in every clip)

1. **Where the data came from:** the source website
2. **Examples of the data:** a few raw rows or one JSON document
3. **How you ingested it:** your script running, or its code
4. **Where it's stored:** the raw table or collection in PostgreSQL or MongoDB Atlas
5. **Data quality:** one or two problems you found, with the numbers
6. **After cleaning:** the clean table and its row count

## Shot list per person (about 60 seconds each)

| # | Show | Sowmya, BTS | Henry, NOAA weather | Joshua, Storm Events | Mehul, OurAirports |
| --- | --- | --- | --- | --- | --- |
| 1 | Source page (~5 s) | BTS download page | NOAA CDO web services page | NCEI Storm Events CSV folder | ourairports.com/data |
| 2 | Raw data (~10 s) | First rows of one month's CSV | One JSON response page | First rows of the details CSV | First rows of `airports.csv` |
| 3 | Ingestion (~10 s) | `ingest.py` running, row count check | `ingest.py` output: files and observations verified in Atlas | `ingest.py` running, row count check | `ingest.py`: 86,350 rows, "Row count matches CSV" |
| 4 | Storage (~10 s) | `raw.bts_on_time` in psql | `raw_noaa_daily` in the Atlas UI | `raw.storm_events_details` in psql | `raw.ourairports_airports` in psql |
| 5 | Quality (~15 s) | Your quality log rows | Missing measurements, empty WT flags, the DFW wind case | Your quality log rows | 30,673 US rows without IATA; territories fix |
| 6 | Clean result (~10 s) | Your clean table and count | `clean.noaa_daily`: 3,040 airport-days | Your clean table and count | `clean.airports` funnel: 2,056 airports |

Also say in a sentence **why your dataset matters to our question** (how much flight delay is really caused by weather), and **why it's stored where it is** (PostgreSQL for tables, Atlas for the JSON).

## Joshua's intro and outro (about 30 seconds in total)

- **Intro:** team and section, the question, the four datasets on one screen
- **Outro:** how the datasets connect (flights → airports by IATA code → weather and storms by location and date), and what comes next in Milestone 3

Suggested clip order: BTS → NOAA weather → Storm Events → OurAirports. Total: about 4:30 to 5:00.

## How to record

- **Mac:** Cmd+Shift+5 → "Record Entire Screen" or "Record Selected Portion" → Options → choose your microphone.
- **Windows:** Win+Alt+R (Xbox Game Bar), or Snipping Tool → Record.
- Make the terminal or editor font big (Cmd/Ctrl and +) so text is readable in the final video.
- Close anything showing passwords, `.env` or the MongoDB link before recording.
- Aim for 60-70 seconds. Joshua can trim, but can't add what's missing.

## Hand-in

Upload the clip to Google Drive, name it `M2_<dataset>_<name>.mov` (or `.mp4`), share it with Joshua, and post the link on your issue by **Fri Nov 20**.
