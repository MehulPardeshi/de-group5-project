# Milestone 1 Proposal: Section C2, Group 5

_Archived working draft. The submitted version is the Google Doc's "Project Proposal" tab, submitted as a PDF on Canvas on Nov 9, 2026. Where they differ, the Google Doc wins._

## Team
- **Team:** Section C2, Group 5
- **Members:** Joshua Kalakoti, Mehul Pardeshi, Sowmya Rajesh, Yang Lin
- **Project manager:** Mehul Pardeshi
- **Meeting notes:** https://docs.google.com/document/d/1ZRghN_Yd0TvMPLkODDwQJpOp_zMgrPgINymwyh_op-E/edit?usp=sharing

## Context and problem statement

In the 21st century, air transportation is a critical element of the US economy and commerce. Recently in January 2026, a major winter storm caused over 10,000 flights to be delayed or canceled in the span of one weekend, and led to over a hundred billion dollars in economic losses. Flights delays end up negatively affecting customer satisfaction, and travelers can become frustrated with understanding the factors that caused their flight delay. Our project will address this problem by analyzing the impact of weather on flight delays in the United States, and whether other factors are having a greater impact.

## Specific questions

1. What share of flight delays are caused by weather, compared with airline, airport or air-traffic causes?
2. When a delay is attributed to weather, does the weather data show that the weather was actually bad that day?
3. Under similar weather at the same airport, which airlines have the lowest delay and cancellation rates?
4. After a severe-weather day, how many days do the three busiest US airports take to return to their usual delay and cancellation rates?

## Why it matters and who benefits

Flight delays cost travelers time and money. For airlines and airports they mean crew overtime, rebooking and unhappy customers. Our questions try to sort out which delays could have been prevented and which could not. If most delays come from airline or airport problems rather than weather (Q1), those are the areas with room to improve. Q2 matters to passengers directly: airlines usually offer less help, like meals or hotel rooms, when a delay is blamed on weather, so it is worth checking whether the "weather" label actually matches the weather that day. The US Department of Transportation also relies on this reporting, so regulators would care about the answer too. Comparing airlines under the same weather at the same airport (Q3) gives travelers and corporate travel planners a fairer basis for choosing an airline than plain on-time rankings. Finally, knowing how long recovery takes after a severe-weather day (Q4) helps airports and airlines plan staffing and rebooking for the days that follow, when delays often keep piling up.

## Our motivation

- Josh: The importance of efficiency and customer satisfaction in the commercial flight economy. 
- Mehul: I have always enjoyed turning ideas into something people can actually use, and this project interests me because I want to understand what really causes flight delays and how that affects travelers.
- Sowmya: I fly often and have had my share of delays and cancellations, so this topic is personal, and I'd like to understand what actually causes them.
- Yang: I want to understand how different attributes affect airline operations and each airline weaknesses when dealing with multiple factors that will lead to flight delay.

## Datasets we plan to use (optional for Milestone 1)

Bureau of Transportation Statistics on-time performance: every domestic flight with delay causes (monthly CSV, millions of rows): https://www.transtats.bts.gov/DL_SelectFields.aspx
NOAA Climate Data Online API: daily weather by station (JSON, free token): https://www.ncei.noaa.gov/cdo-web/webservices/v2
NOAA Storm Events: severe weather events (CSV): https://www.ncdc.noaa.gov/stormevents/ftp.jsp
OurAirports: airport details and locations, for matching airports to weather stations (CSV): https://ourairports.com/data/

