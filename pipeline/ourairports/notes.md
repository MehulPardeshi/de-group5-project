# OurAirports: source notes

I am using the OurAirports dataset for my part of our flight delay project. I downloaded the `airports.csv` file from the [OurAirports data page](https://ourairports.com/data/) on November 9, 2026, at 18:20 UTC. The file is around 12 MB and contains 86,350 rows and 19 columns. The columns are `id`, `ident`, `type`, `name`, `latitude_deg`, `longitude_deg`, `elevation_ft`, `continent`, `iso_country`, `iso_region`, `municipality`, `scheduled_service`, `icao_code`, `iata_code`, `gps_code`, `local_code`, `home_link`, `wikipedia_link`, and `keywords`. For me, this dataset is important because it gives us the airport codes and coordinates needed to connect flight records with weather data, which will help us understand how much weather actually contributes to flight delays.

Source file: https://davidmegginson.github.io/ourairports-data/airports.csv
