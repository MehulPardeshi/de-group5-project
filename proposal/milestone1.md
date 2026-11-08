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

## Why it matters and who benefits
**Owner:** Sowmya

Flight delays cost travelers time and money. For airlines and airports they mean crew overtime, rebooking and unhappy customers. Our questions try to sort out which delays could have been prevented and which could not. If most delays come from airline or airport problems rather than weather (Q1), those are the areas with room to improve. Q2 matters to passengers directly: airlines usually offer less help, like meals or hotel rooms, when a delay is blamed on weather, so it is worth checking whether the "weather" label actually matches the weather that day. The US Department of Transportation also relies on this reporting, so regulators would care about the answer too. Comparing airlines under the same weather at the same airport (Q3) gives travelers and corporate travel planners a fairer basis for choosing an airline than plain on-time rankings. Finally, knowing how long recovery takes after a severe-weather day (Q4) helps airports and airlines plan staffing and rebooking for the days that follow, when delays often keep piling up.


## Our motivation
**Owner:** everyone, one line each

_Why our team chose this topic._

- Josh: The importance of efficiency and customer satisfaction in the commercial flight economy. 
- Mehul: I have always enjoyed turning ideas into something people can actually use, and this project interests me because I want to understand what really causes flight delays and how that affects travelers.
- Sowmya: I fly often and have had my share of delays and cancellations, so this topic is personal, and I'd like to understand what actually causes them.
- Yang:

## Datasets we plan to use (optional for Milestone 1)

Bureau of Transportation Statistics on-time performance: every domestic flight with delay causes (monthly CSV, millions of rows): https://www.transtats.bts.gov/DL_SelectFields.aspx
NOAA Climate Data Online API: daily weather by station (JSON, free token): https://www.ncei.noaa.gov/cdo-web/webservices/v2
NOAA Storm Events: severe weather events (CSV): https://www.ncdc.noaa.gov/stormevents/ftp.jsp
OurAirports: airport details and locations, for matching airports to weather stations (CSV): https://ourairports.com/data/

_At least 3 distinct datasets, at least 1 semi-structured. Listing them now shows the topic is feasible._
