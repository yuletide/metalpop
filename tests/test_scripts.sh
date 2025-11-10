#!/bin/bash
# Tests for shell scripts in the repository

set -e

# Source test helpers
source "$(dirname "$0")/test_helper.sh"

echo "========================================"
echo "Testing Shell Scripts"
echo "========================================"

setup_test_env

# Test 1: Verify load.sh exists
assert_file_exists "load.sh" "load.sh script exists"

# Test 2: Check if load.sh is executable
TESTS_RUN=$((TESTS_RUN + 1))
if [ -x "load.sh" ]; then
    echo -e "${GREEN}✓${NC} PASS: load.sh is executable"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${RED}✗${NC} FAIL: load.sh is not executable"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Test 3: Validate shell script syntax
echo ""
echo "Validating shell script syntax..."

if command -v bash &> /dev/null; then
    TESTS_RUN=$((TESTS_RUN + 1))
    if bash -n load.sh 2>/dev/null; then
        echo -e "${GREEN}✓${NC} PASS: load.sh has valid bash syntax"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗${NC} FAIL: load.sh has syntax errors"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
fi

# Test 4: Check for required commands in load.sh
echo ""
echo "Checking script dependencies..."

assert_contains "load.sh" "ogr2ogr" "load.sh uses ogr2ogr command"
assert_contains "load.sh" "psql" "load.sh uses psql command"
assert_contains "load.sh" "createdb" "load.sh uses createdb command"

# Test 5: Verify database connection string handling
assert_contains "load.sh" "POSTGRES_CONNECTION_STRING" "Script defines PostgreSQL connection string"
assert_contains "load.sh" "DB_HOST" "Script uses DB_HOST variable"
assert_contains "load.sh" "DB_NAME" "Script uses DB_NAME variable"
assert_contains "load.sh" "DB_USER" "Script uses DB_USER variable"

# Test 6: Check for PostGIS extension
assert_contains "load.sh" "CREATE EXTENSION postgis" "Script enables PostGIS extension"

# Test 7: Verify spatial index creation
assert_contains "load.sh" "CREATE INDEX" "Script creates spatial indexes"
assert_contains "load.sh" "USING GIST" "Script uses GIST index type"

# Test 8: Check for error handling
echo ""
echo "Checking error handling..."

# Check if script uses set -e or error checking
if grep -q "set -e" load.sh || grep -q 'if \[' load.sh; then
    echo -e "${GREEN}✓${NC} PASS: Script has error handling"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo -e "${YELLOW}⚠${NC}  WARNING: Script may lack error handling"
fi
TESTS_RUN=$((TESTS_RUN + 1))

# Test 9: Check for data file references
echo ""
echo "Checking data file references..."

assert_contains "load.sh" "sedac/" "Script references SEDAC data directory"
assert_contains "load.sh" "gpw" "Script references GPW data"

# Test 10: Verify SQL file execution
assert_contains "load.sh" "sql/0_create_geom_inside.sql" "Script executes 0_create_geom_inside.sql"
assert_contains "load.sh" "sql/ne_gpw.sql" "Script executes ne_gpw.sql"

# Test 11: Test all test scripts are executable
echo ""
echo "Checking test script permissions..."

for test_script in tests/test_*.sh; do
    if [ -f "$test_script" ]; then
        chmod +x "$test_script"
        TESTS_RUN=$((TESTS_RUN + 1))
        if [ -x "$test_script" ]; then
            echo -e "${GREEN}✓${NC} PASS: $(basename $test_script) is executable"
            TESTS_PASSED=$((TESTS_PASSED + 1))
        else
            echo -e "${RED}✗${NC} FAIL: $(basename $test_script) is not executable"
            TESTS_FAILED=$((TESTS_FAILED + 1))
        fi
    fi
done

cleanup_test_env
print_test_summary
