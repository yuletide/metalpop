# METAL POP

This repo contains a workflow to join population data centroids from SEDAC GPWv4 to global political boundaries such as Natural Earth Vector or GADM, enriched with band data scraped from Metal-Archives.

## Requirements

Tools:
- Mapshaper
- GDAL
- Make
- wget
- Mapbox MTSCLI for tiling

Data: 
- [GPWv4 Centroids](https://sedac.ciesin.columbia.edu/data/collection/gpw-v4)
- Vector data such as [GADM](https://gadm.org/index.html) or [Natural Earth](https://www.naturalearthdata.com/) [States and Provinces](https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states_provinces.zip) (default)

## Usage
- `make all`: Run this command to process the point data, and join it to natural earth states and provinces using `mapshaper`
- `make all_bands`: same as `make all` but with the added step of joining band data and tiling the results using Mapbox Tiling Service
- `make csv`: Import regional GPW centroid CSV files and merge into one giant globalshapefile, using `INSIDE_X` and `INSIDE_Y` to create point geometries
- `make 
- `make get_natural_earth`: download natural earth vector data
