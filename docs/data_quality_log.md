# Data quality log

Everyone adds a row for every problem found while profiling or cleaning their dataset. The course asks for this record, and it feeds the Milestone 2 PDF and the final presentation.

**Severity:** *critical* means the pipeline should stop with a clear error. *Recoverable* means we fix, exclude or document it.

| Dataset | Issue found | Rows affected | Severity | How we handled it | Owner | Date |
| --- | --- | --- | --- | --- | --- | --- |
| OurAirports | US airports without an IATA code | 30,673 | recoverable | Excluded from clean because the BTS flight records use IATA codes. | Mehul | 2026-11-10 |
| OurAirports | Missing elevation | 14,982 in raw; 56 in clean | recoverable | Kept the airports and stored missing elevation as NULL because elevation is not required for the flight-to-weather join. | Mehul | 2026-11-10 |
| OurAirports | US territories have separate country codes (PR, VI, GU, MP) | 20 territory airports added (PR 10, VI 5, MP 3, GU 2) | recoverable | Included US territories in the clean table's country filter. | Mehul | 2026-11-10 |
| OurAirports | Duplicate IATA codes, invalid IATA formats, or invalid coordinates | 0 reported by the Nov 10 checks | recoverable | No corrections were needed in that run; the clean table has a primary key on IATA code and filters out invalid coordinates. | Mehul | 2026-11-10 |
| OurAirports | Closed airports | 13,659 worldwide in raw; 0 US airports with an IATA code | recoverable | Left the original records in raw and excluded closed airports from clean. | Mehul | 2026-11-10 |
