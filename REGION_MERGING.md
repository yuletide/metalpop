# Region Merging for MAUP Resolution

## Overview

This feature addresses the Modifiable Area Unit Problem (MAUP) by allowing administrative regions to be merged before population and band data joins. This is particularly useful for metropolitan areas where geocoding places all bands at a city centroid, but political boundaries are divided into smaller units (e.g., London boroughs).

## Problem Description

The MAUP issue occurs when:
1. Band data from Metal-Archives is geocoded to a city name (e.g., "London")
2. The geocoder places all bands at the city's centroid (e.g., Kensington)
3. Administrative boundaries (Admin-1) include separate boroughs
4. Population data is correctly distributed across boroughs
5. When calculating per-capita rates, all city bands are counted against only one borough's population
6. Result: Artificially inflated per-capita rates for the centroid borough

## Solution

The solution merges specified administrative regions before the population join:
1. A configuration file (`region_merges.json`) specifies which regions to merge
2. The `merge_regions.py` script applies these merges using mapshaper
3. Boundaries are dissolved into larger regions
4. Population values are summed for merged regions
5. Band joins and per-capita calculations use the merged regions

## Configuration

Edit `region_merges.json` to configure region merges:

```json
{
  "merges": [
    {
      "description": "Human-readable description of the merge",
      "country": "Country name (for documentation)",
      "parent_name": "Name for the merged region",
      "merge_field": "name",
      "regions_to_merge": [
        "Region 1",
        "Region 2",
        "Region 3"
      ]
    }
  ]
}
```

### Fields:
- `description`: Human-readable explanation of why this merge is needed
- `country`: Country name (documentation only, not used in matching)
- `parent_name`: The name to give the merged region
- `merge_field`: Field name to match against (usually "name")
- `regions_to_merge`: Array of region names that should be merged together

### Example: London Boroughs

The default configuration merges all 33 Greater London boroughs:

```json
{
  "merges": [
    {
      "description": "Merge all Greater London boroughs into a single Greater London region",
      "country": "United Kingdom",
      "parent_name": "Greater London",
      "merge_field": "name",
      "regions_to_merge": [
        "Kensington and Chelsea",
        "Westminster",
        "Camden",
        ...
      ]
    }
  ]
}
```

## Usage

The merge is automatically applied when running:

```bash
make all
```

Or manually:

```bash
# Just merge regions
make merge_regions

# Complete workflow with merging
make admin_pop
```

## How It Works

1. **Input**: Natural Earth Admin-1 shapefile with original boundaries
2. **Processing**: 
   - Script adds a `merge_group` field to each feature
   - Regions in the merge config get assigned the parent_name
   - Other regions keep their original name as merge_group
   - Mapshaper dissolves boundaries by merge_group
   - Population fields are summed during dissolution
3. **Output**: Merged shapefile with consolidated regions

## Adding New Merges

To add merges for other metropolitan areas:

1. Identify the problem: Check your map for artificially high per-capita rates
2. Find the region names: Look at the attribute table in QGIS or run:
   ```bash
   ogrinfo -al -geom=NO naturalearth/ne_10m_admin_1_states_provinces.shp | grep "name ="
   ```
3. Add to `region_merges.json`:
   ```json
   {
     "description": "Merge Paris metropolitan regions",
     "country": "France",
     "parent_name": "Île-de-France",
     "merge_field": "name",
     "regions_to_merge": [
       "Paris",
       "Hauts-de-Seine",
       "Seine-Saint-Denis",
       "Val-de-Marne"
     ]
   }
   ```
4. Run the workflow: `make all`

## Technical Details

### Script: `merge_regions.py`

The merge script uses mapshaper's `-dissolve` command:

```bash
mapshaper-xl \
  -i input.shp \
  -each 'assign merge_group based on config' \
  -dissolve merge_group sum-fields=UN_2000_E,UN_2005_E,UN_2020_E,TOTAL_A_KM \
  -o output.shp
```

### Makefile Integration

The `admin_pop` target now includes:

```makefile
admin_pop:
    mkdir -p temp output
    csv                    # Create population points
    merge_regions          # Merge configured regions
    mapshaper_join        # Join population to merged regions
    rm -rf temp/
```

## Extensibility

This solution is designed to be extended to:
- Other metropolitan areas worldwide
- Different administrative levels (Admin-0, Admin-2)
- Other vector data sources (GADM, custom boundaries)
- Statistical detection of MAUP anomalies (future enhancement)

## Future Enhancements

1. **Automated Detection**: Statistical analysis to detect MAUP issues
2. **Multiple Merge Levels**: Support Admin-0, Admin-2 merges
3. **Population Reapportionment**: Use area-weighted distribution for unmerged cases
4. **Validation Reports**: Generate before/after comparison statistics
