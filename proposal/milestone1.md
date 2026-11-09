# Milestone 1 Proposal: Section C2, Group 5

Due Mon, Nov 9, 11:59 pm. The final PDF is 1-2 pages. Each person writes their section, then Mehul assembles the PDF.

**Team section owner:** Mehul (done)

## Team
- **Team:** Section C2, Group 5
- **Members:** Joshua Kalakoti, Mehul Pardeshi, Sowmya Rajesh, Yang Lin
- **Project manager:** Mehul Pardeshi
- **Meeting notes:** https://docs.google.com/document/d/1ZRghN_Yd0TvMPLkODDwQJpOp_zMgrPgINymwyh_op-E/edit?usp=sharing

## Context and problem statement
**Owner:** Josh

In the 21st century, air transportation is a critical element of the US economy and commerce. Recently in January 2026, a major winter storm caused over 10,000 flights to be delayed or canceled in the span of 24 hours, and led to hundreds of millions of dollars more in costs. Flights delays end up negatively affecting customer satisfaction, and travelers can become frustrated with understanding the factors that caused their flight delay. Our project will address this problem by analyzing the impact of weather on flight delays in the United States, and whether other factors are having a greater impact.

_The business or societal context, and the one real-world problem we're exploring. This can't change after Monday._

## Specific questions
**Owner:** Yang (final set agreed at the Nov 8 meeting, combining Josh's and Yang's drafts)

1. What share of flight delays are caused by weather, compared with airline, airport or air-traffic causes?
2. When a delay is attributed to weather, does the weather data show that the weather was actually bad that day?
3. Under similar weather at the same airport, which airlines have the lowest delay and cancellation rates?
4. After a severe-weather day, how many days do the three busiest US airports take to return to their usual delay and cancellation rates?

_Cost questions were left out of Milestone 1 because none of our datasets have cost data. The scope can be refined after Milestone 1 if time allows._

### Working definitions for weather analysis

Provisional definitions for team review, based on National Weather Service (NWS) criteria; these are study indicators, not a universal NOAA definition of severe weather.

