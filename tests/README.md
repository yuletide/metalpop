# METALPOP Data Pipeline Tests

This directory contains the test suite for the metalpop data pipeline.

## Overview

The test suite validates the data processing pipeline that:
1. Imports GPW CSV population data
2. Converts to point geometries
3. Joins population data to administrative boundaries
4. Enriches with Metal-Archives band data
5. Generates map tiles

## Test Structure

### Test Suites

- **test_makefile.sh**: Validates Makefile structure and targets
- **test_sql.sh**: Tests SQL queries and PostGIS functions
- **test_scripts.sh**: Validates shell scripts and their syntax
- **test_pipeline.sh**: Integration tests with mock data

### Test Helper

- **test_helper.sh**: Common test utilities and assertion functions

## Running Tests

### Run All Tests

```bash
make test
```

Or directly:

```bash
bash tests/run_tests.sh
```

### Run Individual Test Suite

```bash
bash tests/test_makefile.sh
bash tests/test_sql.sh
bash tests/test_scripts.sh
bash tests/test_pipeline.sh
```

## Test Requirements

The tests are designed to run without requiring:
- Mapshaper installation
- GDAL/OGR installation
- PostgreSQL installation
- Actual data files

Tests validate:
- Configuration files exist and are valid
- SQL syntax and PostGIS function usage
- Shell script syntax and structure
- Expected data formats and field names
- Pipeline workflow structure

## Test Coverage

### What is Tested

1. **File Existence**: All required files are present
2. **Configuration**: JSON and XML files are valid
3. **SQL Queries**: Proper syntax and PostGIS usage
4. **Data Formats**: CSV structure and field names
5. **Coordinates**: Valid latitude/longitude ranges
6. **Pipeline Structure**: Correct workflow dependencies

### What is NOT Tested

These require actual tools and data:
- Actual mapshaper execution
- GDAL/OGR operations
- PostgreSQL database operations
- Full end-to-end pipeline runs

For integration testing with real tools and data, use:
```bash
make admin_pop_test
```

## Adding New Tests

To add new tests:

1. Create a new test file: `tests/test_yourfeature.sh`
2. Source the test helper: `source "$(dirname "$0")/test_helper.sh"`
3. Use assertion functions from test_helper.sh
4. Add your test to `tests/run_tests.sh`

### Example Test

```bash
#!/bin/bash
source "$(dirname "$0")/test_helper.sh"

setup_test_env

assert_file_exists "myfile.txt" "My file exists"
assert_contains "myfile.txt" "pattern" "File contains pattern"

cleanup_test_env
print_test_summary
```

## Continuous Integration

These tests are designed to run in CI environments without external dependencies. They provide fast feedback on:
- Configuration validity
- SQL syntax errors
- Script structure issues
- Documentation completeness

## Exit Codes

- **0**: All tests passed
- **1**: One or more tests failed

## Test Output

Tests provide colored output:
- 🟢 Green: Passed tests
- 🔴 Red: Failed tests
- 🟡 Yellow: Warnings

Each test suite provides a summary showing:
- Total tests run
- Number passed
- Number failed
