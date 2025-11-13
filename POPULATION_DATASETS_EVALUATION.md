# Global Population Datasets: Alternatives to SEDAC GPW v4

## Executive Summary

This document evaluates alternative global population datasets to replace SEDAC GPW v4 (Gridded Population of the World version 4) following the discontinuation of SEDAC funding. The evaluation focuses on coverage, accuracy, recency, and suitability for joining with global political boundaries.

**⚠️ Critical Finding:** All modern, actively maintained population datasets are **raster-based**, requiring an alternate pipeline from GPW's admin centroid point format. There is no "drop-in replacement" that maintains GPW's data format while providing current updates.

**Recommended Approach:** Build an **alternate raster-to-vector pipeline** for WorldPop or GHS-POP data:
- Accept slower processing (2-8 hours for global processing, optimizable)
- Gain access to actively maintained, high-quality current data
- Can run once per year/data release and cache results
- Keep existing GPW pipeline as fallback or legacy option

See [Conclusion & Recommendations](#conclusion--recommendations) for implementation roadmap and performance optimization strategies.

## Current Dataset: SEDAC GPW v4

**Overview:**
- **Source:** NASA SEDAC (Socioeconomic Data and Applications Center) at Columbia University
- **Current Version:** GPW v4.11 (Revision 11)
- **Base Year:** 2020 estimates (with historical data back to 2000)
- **Resolution:** ~1 km at equator (30 arc-seconds)
- **Format:** Admin unit center points with population estimates
- **Coverage:** Global
- **Update Frequency:** Discontinued (funding cuts)

**Characteristics:**
- Population counts allocated to administrative unit centroids
- Includes UN-adjusted population estimates (UN_2000_E, UN_2005_E, UN_2020_E)
- Provides INSIDE_X and INSIDE_Y coordinates for reliable spatial joins
- Available as GeoPackage and CSV formats

**Strengths:**
- Well-documented and widely used
- Admin unit based approach aligns well with political boundaries
- UN-adjusted estimates provide standardized global comparisons

**Weaknesses:**
- No longer maintained or updated
- Most recent data is from 2020
- Will become increasingly outdated

---

## Alternative Dataset 1: WorldPop

**Overview:**
- **Source:** WorldPop Research Group, University of Southampton
- **Website:** https://www.worldpop.org/
- **Latest Data:** 2020 (constrained and unconstrained estimates)
- **Resolution:** ~100m (3 arc-seconds) - Higher resolution than GPW
- **Format:** GeoTIFF raster files
- **Coverage:** Global, with detailed country-specific datasets
- **Update Frequency:** Annual updates, actively maintained
- **License:** Creative Commons Attribution 4.0 International (CC BY 4.0)

**Detailed Evaluation:**

**Coverage:**
- ✅ **Excellent:** Complete global coverage at country level
- ✅ Individual country datasets available
- ✅ Regional aggregations available
- ✅ Top-down (UN-adjusted) and bottom-up estimates
- ✅ Age and sex disaggregated data available for many countries

**Accuracy:**
- ✅ **Very Good:** Uses machine learning and random forest models
- ✅ Integrates multiple data sources:
  - Census data
  - Satellite imagery
  - Building footprints (from Microsoft, Google, OpenStreetMap)
  - Settlement locations
  - Land cover data
- ✅ Constrained vs Unconstrained models:
  - Constrained: Population only in settled areas
  - Unconstrained: Population distributed across entire country
- ✅ Validation studies show high accuracy (R² > 0.85 in most regions)
- ⚠️ Accuracy varies by data availability in different countries

**Recency:**
- ✅ **Excellent:** Actively maintained with annual updates
- ✅ 2020 data available (same as GPW v4)
- ✅ 2025 projections available
- ✅ Historical data: 2000-2020 in yearly or 5-year intervals
- ✅ Funded by multiple organizations including Bill & Melinda Gates Foundation

**Data Format & Access:**
- Format: Primarily GeoTIFF rasters (not centroid points like GPW)
- Requires conversion/aggregation to admin units
- Available via:
  - FTP download
  - WFS/WCS web services (limited)
  - wopr R package for programmatic access
- File sizes can be very large (10+ GB for global datasets)

**Comparison to GPW v4:**
| Aspect | WorldPop | GPW v4 |
|--------|----------|--------|
| Resolution | ~100m | ~1km |
| Data Type | Raster | Admin centroids |
| Recency | 2020, actively updated | 2020, discontinued |
| Method | ML + ancillary data | Census redistribution |
| Age/Sex data | Yes (many countries) | No |
| Easy admin join | No (requires processing) | Yes |

**Suitability for metalpop:**
- ⚠️ **Moderate-High:** Excellent data quality but requires significant processing
- Would need to aggregate raster data to admin unit polygons
- Higher resolution could provide better accuracy
- Ongoing updates ensure data stays current

---

## Alternative Dataset 2: LandScan

**Overview:**
- **Source:** Oak Ridge National Laboratory (ORNL), U.S. Department of Energy
- **Website:** https://landscan.ornl.gov/
- **Latest Data:** 2022 (annual releases)
- **Resolution:** ~1 km (30 arc-seconds) - Same as GPW
- **Format:** GeoTIFF raster
- **Coverage:** Global
- **Update Frequency:** Annual
- **License:** License required, restrictions on redistribution

**Detailed Evaluation:**

**Coverage:**
- ✅ **Excellent:** Complete global coverage
- ✅ Consistent global methodology
- ✅ Annual releases since 2000

**Accuracy:**
- ✅ **Very Good:** Represents ambient population (24-hour average)
- ✅ Sophisticated modeling:
  - Multi-variable dasymetric modeling
  - Incorporates land cover, roads, slope, urban areas
  - Uses night-time lights data
  - Machine learning algorithms
- ⚠️ Ambient population vs residential population:
  - Distributes population where people are throughout the day
  - Different from residential/census enumeration approach
  - May not align perfectly with admin-based census data
- ✅ Considered the "gold standard" by many researchers
- ✅ Peer-reviewed methodology

**Recency:**
- ✅ **Excellent:** 2022 data available (most recent among alternatives)
- ✅ Annual updates since 2000
- ✅ Well-funded U.S. government program
- ✅ Long-term sustainability expected

**Data Format & Access:**
- Format: GeoTIFF raster (not centroid points)
- Requires registration and license agreement
- Commercial use restrictions
- Free for research and government use
- Redistribution not permitted
- Must cite properly

**Comparison to GPW v4:**
| Aspect | LandScan | GPW v4 |
|--------|----------|--------|
| Resolution | ~1km | ~1km |
| Data Type | Raster | Admin centroids |
| Recency | 2022 | 2020, discontinued |
| Method | Ambient population model | Census redistribution |
| Population Type | 24-hour average | Residential/census |
| Access | License required | Open |
| Easy admin join | No (requires processing) | Yes |

**Suitability for metalpop:**
- ⚠️ **Moderate:** Excellent quality and recency, but:
  - License restrictions may limit use
  - Ambient population concept may not match census admin data
  - Raster format requires processing
  - Cannot be easily redistributed

---

## Alternative Dataset 3: GHS-POP (Global Human Settlement Layer)

**Overview:**
- **Source:** European Commission Joint Research Centre (JRC)
- **Website:** https://ghsl.jrc.ec.europa.eu/
- **Latest Data:** 2020 (R2023A release)
- **Resolution:** Multiple (1km, 100m, 10m available)
- **Format:** GeoTIFF raster, vector grid cells
- **Coverage:** Global
- **Update Frequency:** Major releases every 2-3 years
- **License:** CC BY 4.0 (fully open)

**Detailed Evaluation:**

**Coverage:**
- ✅ **Excellent:** Complete global coverage
- ✅ Multiple resolution options (1km, 100m, 10m)
- ✅ Part of larger Global Human Settlement Layer ecosystem:
  - GHS-BUILT (built-up areas)
  - GHS-SMOD (settlement model)
  - GHS-POP (population)
  - All datasets integrated and consistent

**Accuracy:**
- ✅ **Very Good:** Uses satellite imagery and machine learning
- ✅ Methodology:
  - Sentinel-2 and Landsat imagery
  - Built-up area detection from satellite
  - Population distribution within built-up areas
  - Census data integration
- ✅ Multiple epochs: 1975, 1990, 2000, 2015, 2020
- ✅ Transparent, open methodology
- ✅ Extensively validated in scientific literature
- ⚠️ May underestimate rural populations in some regions

**Recency:**
- ✅ **Good:** 2020 data available (R2023A release)
- ✅ Regular updates (2-3 year cycle)
- ⚠️ Not annual updates
- ✅ Well-funded EU program
- ✅ Long-term commitment indicated

**Data Format & Access:**
- Format: GeoTIFF rasters and vector grids
- Freely downloadable (no registration required)
- Available via:
  - Direct download
  - Google Earth Engine
  - WMS/WMTS services
- Well-documented
- Multiple derived products available

**Comparison to GPW v4:**
| Aspect | GHS-POP | GPW v4 |
|--------|----------|--------|
| Resolution | 1km, 100m, 10m | ~1km |
| Data Type | Raster/Grid | Admin centroids |
| Recency | 2020 (updates every 2-3 yrs) | 2020, discontinued |
| Method | Satellite + ML | Census redistribution |
| Historical data | 1975-2020 | 2000-2020 |
| Access | Fully open | Open |
| Easy admin join | No (requires processing) | Yes |

**Suitability for metalpop:**
- ✅ **High:** Very good option:
  - Excellent quality and methodology
  - Fully open license
  - Multiple resolutions available
  - Actively maintained with EU funding
  - Can be easily redistributed
  - Good documentation

---

## Alternative Dataset 4: UN World Population Prospects

**Overview:**
- **Source:** United Nations Department of Economic and Social Affairs (UN DESA)
- **Website:** https://population.un.org/wpp/
- **Latest Data:** 2022 Revision (published July 2022)
- **Resolution:** Country and major administrative divisions
- **Format:** CSV, Excel, database
- **Coverage:** Global (all countries)
- **Update Frequency:** Biennial (every 2 years)
- **License:** Open, free to use with attribution

**Detailed Evaluation:**

**Coverage:**
- ✅ **Excellent:** All countries and territories
- ⚠️ **Limited:** Only country and major admin level 1 in some cases
- ❌ No gridded or high-resolution spatial data
- ✅ Comprehensive demographic indicators:
  - Population by age and sex
  - Fertility rates
  - Mortality rates
  - Migration
  - Projections to 2100

**Accuracy:**
- ✅ **Excellent:** Considered the authoritative source for country totals
- ✅ Based on:
  - National census data
  - Vital registration systems
  - Sample surveys
  - Expert review and harmonization
- ✅ Used as reference totals by most other datasets (GPW, WorldPop, etc.)
- ✅ Multiple projection scenarios (low, medium, high variants)
- ❌ No sub-national spatial distribution

**Recency:**
- ✅ **Excellent:** 2022 Revision is most recent
- ✅ Biennial updates (2024 revision expected)
- ✅ Projections available through 2100
- ✅ Historical data back to 1950
- ✅ Permanent UN program, guaranteed long-term

**Data Format & Access:**
- Format: Statistical tables (CSV, Excel, API)
- No spatial/geographic files
- Easy to access and use
- Excellent API available
- Well-documented

**Comparison to GPW v4:**
| Aspect | UN WPP | GPW v4 |
|--------|----------|--------|
| Resolution | Country level | Admin centroids |
| Data Type | Statistical tables | Spatial/Geographic |
| Recency | 2022 | 2020, discontinued |
| Spatial detail | None | ~1km points |
| Accuracy | Authoritative totals | Derived from UN |
| Easy admin join | No spatial data | Yes |

**Suitability for metalpop:**
- ❌ **Low:** Not suitable for direct use:
  - No spatial/geographic data
  - Only country-level totals
  - Cannot be joined to sub-national admin boundaries
- ✅ **Useful as reference:** Good for validation and total population verification

---

## Alternative Dataset 5: Meta (Facebook) High Resolution Population Density Maps

**Overview:**
- **Source:** Meta (formerly Facebook) in partnership with CIESIN
- **Website:** https://data.humdata.org/organization/facebook (via HDX)
- **Latest Data:** 2019 (no updates since)
- **Resolution:** 30m (1 arc-second)
- **Format:** GeoTIFF raster
- **Coverage:** ~230 countries and territories
- **Update Frequency:** Discontinued (last update 2019)
- **License:** CC BY International

**Detailed Evaluation:**

**Coverage:**
- ✅ **Very Good:** ~230 countries covered
- ⚠️ Some countries/regions missing
- ✅ Very high resolution (30m)
- ❌ Not updated since 2019

**Accuracy:**
- ⚠️ **Mixed - Mentioned as "unreliable" in issue:**
- Methodology:
  - Computer vision on satellite imagery
  - Machine learning for building detection
  - Population distribution based on detected settlements
  - Census data as constraints
- ✅ Very high spatial resolution
- ❌ Validation studies show significant errors in some regions:
  - Overestimates in urban areas
  - Underestimates in rural areas
  - Building detection errors
  - Issues with informal settlements
- ❌ Quality varies significantly by country
- ❌ Limited documentation on validation results

**Recency:**
- ❌ **Poor:** Last update was 2019
- ❌ Meta discontinued the program
- ❌ No future updates expected
- ❌ Already outdated (6 years old)

**Data Format & Access:**
- Format: GeoTIFF raster
- Available via Humanitarian Data Exchange (HDX)
- Large file sizes
- Some download issues reported

**Comparison to GPW v4:**
| Aspect | Meta HRPDM | GPW v4 |
|--------|----------|--------|
| Resolution | 30m | ~1km |
| Data Type | Raster | Admin centroids |
| Recency | 2019, discontinued | 2020, discontinued |
| Method | CV + ML on imagery | Census redistribution |
| Accuracy | Mixed/unreliable | Well-validated |
| Easy admin join | No (requires processing) | Yes |

**Suitability for metalpop:**
- ❌ **Low:** Not recommended:
  - Mentioned as unreliable in the issue
  - Discontinued with no updates since 2019
  - Quality concerns in validation
  - Already significantly outdated
  - Processing burden with large files

---

## Alternative Dataset 6: GPWv4.11 with Custom Updates

**Overview:**
- Continue using SEDAC GPW v4.11 but supplement with custom updates

**Approach:**
- Use GPW v4.11 as base (2020 data)
- Apply growth rates from UN World Population Prospects to project forward
- Manual updates for specific regions as needed

**Evaluation:**

**Pros:**
- ✅ Maintains compatibility with existing workflow
- ✅ Well-understood methodology
- ✅ Admin-based format ideal for the use case
- ✅ Can leverage UN projections for updates

**Cons:**
- ❌ No official support or updates
- ❌ Manual work required for updates
- ❌ Projections less accurate than updated datasets
- ❌ Long-term maintenance burden
- ❌ Cannot capture structural changes (new admin units, migrations, etc.)

**Suitability:**
- ⚠️ **Short-term solution only:** Not sustainable long-term

---

## Recommended Alternatives

### Tier 1 Recommendations (Best Data Quality - Requires Raster Pipeline)

#### 1. **WorldPop (Constrained Top-Down)** - PRIMARY RECOMMENDATION

**Why:**
- ✅ Actively maintained with annual updates
- ✅ Most recent data available (2020, with projections to 2025)
- ✅ High resolution (~100m) better than GPW
- ✅ UN-adjusted estimates available (comparable to GPW)
- ✅ Fully open license (CC BY 4.0)
- ✅ Strong ongoing funding
- ✅ Excellent documentation and support

**Challenges:**
- ⚠️ Requires alternate raster-to-vector pipeline
- ⚠️ Slower processing than GPW point data (2-8 hours global, optimizable)
- ⚠️ Larger file sizes (~15-20 GB for global 100m)

**Implementation Path:**
1. Download country-level constrained WorldPop datasets
2. Use zonal statistics to aggregate population to admin boundaries
3. Calculate centroids with population sums
4. Generate point file similar to GPW format
5. Add to Makefile (e.g., `make worldpop_admin`)

**Estimated Effort:** Moderate-High (1-3 weeks initial development, then ~4-8 hours per annual update)

---

#### 2. **GHS-POP (Global Human Settlement Layer)** - STRONG ALTERNATIVE

**Why:**
- ✅ Fully open EU-funded program
- ✅ Regular updates (2-3 years)
- ✅ Multiple resolutions (1km matches GPW - faster processing!)
- ✅ Excellent methodology and validation
- ✅ Can redistribute freely
- ✅ Part of comprehensive settlement ecosystem

**Challenges:**
- ⚠️ Requires alternate raster-to-vector pipeline
- ⚠️ Updates less frequent than WorldPop (2-3 years vs annual)
- ⚠️ May underestimate rural populations

**Implementation Path:**
- Similar to WorldPop
- Use 1km resolution for faster processing (2GB, ~2-4 hours)
- Or use 100m for higher accuracy

**Estimated Effort:** Moderate-High (1-3 weeks initial development, faster updates with 1km resolution)

---

### Tier 2 Recommendations

#### 3. **LandScan** - HIGH QUALITY BUT LICENSED

**Why:**
- ✅ Excellent quality and validation
- ✅ Most recent data (2022)
- ✅ Annual updates
- ✅ Same resolution as GPW (1km)
- ✅ Long-term U.S. government funding

**Challenges:**
- ⚠️ Requires alternate raster-to-vector pipeline
- ❌ License restrictions
- ❌ Cannot redistribute
- ⚠️ Ambient population vs residential (conceptual difference)
- ⚠️ May require license for non-research use

**When to Consider:**
- If the project is pure research
- If license restrictions are acceptable
- If highest quality and recency are priority

---

### Tier 3: Pragmatic Options

#### 4. **GPW v4.11 + UN Population Projections** - KEEP EXISTING PIPELINE

**Why:**
- ✅ **ZERO new development** - uses existing GPW pipeline
- ✅ Fast processing (existing workflow)
- ✅ Can generate 2021-2030 estimates with UN growth rates
- ✅ Good for fallback or legacy compatibility

**Challenges:**
- ❌ Base data frozen at 2020
- ❌ Only projections, not true updated data
- ❌ Cannot capture structural changes
- ❌ Accuracy degrades over time

**Use Case:**
- Maintain as fallback alongside raster pipeline
- Quick processing option
- Legacy compatibility

**Implementation effort:** Low (1-2 days to add UN projection capability)

---

### Not Recommended

#### ❌ Meta High Resolution Population Density Maps
- Discontinued since 2019
- Quality concerns noted in issue
- No path to updates

#### ❌ UN World Population Prospects (as primary source)
- No spatial data
- Country-level only
- Useful only for validation

---

## Implementation Roadmap

### Phase 1: Proof of Concept (WorldPop)
1. Download WorldPop data for test region (e.g., Finland)
2. Develop processing pipeline:
   - Aggregate raster to admin boundaries
   - Calculate admin unit centroids
   - Generate point shapefile with population
3. Test join with Natural Earth boundaries
4. Compare results with GPW-based output
5. Validate population totals

### Phase 2: Global Implementation
1. Expand to global coverage
2. Optimize processing for large datasets
3. Update Makefile with WorldPop targets
4. Document data source changes
5. Update README

### Phase 3: Automation & Updates
1. Create update scripts for new WorldPop releases
2. Implement automated downloads
3. Set up annual update workflow
4. Add data quality checks

---

## Technical Considerations

### Data Processing Requirements

**For Raster Datasets (WorldPop, GHS-POP, LandScan):**

Tools needed:
- GDAL (already in use)
- Python with rasterio or similar
- PostGIS for spatial operations (already used)

Processing steps:
```bash
# 1. Download raster data
# 2. Clip to admin boundaries or process globally
# 3. Calculate zonal statistics per admin unit
gdal_polygonize.py or rasterio
# 4. Join with admin boundary geometries
ogr2ogr or PostGIS ST_Union
# 5. Calculate centroids
ST_Centroid in PostGIS
# 6. Export to shapefile matching GPW format
```

### Data Volume Considerations

| Dataset | Global Size | Resolution | Format |
|---------|------------|------------|---------|
| GPW v4 | ~500 MB | 1 km | Points |
| WorldPop | ~15-20 GB | 100m | Raster |
| GHS-POP 1km | ~2 GB | 1 km | Raster |
| GHS-POP 100m | ~25 GB | 100m | Raster |
| LandScan | ~1 GB | 1 km | Raster |

### Workflow Compatibility

Current workflow:
- GPW provides admin unit centroids with population
- Direct join to Natural Earth boundaries
- Simple, fast processing

Alternate workflow (raster-based):
- More complex preprocessing required
- Computational overhead (slower processing)
- Need to recalculate for each new admin boundary dataset
- But: More flexible, higher accuracy potential, access to actively maintained datasets

### Performance Optimization for Raster-to-Vector Pipeline

**Known Issue:** Raster-to-vector aggregation (zonal statistics) can be very slow for high-resolution global datasets.

**Optimization Strategies:**

1. **Use Lower Resolution Where Possible**
   - GHS-POP 1km instead of 100m (2GB vs 25GB)
   - Matches GPW resolution
   - Significantly faster processing

2. **Process by Country/Region**
   - Download country-specific WorldPop files instead of global
   - Process in parallel (multiple regions simultaneously)
   - Reduce memory requirements

3. **Optimize Zonal Statistics Tools**
   ```bash
   # Fast option: rasterstats Python library
   pip install rasterstats
   
   # Use gdal_rasterize for vector-to-raster mask
   gdal_rasterize -burn 1 -a admin_id admin_boundaries.shp mask.tif
   
   # Then use numpy for fast aggregation
   ```

4. **Use Efficient PostGIS Queries**
   ```sql
   -- Create spatial index first
   CREATE INDEX ON admin_boundaries USING GIST (geom);
   
   -- Use ST_SummaryStats for raster aggregation
   SELECT admin_id, 
          (ST_SummaryStats(ST_Clip(raster, geom))).sum as population
   FROM raster_table, admin_boundaries
   WHERE ST_Intersects(raster, geom)
   GROUP BY admin_id;
   ```

5. **Pre-compute and Cache**
   - Process raster → admin aggregation once per data release
   - Store results as intermediate files
   - Reuse for different boundary joins

6. **Use Cloud Processing**
   - Google Earth Engine has GHS-POP pre-loaded
   - Can do zonal stats at scale
   - Export aggregated results

**Estimated Processing Times (approximate):**
- GHS-POP 1km global → admin units: ~2-4 hours (optimized)
- WorldPop 100m country → admin units: ~10-30 min per country
- With parallelization: Process all countries in ~4-8 hours

### Parallelization Approaches

**Recommended: Country-level Parallelization**

The most effective parallelization strategy is to process countries independently since WorldPop provides country-specific files and admin boundaries are naturally partitioned by country.

**Option 1: Python Multiprocessing (Simple, No Dependencies)**

Best for: Simple parallelization without additional dependencies

```python
from multiprocessing import Pool
import rasterstats
import geopandas as gpd
import rasterio

def process_country(country_code):
    """Process a single country's raster data"""
    # Load country-specific data
    raster_path = f"worldpop/{country_code}_ppp_2020.tif"
    admin_boundaries = gpd.read_file(f"admin/{country_code}_admin.shp")
    
    # Calculate zonal statistics
    stats = rasterstats.zonal_stats(
        admin_boundaries.geometry,
        raster_path,
        stats=['sum'],
        nodata=0
    )
    
    # Add population to boundaries
    admin_boundaries['population'] = [s['sum'] for s in stats]
    
    # Save result
    admin_boundaries.to_file(f"output/{country_code}_result.shp")
    return country_code

if __name__ == '__main__':
    countries = ['USA', 'CAN', 'MEX', 'BRA', 'ARG', ...]  # All countries
    
    # Process in parallel using all CPU cores
    with Pool() as pool:
        results = pool.map(process_country, countries)
    
    print(f"Processed {len(results)} countries")
```

**Pros:**
- ✅ Built into Python standard library
- ✅ Simple to implement
- ✅ Scales to all CPU cores
- ✅ Good for country-level processing (200+ countries)

**Cons:**
- ⚠️ Limited to single machine
- ⚠️ No distributed computing across multiple machines

---

**Option 2: Dask (Scalable, Flexible)**

Best for: More complex workflows, distributed processing, or very large datasets

```python
import dask
from dask.distributed import Client, LocalCluster
import rasterstats
import geopandas as gpd
import dask.bag as db

def process_country(country_code):
    """Process a single country's raster data"""
    raster_path = f"worldpop/{country_code}_ppp_2020.tif"
    admin_boundaries = gpd.read_file(f"admin/{country_code}_admin.shp")
    
    stats = rasterstats.zonal_stats(
        admin_boundaries.geometry,
        raster_path,
        stats=['sum'],
        nodata=0
    )
    
    admin_boundaries['population'] = [s['sum'] for s in stats]
    admin_boundaries.to_file(f"output/{country_code}_result.shp")
    return country_code

if __name__ == '__main__':
    # Set up Dask cluster
    cluster = LocalCluster(n_workers=8, threads_per_worker=2)
    client = Client(cluster)
    
    countries = ['USA', 'CAN', 'MEX', 'BRA', 'ARG', ...]
    
    # Create Dask bag and map processing function
    bag = db.from_sequence(countries, partition_size=10)
    results = bag.map(process_country).compute()
    
    print(f"Processed {len(results)} countries")
    client.close()
```

**Pros:**
- ✅ Can scale to multiple machines (distributed cluster)
- ✅ Better monitoring and diagnostics (dashboard)
- ✅ Can handle larger-than-memory datasets
- ✅ Integrates well with scientific Python stack

**Cons:**
- ⚠️ Additional dependency (pip install dask distributed)
- ⚠️ Slightly more complex setup
- ⚠️ Overkill for simple country-level parallelization

**When to use Dask:**
- Processing global raster as single dataset (not country files)
- Need to distribute across multiple machines
- Working with larger-than-memory rasters
- Want monitoring dashboard and better diagnostics

---

**Option 3: GNU Parallel (Shell-based)**

Best for: Quick parallelization of existing scripts without code changes

```bash
#!/bin/bash
# process_country.sh - Process single country
COUNTRY=$1
python3 - <<EOF
import rasterstats
import geopandas as gpd

admin = gpd.read_file('admin/${COUNTRY}_admin.shp')
stats = rasterstats.zonal_stats(admin.geometry, 
                                  'worldpop/${COUNTRY}_ppp_2020.tif',
                                  stats=['sum'])
admin['population'] = [s['sum'] for s in stats]
admin.to_file('output/${COUNTRY}_result.shp')
print('Processed ${COUNTRY}')
EOF

# Run in parallel using GNU Parallel
cat countries.txt | parallel -j 8 ./process_country.sh {}
```

**Pros:**
- ✅ No Python code changes needed
- ✅ Easy to understand and debug
- ✅ Works with any existing scripts
- ✅ Simple progress monitoring

**Cons:**
- ⚠️ Requires GNU Parallel installed
- ⚠️ Less flexible than Python solutions
- ⚠️ Harder to share data between processes

---

**Option 4: Makefile with Parallel Make**

Best for: Integration with existing Makefile workflow

```makefile
# Get list of all countries
COUNTRIES := USA CAN MEX BRA ARG ... (all countries)
OUTPUTS := $(foreach country,$(COUNTRIES),output/$(country)_result.shp)

# Process all countries in parallel
.PHONY: all
all: $(OUTPUTS)

# Rule to process a single country
output/%_result.shp: worldpop/%_ppp_2020.tif admin/%_admin.shp
	python3 scripts/process_country.py $*

# Run with: make -j 8 all
```

**Pros:**
- ✅ Integrates with existing Makefile
- ✅ Make handles dependency tracking
- ✅ Simple parallelization with -j flag
- ✅ Can resume if interrupted

**Cons:**
- ⚠️ Limited to single machine
- ⚠️ Less dynamic than Python solutions

---

**Recommendation for metalpop:**

**Use Python multiprocessing (Option 1)** for simplicity:

```python
# scripts/process_worldpop_parallel.py
from multiprocessing import Pool
import os
import rasterstats
import geopandas as gpd
from pathlib import Path

def process_country(country_info):
    """Process a single country"""
    country_code, raster_path, admin_path = country_info
    
    print(f"Processing {country_code}...")
    
    try:
        # Load data
        admin = gpd.read_file(admin_path)
        
        # Calculate population per admin unit
        stats = rasterstats.zonal_stats(
            admin.geometry,
            raster_path,
            stats=['sum'],
            nodata=-99999
        )
        
        admin['UN_2020_E'] = [s['sum'] if s['sum'] else 0 for s in stats]
        
        # Calculate centroids
        admin['INSIDE_X'] = admin.geometry.centroid.x
        admin['INSIDE_Y'] = admin.geometry.centroid.y
        
        # Save
        output_path = f"temp/worldpop_{country_code}.shp"
        admin[['NAME', 'UN_2020_E', 'INSIDE_X', 'INSIDE_Y', 'geometry']].to_file(output_path)
        
        return country_code, True, None
    except Exception as e:
        return country_code, False, str(e)

if __name__ == '__main__':
    # Discover all country files
    worldpop_dir = Path("worldpop")
    countries = []
    
    for raster_file in worldpop_dir.glob("*_ppp_2020.tif"):
        country_code = raster_file.stem.split('_')[0]
        admin_path = f"admin/{country_code}_admin.shp"
        
        if os.path.exists(admin_path):
            countries.append((country_code, str(raster_file), admin_path))
    
    print(f"Found {len(countries)} countries to process")
    
    # Process in parallel (use all cores)
    num_cores = os.cpu_count()
    print(f"Using {num_cores} cores")
    
    with Pool(processes=num_cores) as pool:
        results = pool.map(process_country, countries)
    
    # Report results
    successful = [r for r in results if r[1]]
    failed = [r for r in results if not r[1]]
    
    print(f"\nCompleted: {len(successful)}/{len(countries)} countries")
    if failed:
        print(f"Failed: {len(failed)}")
        for country, _, error in failed:
            print(f"  - {country}: {error}")
```

**Update Makefile:**

```makefile
worldpop_admin_parallel:
	mkdir -p temp
	python3 scripts/process_worldpop_parallel.py
	# Merge all country results
	mapshaper-xl -i "temp/worldpop_*.shp" \
		combine-files \
		-merge-layers \
		-o temp/worldpop_global.shp
	# Join to boundaries
	mapshaper-xl -i naturalearth/ne_10m_admin_1_states_provinces.shp \
		-join temp/worldpop_global.shp \
		sum-fields="UN_2020_E" \
		-o output/ne_10m_admin_1_pop_worldpop.shp
	rm -rf temp/
```

**Performance Estimate with Parallelization:**
- 8 cores: Process 200 countries in ~2-4 hours
- 16 cores: Process 200 countries in ~1-2 hours
- Nearly linear scaling up to number of countries

**Use Dask only if:**
- You need to process a single global raster (not country files)
- You want to distribute across multiple machines
- You need advanced monitoring/debugging

For the metalpop use case, **multiprocessing is the sweet spot**: simple, effective, no extra dependencies.

---

## Critical Consideration: Raster vs Point-Based Data

**⚠️ IMPORTANT:** All modern high-quality population datasets (WorldPop, GHS-POP, LandScan) are **raster-based**, while the current metalpop pipeline is built around GPW's **admin centroid point format**. 

### Alternate Pipeline Approach

**An alternate raster-to-vector pipeline can be created** to work with modern datasets:

**What it requires:**
- New data ingestion pipeline for raster processing
- Zonal statistics to aggregate population to admin boundaries
- Tools: GDAL, PostGIS, Python (rasterio/rasterstats)
- Increased processing time (slower than point-based)
- Larger storage requirements (raster files are bigger)

**Trade-offs:**
- ✅ Access to actively maintained, high-quality datasets
- ✅ Higher resolution data available
- ✅ Annual updates (WorldPop) or regular updates (GHS-POP)
- ⚠️ Slower processing (can be optimized, see performance section)
- ⚠️ More complex pipeline
- ⚠️ Needs to run for each new admin boundary dataset

**This is feasible and worth doing** to access current population data, but requires accepting slower processing times.

### The Fundamental Trade-off

There are **no actively maintained, high-quality alternatives** that provide data in GPW's admin centroid point format. The choice is:

1. **Build alternate raster pipeline** → Access to current, actively maintained datasets (with slower processing)
2. **Keep current pipeline only** → Use increasingly outdated GPW v4.11 data (frozen at 2020) or projections

Both approaches are valid depending on project needs.

---

## Conclusion & Recommendations

### Recommended Approach: Dual Pipeline Strategy

**Primary: WorldPop with Alternate Raster Pipeline** (for current data)

Build an alternate pipeline for raster-based data:
- ✅ Actively maintained with annual updates
- ✅ Highest quality methodology
- ✅ 2020+ data available
- ✅ Long-term sustainability
- ⚠️ Slower processing (2-8 hours for global, can be optimized)
- ⚠️ Requires new pipeline development

**Implementation effort:** Moderate-High (1-3 weeks)
- See [Performance Optimization](#performance-optimization-for-raster-to-vector-pipeline) section for speed improvements
- Use GHS-POP 1km for faster processing vs WorldPop 100m

**Secondary: GHS-POP as alternative**
- Similar benefits to WorldPop
- 1km resolution matches GPW (faster processing)
- Updates every 2-3 years vs annual

---

### Optional: Keep GPW Pipeline for Backwards Compatibility

**GPW v4.11 + UN Growth Rates** (legacy/fallback option)

Can maintain existing GPW pipeline alongside raster pipeline:

**Pros:**
- ✅ Zero changes to existing workflow
- ✅ Fast processing (existing pipeline)
- ✅ Can generate 2021-2025 estimates with UN projections
- ✅ Fallback if raster processing fails

**Cons:**
- ❌ Base data frozen at 2020
- ❌ Only projections, not true updated data
- ❌ Accuracy degrades over time

**Use case:** Maintain as fallback or for quick processing while raster pipeline is being developed

---

### Implementation Recommendation

**Phase 1: Develop Raster Pipeline (2-4 weeks)**
1. Start with test region (e.g., Finland)
2. Implement zonal statistics workflow
3. Optimize for performance
4. Validate against GPW results

**Phase 2: Production Deployment (1-2 weeks)**
1. Scale to global coverage
2. Add to Makefile as `make worldpop_admin` or similar
3. Document usage and performance characteristics
4. Set up caching for processed results

**Phase 3: Ongoing (minimal)**
1. Run raster pipeline annually for WorldPop updates
2. Cache results for reuse
3. Keep existing GPW pipeline for reference/fallback

---

## Final Recommendation

**Build the alternate raster-to-vector pipeline** to access WorldPop or GHS-POP data.

**Why:**
- Only way to get actively maintained, high-quality population data
- Processing time is acceptable trade-off (2-8 hours once per year)
- Can be heavily optimized (see performance section)
- Provides long-term sustainability

**Keep existing GPW pipeline** as fallback or for legacy compatibility:
- Fast processing when needed
- Can extend with UN projections for 2021-2025 estimates
- Useful for validation and comparison

**Reality:** There is no perfect solution. The raster pipeline accepts slower processing in exchange for current data. This is the pragmatic choice for maintaining data quality and relevance.
