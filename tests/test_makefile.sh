#!/bin/bash
# Unit tests for Makefile targets and dependencies

set -e

# Source test helpers
source "$(dirname "$0")/test_helper.sh"

echo "========================================"
echo "Testing Makefile Structure"
echo "========================================"

setup_test_env

# Test 1: Verify Makefile exists
assert_file_exists "Makefile" "Makefile exists"

# Test 2: Check for required targets
assert_contains "Makefile" "^csv:" "CSV target is defined"
assert_contains "Makefile" "^admin_pop:" "admin_pop target is defined"
assert_contains "Makefile" "^admin_pop_test:" "admin_pop_test target is defined"
assert_contains "Makefile" "^mapshaper_join:" "mapshaper_join target is defined"
assert_contains "Makefile" "^get_natural_earth:" "get_natural_earth target is defined"
assert_contains "Makefile" "^admin_bands:" "admin_bands target is defined"
assert_contains "Makefile" "^mts_tiles:" "mts_tiles target is defined"

# Test 3: Verify SQL files exist
echo ""
echo "Checking SQL files..."
assert_file_exists "sql/0_create_geom_inside.sql" "SQL file for creating geom_inside exists"
assert_file_exists "sql/ne_gpw.sql" "SQL file for ne_gpw join exists"
assert_file_exists "sql/gadm_gpw.sql" "SQL file for gadm_gpw join exists"

# Test 4: Check SQL file syntax (basic validation)
assert_file_not_empty "sql/0_create_geom_inside.sql" "SQL file 0_create_geom_inside.sql is not empty"
assert_contains "sql/0_create_geom_inside.sql" "ALTER TABLE gpw" "SQL contains ALTER TABLE statement"
assert_contains "sql/0_create_geom_inside.sql" "ST_Point" "SQL uses PostGIS ST_Point function"

# Test 5: Verify config files
echo ""
echo "Checking configuration files..."
assert_file_exists "mts/recipe.json" "MTS recipe.json exists"
assert_file_exists "sedac/gpw-v4-admin-unit-center-points-population-estimates-rev11_global_gpkg.vrt" "SEDAC VRT file exists"

# Test 6: Validate JSON files
if command -v python3 &> /dev/null; then
    assert_command_success "MTS recipe.json is valid JSON" "python3 -m json.tool mts/recipe.json"
fi

# Test 7: Check for documentation
assert_file_exists "Readme.md" "README file exists"
assert_contains "Readme.md" "METAL POP" "README contains project title"
assert_contains "Readme.md" "## Requirements" "README contains requirements section"

cleanup_test_env
print_test_summary
