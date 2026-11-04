## Idea 1: Short-Term Rental Guest Experience Analyzer

- **Context:** Tourism, hospitality, and customer experience.
- **Real-world problem:** A property manager wants to identify recurring guest concerns and compare advertised prices for similar listings with different neighborhood amenities.
- **Who would benefit:** Property managers, hospitality consultants, and tourism organizations.
- **Datasets I know of (with links) (has pretty comprehensive dataset):**
  1. **[Inside Airbnb — Detailed Listings](https://insideairbnb.com/get-the-data/):** CSV data with listing characteristics, advertised prices, amenities, and locations.
  2. **[Inside Airbnb — Detailed Reviews](https://insideairbnb.com/get-the-data/):** A separate CSV dataset with dated guest reviews, linked to listings through listing IDs. The two datasets contain different information despite coming from the same provider.
  3. **[NYC Parks Properties](https://catalog.data.gov/dataset/opendata_parksproperties):** GeoJSON, a semi-structured format, with park locations and boundaries. Use it to compare listings by nearby outdoor amenities. Follow the catalog’s link to the current dataset.
- **Why I care about it:** I want to learn how to combine guest feedback with operational data to identify specific service improvements.
- **Three questions to investigate:**
  - Which guest-experience themes appear most often?
  - How do these themes differ by room type and advertised price range?
  - Among similar listings, how do prices and review themes differ by proximity to parks?


## Idea 2: US–Taiwan Cross-Border Pricing Monitor

- **Context:** Fintech, international business, and pricing analysis.
- **Real-world problem:** A company selling in the US and Taiwan wants to track the USD–TWD exchange rate and inflation in both markets through one dashboard to support pricing reviews.
- **Who would benefit:** Fintech analysts, companies’ US–Taiwan finance teams, and pricing consultants.
- **Datasets I know of (with links):**
  1. **[Central Bank of Taiwan Monthly Average Exchange Rates — FTDOpenData016.csv](https://www.cbc.gov.tw/public/data/OpenData/%E5%A4%96%E5%8C%AF%E5%B1%80/FTDOpenData016.csv):** CSV data showing New Taiwan dollars per US dollar. The monthly rate is the geometric average of daily interbank closing rates, so no daily-to-monthly calculation is needed.
  2. **[US Bureau of Labor Statistics Consumer Price Index](https://www.bls.gov/cpi/data.htm):** Monthly US consumer-price data. Use the national all-items CPI-U series to track price changes.
  3. **[Taiwan Directorate-General of Budget, Accounting and Statistics](https://eng.stat.gov.tw/):** Monthly Taiwan Consumer Price Index data for comparing inflation with the US.

  Use January 2023 through December 2025, after confirming coverage in all three datasets. Join the records by year and month. Set both price indices to 100 in January 2023 to compare changes over time, while explaining differences in their consumer baskets, weights, and statistical methods. This shows how prices have changed, rather than which market is cheaper.

  The verified exchange-rate file is CSV. An official JSON or XML source for at least one dataset still needs to be confirmed to meet the assignment’s semi-structured data requirement.

- **Why I care about it:** I want to combine my finance background and work experience in the US and Taiwan to build a practical tool for reviewing cross-border pricing conditions. The dashboard would provide economic context; it would not measure a company’s actual costs or determine its optimal prices.
- **Three questions to investigate:**
  1. How did the monthly USD–TWD exchange rate change from January 2023 through December 2025, and which months had the largest percentage changes?
  2. How much did consumer prices rise in the US and Taiwan over this period, using January 2023 as the starting point?
  3. After converting Taiwan’s rebased price index into US-dollar terms using the monthly exchange rate, how did its change compare with the US price index? This compares inflation and currency movements together, not actual price levels between the two markets.
