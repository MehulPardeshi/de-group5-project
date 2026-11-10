-- Store the original OurAirports CSV without changing the data.
CREATE TABLE IF NOT EXISTS raw.ourairports_airports (
    id TEXT,
    ident TEXT,
    type TEXT,
    name TEXT,
    latitude_deg TEXT,
    longitude_deg TEXT,
    elevation_ft TEXT,
    continent TEXT,
    iso_country TEXT,
    iso_region TEXT,
    municipality TEXT,
    scheduled_service TEXT,
    icao_code TEXT,
    iata_code TEXT,
    gps_code TEXT,
    local_code TEXT,
    home_link TEXT,
    wikipedia_link TEXT,
    keywords TEXT
);
