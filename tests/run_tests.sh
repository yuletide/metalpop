#!/bin/bash
# Main test runner for metalpop data pipeline tests
# Runs all test suites and provides a comprehensive report

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Change to repository root
cd "$(dirname "$0")/.."

echo -e "${BLUE}========================================"
echo "METALPOP DATA PIPELINE TEST SUITE"
echo -e "========================================${NC}"
echo ""

# Track overall results
TOTAL_SUITES=0
PASSED_SUITES=0
FAILED_SUITES=0

# Function to run a test suite
run_test_suite() {
    local test_script="$1"
    local test_name=$(basename "$test_script" .sh)
    
    echo -e "${BLUE}Running: $test_name${NC}"
    echo "----------------------------------------"
    
    TOTAL_SUITES=$((TOTAL_SUITES + 1))
    
    if bash "$test_script"; then
        echo -e "${GREEN}✓ $test_name PASSED${NC}"
        PASSED_SUITES=$((PASSED_SUITES + 1))
        echo ""
        return 0
    else
        echo -e "${RED}✗ $test_name FAILED${NC}"
        FAILED_SUITES=$((FAILED_SUITES + 1))
        echo ""
        return 1
    fi
}

# Make all test scripts executable
chmod +x tests/*.sh 2>/dev/null || true

# Run all test suites
echo "Discovering and running test suites..."
echo ""

# Run test suites in order
test_suites=(
    "tests/test_makefile.sh"
    "tests/test_sql.sh"
    "tests/test_scripts.sh"
    "tests/test_pipeline.sh"
)

for suite in "${test_suites[@]}"; do
    if [ -f "$suite" ]; then
        run_test_suite "$suite" || true
    else
        echo -e "${YELLOW}⚠ Warning: Test suite not found: $suite${NC}"
        echo ""
    fi
done

# Print final summary
echo ""
echo -e "${BLUE}========================================"
echo "FINAL TEST SUMMARY"
echo -e "========================================${NC}"
echo "Total test suites: $TOTAL_SUITES"
echo -e "${GREEN}Passed: $PASSED_SUITES${NC}"

if [ $FAILED_SUITES -gt 0 ]; then
    echo -e "${RED}Failed: $FAILED_SUITES${NC}"
    echo ""
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
else
    echo "Failed: 0"
    echo ""
    echo -e "${GREEN}All test suites passed!${NC}"
    exit 0
fi