- **High-wind threshold (`high_wind_threshold_met`):** A valid daily peak wind gust at the matched airport station of at least **58 mph** (approximately **25.9 m/s**). This flags the gust threshold only; it does not establish that NWS issued a warning or that sustained-wind duration criteria were met. [NWS high-wind criteria](https://www.weather.gov/box/criteria)
- **Recorded storm event (`selected_storm_event_present`):** A NOAA Storm Events record classified as **Thunderstorm Wind, Tornado, Blizzard, Winter Storm, or High Wind**, overlapping the airport's analysis date and matched geographic area. These categories are our proposed selection. The team will document the geographic matching rule and time-zone handling before analysis. [NOAA Storm Events](https://www.ncei.noaa.gov/access/storm-events-database/)
- **Combined study indicator:** A day is flagged when either indicator is positive. Missing or quality-rejected wind observations remain unknown; if no event is matched and wind data are missing, the combined result remains unknown. No matching event is not proof of good weather.

For GHCN-Daily observations, check station coverage for `WSF5` (fastest 5-second wind speed), units, scaling, and quality flags before applying the gust threshold. Daily average wind is not a substitute. This indicator does not capture every aviation-disrupting condition, such as fog or less intense thunderstorms, and cannot prove the cause of an individual flight delay. [NOAA field documentation](https://www.ncei.noaa.gov/pub/data/ghcn/daily/readme.txt)

### Working definitions for airport size and recovery

These definitions are proposals for team review. The recovery window and tolerance below are analytical choices, not official BTS or NOAA standards.

- **Three busiest airports:** Rank US origin airports by the number of scheduled departures in the selected BTS On-Time Performance records over the full, agreed study period, including flights later cancelled. Deduplicate flight records, use consistent reporting coverage, and select the top three before inspecting their disruption results. Break ties by airport code. Describe them as "the three busiest airports by scheduled departures in our BTS study data," not the three busiest by passengers or all US aircraft movements. [BTS data source](https://www.transtats.bts.gov/ONTIME/)
- **Daily performance measures:** For each selected origin airport and local scheduled-departure date, calculate (1) the share of noncancelled, nondiverted flights with valid arrival-delay data arriving at least 15 minutes late, and (2) cancellations divided by all scheduled departures. Report missing arrival data and diversions separately. The 15-minute arrival-delay threshold follows BTS; the denominators and grouping are our study choices. [BTS delay definition](https://www.transtats.bts.gov/ot_delay/)
- **Normal-performance baseline:** For each recovery date and airport, use separate median daily delay and cancellation rates from the same weekday in the eight weeks before the weather episode started. Keep only days with a known zero combined study hazard indicator and valid performance data. This is a "no selected hazard recorded" baseline, not proof of ideal weather. Require at least four eligible reference days; otherwise mark the baseline unavailable. Extra pre-study data will be needed.
- **Return to normal:** As an initial rule for review, both daily rates must be no more than **5 percentage points above** their respective weekday baselines for **two consecutive days**, each with a known zero study hazard indicator. Record recovery on the second qualifying day. Measure elapsed calendar days from the final day of a consecutive flagged weather episode. If another flagged day interrupts recovery, mark the episode interrupted rather than attributing all later disruption to the original event. Missing data or the end of the observation window means recovery is unknown/not observed, not zero days. Obtain post-study data where needed and compare results using 2-, 5-, and 10-percentage-point tolerances.

The team must confirm the study dates, data coverage, minimum daily flight counts, and these provisional settings before implementation. These measures describe observed recovery; they do not establish that all delays during recovery were caused by the weather episode.

## Why it matters and who benefits
**Owner:** Sowmya

Flight delays cost travelers time and money. For airlines and airports they mean crew overtime, rebooking and unhappy customers. Our questions try to sort out which delays could have been prevented and which could not. If most delays come from airline or airport problems rather than weather (Q1), those are the areas with room to improve. Q2 matters to passengers directly: airlines usually offer less help, like meals or hotel rooms, when a delay is blamed on weather, so it is worth checking whether the "weather" label actually matches the weather that day. The US Department of Transportation also relies on this reporting, so regulators would care about the answer too. Comparing airlines under the same weather at the same airport (Q3) gives travelers and corporate travel planners a fairer basis for choosing an airline than plain on-time rankings. Finally, knowing how long recovery takes after a severe-weather day (Q4) helps airports and airlines plan staffing and rebooking for the days that follow, when delays often keep piling up.


## Our motivation
**Owner:** everyone, one line each

_Why our team chose this topic._

- Josh: The importance of efficiency and customer satisfaction in the commercial flight economy. 
- Mehul: I have always enjoyed turning ideas into something people can actually use, and this project interests me because I want to understand what really causes flight delays and how that affects travelers.
- Sowmya: I fly often and have had my share of delays and cancellations, so this topic is personal, and I'd like to understand what actually causes them.
- Yang: I want to understand how different attributes affect airline operations and each airline weaknesses when dealing with multiple factors that will lead to flight delay.

## Datasets we plan to use (optional for Milestone 1)

Bureau of Transportation Statistics on-time performance: every domestic flight with delay causes (monthly CSV, millions of rows): https://www.transtats.bts.gov/DL_SelectFields.aspx
NOAA Climate Data Online API: daily weather by station (JSON, free token): https://www.ncei.noaa.gov/cdo-web/webservices/v2
NOAA Storm Events: severe weather events (CSV): https://www.ncdc.noaa.gov/stormevents/ftp.jsp
OurAirports: airport details and locations, for matching airports to weather stations (CSV): https://ourairports.com/data/

_At least 3 distinct datasets, at least 1 semi-structured. Listing them now shows the topic is feasible._
