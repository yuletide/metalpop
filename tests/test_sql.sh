#!/bin/bash
# Tests for SQL queries and database schema

set -e

# Source test helpers
source "$(dirname "$0")/test_helper.sh"

echo "========================================"
echo "Testing SQL Queries"
echo "========================================"

setup_test_env

# Test 1: Verify all SQL files exist
echo "Checking SQL file existence..."
SQL_FILES=(
    "sql/0_create_geom_inside.sql"
    "sql/1_eb_gpw.sql"
    "sql/1_eb_gpw_nn.sql"
    "sql/bands_per_capita.sql"
    "sql/bands_percap_megaquery.sql"
    "sql/gadm_gpw.sql"
    "sql/gpw_eb_summarize.sql"
    "sql/ne_gpw.sql"
)

for sql_file in "${SQL_FILES[@]}"; do
    assert_file_exists "$sql_file" "$sql_file exists"
done

# Test 2: Validate SQL syntax (basic checks)
echo ""
echo "Validating SQL syntax..."

# Check 0_create_geom_inside.sql
assert_contains "sql/0_create_geom_inside.sql" "ALTER TABLE gpw" "0_create_geom_inside contains ALTER TABLE"
assert_contains "sql/0_create_geom_inside.sql" "ADD COLUMN geom_inside" "Creates geom_inside column"
assert_contains "sql/0_create_geom_inside.sql" "ST_SetSRID" "Uses ST_SetSRID function"
assert_contains "sql/0_create_geom_inside.sql" "ST_Point" "Uses ST_Point function"
assert_contains "sql/0_create_geom_inside.sql" "CREATE INDEX" "Creates spatial index"
assert_contains "sql/0_create_geom_inside.sql" "USING GIST" "Uses GIST index type"

# Check ne_gpw.sql
assert_contains "sql/ne_gpw.sql" "CREATE TABLE ne_gpw" "ne_gpw.sql creates ne_gpw table"
assert_contains "sql/ne_gpw.sql" "ST_CONTAINS" "Uses ST_CONTAINS for spatial join"
assert_contains "sql/ne_gpw.sql" "GROUP BY" "Uses GROUP BY clause"
assert_contains "sql/ne_gpw.sql" "SUM(" "Uses aggregate function SUM"

# Check gadm_gpw.sql
assert_contains "sql/gadm_gpw.sql" "ST_CONTAINS" "gadm_gpw.sql uses ST_CONTAINS"
assert_file_not_empty "sql/gadm_gpw.sql" "gadm_gpw.sql is not empty"

# Check bands_per_capita.sql
assert_file_not_empty "sql/bands_per_capita.sql" "bands_per_capita.sql is not empty"

# Test 3: Check for SQL injection vulnerabilities (basic)
echo ""
echo "Checking for SQL best practices..."

for sql_file in "${SQL_FILES[@]}"; do
    # SQL files should not have obvious SQL injection patterns
    if grep -i "'; DROP" "$sql_file" &> /dev/null; then
        echo -e "${RED}✗${NC} FAIL: $sql_file contains suspicious SQL pattern"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
    TESTS_RUN=$((TESTS_RUN + 1))
done

# Test 4: Verify SQL files use proper PostGIS functions
echo ""
echo "Checking PostGIS function usage..."

POSTGIS_FUNCTIONS=("ST_Point" "ST_SetSRID" "ST_CONTAINS" "USING GIST")
found_postgis=false

for func in "${POSTGIS_FUNCTIONS[@]}"; do
    if grep -r "$func" sql/ &> /dev/null; then
        found_postgis=true
        break
    fi
done

TESTS_RUN=$((TESTS_RUN + 1))
if [ "$found_postgis" = true ]; then
    echo -e "${GREEN}✓${NC} PASS: SQL files use PostGIS functions"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗${NC} FAIL: No PostGIS functions found in SQL files"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Test 5: Check for proper table references
echo ""
echo "Checking table references..."
assert_contains "sql/0_create_geom_inside.sql" "gpw" "References gpw table"
assert_contains "sql/ne_gpw.sql" "ne_admin1" "References ne_admin1 table"
assert_contains "sql/ne_gpw.sql" "gpw_points" "References gpw_points table"

cleanup_test_env
print_test_summary
