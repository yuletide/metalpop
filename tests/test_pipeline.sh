#!/bin/bash
# Integration tests for data processing pipeline with mock data

set -e

# Source test helpers
source "$(dirname "$0")/test_helper.sh"

echo "========================================"
echo "Testing Data Pipeline with Mock Data"
echo "========================================"

setup_test_env

# Create mock test data
echo "Creating mock test data..."

# Create mock CSV data for population points
MOCK_CSV="$TEST_DIR/mock_population.csv"
cat > "$MOCK_CSV" << 'EOF'
INSIDE_X,INSIDE_Y,UN_2020_E,NAME1,TOTAL_A_KM
-95.7129,37.0902,3000000,Kansas,213100
-98.4842,39.0119,2900000,Kansas,213100
-94.6859,39.1006,500000,Missouri,180540
EOF

assert_file_exists "$MOCK_CSV" "Mock CSV data created"
assert_file_not_empty "$MOCK_CSV" "Mock CSV data is not empty"

# Test 1: Verify CSV has correct headers
assert_contains "$MOCK_CSV" "INSIDE_X" "CSV contains INSIDE_X column"
assert_contains "$MOCK_CSV" "INSIDE_Y" "CSV contains INSIDE_Y column"
assert_contains "$MOCK_CSV" "UN_2020_E" "CSV contains UN_2020_E column"

# Test 2: Validate CSV data structure
echo ""
echo "Validating CSV structure..."

# Count lines (should be header + 3 data rows)
LINE_COUNT=$(wc -l < "$MOCK_CSV")
assert_equals "$LINE_COUNT" "4" "CSV has correct number of lines"

# Check for required fields
HEADER=$(head -n 1 "$MOCK_CSV")
if echo "$HEADER" | grep -q "INSIDE_X" && \
   echo "$HEADER" | grep -q "INSIDE_Y" && \
   echo "$HEADER" | grep -q "UN_2020_E"; then
    echo -e "${GREEN}✓${NC} PASS: CSV has all required fields"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗${NC} FAIL: CSV missing required fields"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi
TESTS_RUN=$((TESTS_RUN + 1))

# Test 3: Create mock GeoJSON polygon for testing spatial join
echo ""
echo "Creating mock geographic boundary..."

MOCK_GEOJSON="$TEST_DIR/mock_boundary.geojson"
cat > "$MOCK_GEOJSON" << 'EOF'
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {
        "name": "Kansas",
        "admin": "United States of America",
        "iso_a2": "US"
      },
      "geometry": {
        "type": "Polygon",
        "coordinates": [[
          [-102.0, 37.0],
          [-102.0, 40.0],
          [-94.6, 40.0],
          [-94.6, 37.0],
          [-102.0, 37.0]
        ]]
      }
    }
  ]
}
EOF

assert_file_exists "$MOCK_GEOJSON" "Mock GeoJSON boundary created"
assert_file_not_empty "$MOCK_GEOJSON" "Mock GeoJSON is not empty"

# Test 4: Validate GeoJSON structure
if command -v python3 &> /dev/null; then
    assert_command_success "Mock GeoJSON is valid JSON" "python3 -m json.tool $MOCK_GEOJSON"
fi

# Test 5: Verify pipeline expects correct input formats
echo ""
echo "Verifying pipeline configuration..."

# Check that Makefile references the correct CSV fields
assert_contains "Makefile" "INSIDE_X" "Makefile uses INSIDE_X field"
assert_contains "Makefile" "INSIDE_Y" "Makefile uses INSIDE_Y field"
assert_contains "Makefile" "UN_2020_E" "Makefile uses UN_2020_E field"

# Test 6: Validate VRT configuration
echo ""
echo "Checking VRT configuration..."
VRT_FILE="sedac/gpw-v4-admin-unit-center-points-population-estimates-rev11_global_gpkg.vrt"

assert_file_exists "$VRT_FILE" "VRT file exists"
assert_contains "$VRT_FILE" "<OGRVRTDataSource>" "VRT has correct root element"
assert_contains "$VRT_FILE" "<OGRVRTLayer" "VRT defines layers"
assert_contains "$VRT_FILE" "<SrcDataSource" "VRT has source data configuration"

# Validate VRT as XML
if command -v xmllint &> /dev/null; then
    assert_command_success "VRT is valid XML" "xmllint --noout $VRT_FILE"
fi

# Test 7: Check MTS recipe configuration
echo ""
echo "Checking MTS recipe configuration..."

MTS_RECIPE="mts/recipe.json"
assert_file_exists "$MTS_RECIPE" "MTS recipe exists"
assert_contains "$MTS_RECIPE" '"version"' "Recipe has version field"
assert_contains "$MTS_RECIPE" '"layers"' "Recipe defines layers"
assert_contains "$MTS_RECIPE" '"bands_per_capita"' "Recipe has bands_per_capita layer"
assert_contains "$MTS_RECIPE" '"minzoom"' "Recipe specifies minzoom"
assert_contains "$MTS_RECIPE" '"maxzoom"' "Recipe specifies maxzoom"

# Test 8: Verify expected field names in MTS recipe
assert_contains "$MTS_RECIPE" '"UN_2020_E"' "Recipe includes UN_2020_E field"
assert_contains "$MTS_RECIPE" '"TOTAL_A_KM"' "Recipe includes TOTAL_A_KM field"
assert_contains "$MTS_RECIPE" '"bands_p100"' "Recipe includes bands_p100 field"

# Test 9: Validate population data ranges (using mock data)
echo ""
echo "Validating data ranges..."

# Check that population values are reasonable (positive numbers)
# Skip header line and check population column
INVALID_POP=false
tail -n +2 "$MOCK_CSV" | while IFS=',' read -r lon lat pop rest; do
    if ! [[ "$pop" =~ ^[0-9]+$ ]]; then
        INVALID_POP=true
        exit 1
    fi
done

TESTS_RUN=$((TESTS_RUN + 1))
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} PASS: Population values are numeric"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗${NC} FAIL: Population values contain non-numeric data"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Test 10: Check coordinate ranges (should be valid lat/lon)
echo ""
echo "Validating coordinate ranges..."

# Extract coordinates and check they're within valid ranges
# Longitude: -180 to 180, Latitude: -90 to 90
INVALID_COORDS=false
while IFS=',' read -r lon lat rest; do
    if [[ "$lon" =~ ^-?[0-9]+\.?[0-9]*$ ]] && [[ "$lat" =~ ^-?[0-9]+\.?[0-9]*$ ]]; then
        if (( $(echo "$lon < -180 || $lon > 180" | bc -l) )) || \
           (( $(echo "$lat < -90 || $lat > 90" | bc -l) )); then
            INVALID_COORDS=true
        fi
    fi
done < <(tail -n +2 "$MOCK_CSV")

TESTS_RUN=$((TESTS_RUN + 1))
if [ "$INVALID_COORDS" = false ]; then
    echo -e "${GREEN}✓${NC} PASS: Coordinates are within valid ranges"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗${NC} FAIL: Some coordinates are outside valid ranges"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

cleanup_test_env
print_test_summary
