## Idea: Drinking water safety in Pennsylvania

- **Context:** Public services. The safety of drinking water supplied to homes across Pennsylvania.
- **Real-world problem:** A lot of water systems in Pennsylvania have had safety violations, still have old lead pipes, or have found PFAS ("forever chemicals") in their water. Most people have no idea if their own tap water is affected. We also don't really know if these problems get fixed, or if poorer and rural areas are hit harder.
- **Who would benefit:** People living in these areas (especially families with kids), water companies like Pittsburgh Water (PWSA), the PA Department of Environmental Protection, local health departments, and anyone deciding where to spend money on fixing pipes.
- **Datasets I know of (with links):**
  - EPA ECHO Safe Drinking Water Act data: water systems, violations and enforcement (national CSV download, updated quarterly; filter to PA): https://echo.epa.gov/tools/data-downloads
  - EPA UCMR 5 PFAS test results (includes files split by state): https://www.epa.gov/dwucmr/occurrence-data-unregulated-contaminant-monitoring-rule
  - US Census American Community Survey 5-Year API (free key): income, kids, renters, rural/urban by county: https://www.census.gov/data/developers/data-sets/acs-5year.html
  - Maybe: PWSA lead pipe records for Pittsburgh (map only right now): https://lead.pgh2o.com/?p=413
  - To look into: PA Department of Environmental Protection drinking water data or USGS water quality data, to add a non-EPA source
- **Why I care about it:** I live in Pittsburgh and drink this water every day, and I honestly don't know if it's safe. Everyone needs clean water, so it'd be useful to find out which areas have problems and whether they're actually getting fixed.

## Idea: Do "healthy" food labels tell the truth?

- **Context:** Public health and business. How packaged foods in the US are labelled and marketed.
- **Real-world problem:** Packaged foods often say things like "healthy", "natural", "low-fat" or "plant-based" on the front, but the nutrition facts on the back don't always back that up. People trying to eat better might be choosing foods that are just as high in sugar, salt or fat. It's also hard to tell which brands are trustworthy, since some have had products pulled from shelves for safety problems.
- **Who would benefit:** Shoppers (especially people watching their diet), dietitians, the FDA, grocery stores deciding what to stock, and consumer groups.
- **Datasets I know of (with links):**
  - Open Food Facts: products with ingredients, label claims and nutrients (JSON/CSV/Parquet downloads + JSON API): https://world.openfoodfacts.org/data
  - USDA FoodData Central, Branded Foods: official nutrition labels (CSV or JSON download): https://fdc.nal.usda.gov/download-datasets
  - openFDA food recalls / enforcement reports (JSON API, 2004 to now): https://open.fda.gov/apis/food/enforcement
  - FDA "healthy" claim rule, for the official nutrient limits: https://www.federalregister.gov/documents/2024/12/27/2024-29957/food-labeling-nutrient-content-claims-definition-of-term-healthy
- **Why I care about it:** I check food labels when I shop, and I've noticed products that look healthy on the front but aren't when you read the back. It'd be interesting to see how common that actually is.
