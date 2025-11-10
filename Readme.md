# METAL POP

This repo contains a workflow to join population data centroids from SEDAC GPWv4 to global political boundaries such as Natural Earth Vector or GADM, enriched with band data scraped from Metal-Archives.

## Requirements

Tools:
- Mapshaper
- GDAL
- Make
- wget
- Python 3
- Mapbox MTSCLI for tiling

Data: 
- [GPWv4 Centroids](https://sedac.ciesin.columbia.edu/data/collection/gpw-v4)
- Vector data such as [GADM](https://gadm.org/index.html) or [Natural Earth](https://www.naturalearthdata.com/) [States and Provinces](https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states_provinces.zip) (default)

## Features

### Region Merging for MAUP Resolution
This workflow includes automatic merging of administrative regions to solve the Modifiable Area Unit Problem (MAUP). For example, London boroughs are merged into Greater London to prevent artificially inflated per-capita rates caused by geocoding all "London" bands to a single borough centroid.

Configure region merges in `region_merges.json`. See [REGION_MERGING.md](REGION_MERGING.md) for detailed documentation.

## Usage
- `make all`: Run this command to process the point data, and join it to natural earth states and provinces using `mapshaper`
- `make all_bands`: same as `make all` but with the added step of joining band data and tiling the results using Mapbox Tiling Service
- `make csv`: Import regional GPW centroid CSV files and merge into one giant globalshapefile, using `INSIDE_X` and `INSIDE_Y` to create point geometries
- `make merge_regions`: Merge administrative regions based on `region_merges.json` configuration
- `make test_merge_regions`: Run unit tests for the region merging functionality
- `make get_natural_earth`: download natural earth vector data
