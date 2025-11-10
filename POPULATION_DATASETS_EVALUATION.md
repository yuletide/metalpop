# Global Population Datasets: Alternatives to SEDAC GPW v4

## Executive Summary

This document evaluates alternative global population datasets to replace SEDAC GPW v4 (Gridded Population of the World version 4) following the discontinuation of SEDAC funding. The evaluation focuses on coverage, accuracy, recency, and suitability for joining with global political boundaries.

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

### Tier 1 Recommendations (Best Options)

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
- ⚠️ Raster format requires conversion to admin centroids
- ⚠️ Processing overhead for large datasets
- ⚠️ Different data model than GPW (requires workflow changes)

**Implementation Path:**
1. Download country-level constrained WorldPop datasets
2. Use zonal statistics to aggregate population to admin boundaries
3. Calculate centroids with population sums
4. Generate point file similar to GPW format
5. Update Makefile to handle WorldPop data

**Estimated Effort:** Medium (requires new processing pipeline)

---

#### 2. **GHS-POP (Global Human Settlement Layer)** - STRONG ALTERNATIVE

**Why:**
- ✅ Fully open EU-funded program
- ✅ Regular updates (2-3 years)
- ✅ Multiple resolutions (1km matches GPW)
- ✅ Excellent methodology and validation
- ✅ Can redistribute freely
- ✅ Part of comprehensive settlement ecosystem

**Challenges:**
- ⚠️ Raster format requires conversion
- ⚠️ Updates less frequent than WorldPop (2-3 years vs annual)
- ⚠️ May underestimate rural populations

**Implementation Path:**
- Similar to WorldPop
- Could use 1km resolution for direct GPW replacement
- Or use 100m for higher accuracy

**Estimated Effort:** Medium (requires new processing pipeline)

---

### Tier 2 Recommendations (Good Options with Caveats)

#### 3. **LandScan** - HIGH QUALITY BUT LICENSED

**Why:**
- ✅ Excellent quality and validation
- ✅ Most recent data (2022)
- ✅ Annual updates
- ✅ Same resolution as GPW (1km)
- ✅ Long-term U.S. government funding

**Challenges:**
- ❌ License restrictions
- ❌ Cannot redistribute
- ❌ Ambient population vs residential (conceptual difference)
- ⚠️ May require license for non-research use

**When to Consider:**
- If the project is pure research
- If license restrictions are acceptable
- If highest quality and recency are priority

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

New workflow (raster-based):
- More complex preprocessing required
- Computational overhead
- Need to recalculate for each new admin boundary dataset
- But: More flexible, higher accuracy potential

---

## Conclusion

**Primary Recommendation: WorldPop**

WorldPop is the best alternative to SEDAC GPW v4 for the metalpop project:

1. **Quality:** Excellent accuracy with modern ML methods and ancillary data
2. **Recency:** Actively maintained with annual updates (most recent among alternatives)
3. **Sustainability:** Well-funded with long-term commitment
4. **Openness:** CC BY 4.0 license, no restrictions
5. **Resolution:** Higher than GPW (100m vs 1km) for better accuracy

**Secondary Recommendation: GHS-POP**

GHS-POP is an excellent fallback or complementary option:
- EU-funded program with strong commitment
- Fully open with no restrictions
- Part of comprehensive settlement data ecosystem
- Multiple resolution options

**Implementation Strategy:**
1. Start with WorldPop for active, up-to-date data
2. Consider GHS-POP as validation or alternative
3. Maintain GPW v4.11 data temporarily for comparison
4. Develop processing pipeline to convert raster to admin centroids
5. Update workflow documentation

The transition from GPW to WorldPop will require workflow changes, but the benefits of ongoing updates, higher resolution, and improved methodology make it worthwhile for long-term sustainability of the metalpop project.
