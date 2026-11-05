## Idea: Where are the sponsored tech jobs, and do they pay fairly?

- **Context:** Business and the labor market. Hiring of skilled tech workers in the US, including workers who need visa sponsorship.
- **Real-world problem:** Job seekers who need sponsorship can't easily tell which employers, roles and cities actually sponsor, or whether those jobs pay in line with the wider market. The information is public but scattered across government filings, wage tables and job boards.
- **Who would benefit:** International students and other job seekers, university career services, and policy researchers studying the skilled-worker visa program.
- **Datasets I know of (with links):**
  - US Department of Labor H-1B disclosure data: employer, job title, location and wage for each application (large yearly Excel files): https://www.dol.gov/agencies/eta/foreign-labor/performance
  - US Bureau of Labor Statistics OEWS: wages by occupation and metro area (Excel): https://www.bls.gov/oes/tables.htm
  - Adzuna API: current job postings (JSON, free key): https://developer.adzuna.com/
- **Possible questions:**
  - Which employers and metro areas file the most tech H-1B applications, and how has that changed over time?
  - How do offered wages compare with market wages for the same occupation and metro area?
  - Do employers with many past filings also have many open tech roles now?
- **What makes it good for this course:** The H-1B files are large and messy. Employer names need cleaning and matching, and job titles have to be linked to occupation codes across sources.
- **Why I care about it:** I'm applying for Summer 2027 internships, so I'm seeing this job market firsthand.

## Idea: How much of US flight delay is really the weather?

- **Context:** Transportation and business. Reliability of US commercial air travel.
- **Real-world problem:** Delays cost travelers and airlines time and money, and weather often gets the blame. It's hard for passengers to tell how much is actually weather and how much is down to the airline or the airport.
- **Who would benefit:** Travelers choosing flights, airports and airlines planning operations, and regulators.
- **Datasets I know of (with links):**
  - Bureau of Transportation Statistics on-time performance: every domestic flight with delay causes (monthly CSV, millions of rows): https://www.transtats.bts.gov/DL_SelectFields.aspx
  - NOAA Climate Data Online API: daily weather by station (JSON, free token): https://www.ncei.noaa.gov/cdo-web/webservices/v2
  - NOAA Storm Events: severe weather events (CSV): https://www.ncdc.noaa.gov/stormevents/ftp.jsp
  - OurAirports: airport details and locations, for matching airports to weather stations (CSV): https://ourairports.com/data/
- **Possible questions:**
  - How does the delay blamed on weather compare with what the weather data shows on those days?
  - Which airports and airlines recover slowest after a bad-weather day?
  - Which routes and times of day are most reliable?
- **What makes it good for this course:** There's plenty of volume, and the sources join naturally on airport and date, though airports still have to be matched to weather stations.
- **Why I care about it:** Delays affect anyone who travels, and this would show whether the usual explanation holds up.
