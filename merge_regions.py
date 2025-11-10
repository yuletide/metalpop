#!/usr/bin/env python3
"""
Merge administrative regions based on configuration to solve MAUP issues.

This script reads a configuration file specifying which Admin-1 regions should
be merged together (e.g., London boroughs) and creates a modified shapefile
with merged boundaries and aggregated population values.
"""

import json
import subprocess
import sys
import os
from pathlib import Path


def load_merge_config(config_path):
    """Load the region merge configuration from JSON file."""
    with open(config_path, 'r') as f:
        config = json.load(f)
    return config.get('merges', [])


def create_mapshaper_expressions(merges):
    """
    Create mapshaper expressions to assign merge groups.
    
    Returns a JavaScript expression that assigns a 'merge_group' field
    to each feature based on the merge configuration.
    """
    expressions = []
    
    for merge in merges:
        parent_name = merge['parent_name']
        merge_field = merge.get('merge_field', 'name')
        regions = merge['regions_to_merge']
        
        # Create a condition for this merge group
        conditions = [f"this.properties.{merge_field} === '{region}'" for region in regions]
        condition_str = " || ".join(conditions)
        
        expressions.append(
            f"if ({condition_str}) {{ this.properties.merge_group = '{parent_name}'; }}"
        )
    
    # Set merge_group to the original name for unmerged regions
    expressions.append("if (!this.properties.merge_group) { this.properties.merge_group = this.properties.name; }")
    
    return " ".join(expressions)


def merge_admin_regions(input_shapefile, output_shapefile, config_path, sum_fields=None):
    """
    Merge administrative regions using mapshaper based on configuration.
    
    Args:
        input_shapefile: Path to input shapefile
        output_shapefile: Path to output shapefile
        config_path: Path to merge configuration JSON
        sum_fields: Comma-separated list of fields to sum during merge
    """
    
    # Load merge configuration
    merges = load_merge_config(config_path)
    
    if not merges:
        print("No merges configured, copying input to output")
        subprocess.run(['cp', input_shapefile, output_shapefile], check=True)
        return
    
    # Create mapshaper expression
    js_expression = create_mapshaper_expressions(merges)
    
    # Default sum fields for population data
    if sum_fields is None:
        sum_fields = "UN_2000_E,UN_2005_E,UN_2020_E,TOTAL_A_KM"
    
    # Build mapshaper command
    cmd = [
        'mapshaper-xl',
        '-i', input_shapefile,
        '-each', js_expression,
        '-dissolve', 'merge_group',
        f'sum-fields={sum_fields}',
        'copy-fields=name,iso_a2,admin',
        '-each', 'name=merge_group',
        '-o', output_shapefile
    ]
    
    print(f"Running: {' '.join(cmd)}")
    
    try:
        result = subprocess.run(cmd, check=True, capture_output=True, text=True)
        print(result.stdout)
        if result.stderr:
            print("Warnings:", result.stderr, file=sys.stderr)
        print(f"Successfully created merged shapefile: {output_shapefile}")
    except subprocess.CalledProcessError as e:
        print(f"Error running mapshaper: {e}", file=sys.stderr)
        print(f"stdout: {e.stdout}", file=sys.stderr)
        print(f"stderr: {e.stderr}", file=sys.stderr)
        sys.exit(1)


def main():
    """Main entry point."""
    if len(sys.argv) < 3:
        print("Usage: merge_regions.py <input_shapefile> <output_shapefile> [config_path] [sum_fields]")
        print("Example: merge_regions.py input.shp output.shp region_merges.json")
        sys.exit(1)
    
    input_shapefile = sys.argv[1]
    output_shapefile = sys.argv[2]
    config_path = sys.argv[3] if len(sys.argv) > 3 else 'region_merges.json'
    sum_fields = sys.argv[4] if len(sys.argv) > 4 else None
    
    if not os.path.exists(input_shapefile):
        print(f"Error: Input shapefile not found: {input_shapefile}", file=sys.stderr)
        sys.exit(1)
    
    if not os.path.exists(config_path):
        print(f"Error: Config file not found: {config_path}", file=sys.stderr)
        sys.exit(1)
    
    merge_admin_regions(input_shapefile, output_shapefile, config_path, sum_fields)


if __name__ == '__main__':
    main()
