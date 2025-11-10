# METAL POP

This repo contains a workflow to join population data centroids from SEDAC GPWv4 to global political boundaries such as Natural Earth Vector or GADM, enriched with band data scraped from Metal-Archives.

## Components

### Data Processing Pipeline
The core data processing pipeline that:
- Processes population data from SEDAC GPWv4
- Joins with metal band data from Metal-Archives
- Creates geographic datasets showing band distribution
- Generates Mapbox tilesets for visualization

### Frontend Application
An interactive Next.js web application for visualizing the data:
- Interactive map with Mapbox GL
- Genre-based filtering
- Click-to-view region statistics
- Responsive design with dark mode support

See the [frontend README](./frontend/README.md) for setup instructions.

## Requirements

Tools:
- Mapshaper
- GDAL
- Make
- wget
- Mapbox MTSCLI for tiling
- Node.js (for frontend)

Data: 
- [GPWv4 Centroids](https://sedac.ciesin.columbia.edu/data/collection/gpw-v4)
- Vector data such as [GADM](https://gadm.org/index.html) or [Natural Earth](https://www.naturalearthdata.com/) [States and Provinces](https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states_provinces.zip) (default)

## Usage

### Data Processing
- `make all`: Run this command to process the point data, and join it to natural earth states and provinces using `mapshaper`
- `make all_bands`: same as `make all` but with the added step of joining band data and tiling the results using Mapbox Tiling Service
- `make csv`: Import regional GPW centroid CSV files and merge into one giant globalshapefile, using `INSIDE_X` and `INSIDE_Y` to create point geometries
- `make get_natural_earth`: download natural earth vector data

### Frontend
Navigate to the `frontend` directory and follow the setup instructions in the [frontend README](./frontend/README.md).

Quick start:
```bash
cd frontend
npm install
cp .env.local.example .env.local
# Edit .env.local with your Mapbox token
npm run dev
```
