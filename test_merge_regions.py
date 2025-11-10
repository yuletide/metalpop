#!/usr/bin/env python3
"""
Unit tests for merge_regions.py

These tests validate the logic without requiring mapshaper to be installed.
"""

import json
import sys
from pathlib import Path

# Add parent directory to path for imports
sys.path.insert(0, str(Path(__file__).parent))

from merge_regions import load_merge_config, create_mapshaper_expressions


def test_load_config():
    """Test that configuration loads correctly."""
    print("Testing configuration loading...")
    config = load_merge_config('region_merges.json')
    
    assert len(config) > 0, "Should have at least one merge configuration"
    assert 'parent_name' in config[0], "Config should have parent_name"
    assert 'regions_to_merge' in config[0], "Config should have regions_to_merge"
    
    print(f"✓ Loaded {len(config)} merge configuration(s)")
    return True


def test_london_config():
    """Test that London configuration is correct."""
    print("Testing London borough configuration...")
    config = load_merge_config('region_merges.json')
    
    london_config = None
    for merge in config:
        if merge['parent_name'] == 'Greater London':
            london_config = merge
            break
    
    assert london_config is not None, "Should have Greater London configuration"
    
    # Check that key London boroughs are included
    regions = london_config['regions_to_merge']
    key_boroughs = ['Kensington and Chelsea', 'Westminster', 'Camden', 'City of London']
    
    for borough in key_boroughs:
        assert borough in regions, f"{borough} should be in merge list"
    
    print(f"✓ Greater London config has {len(regions)} boroughs")
    print(f"✓ Key boroughs verified: {', '.join(key_boroughs)}")
    return True


def test_expression_generation():
    """Test that mapshaper expressions are generated correctly."""
    print("Testing expression generation...")
    config = load_merge_config('region_merges.json')
    expr = create_mapshaper_expressions(config)
    
    assert len(expr) > 0, "Expression should not be empty"
    assert 'merge_group' in expr, "Expression should reference merge_group"
    assert 'Greater London' in expr, "Expression should include Greater London"
    
    # Check for proper JavaScript syntax
    assert 'if (' in expr, "Expression should have if statements"
    assert 'this.properties' in expr, "Expression should reference properties"
    
    print(f"✓ Generated expression of {len(expr)} characters")
    return True


def test_merge_field_support():
    """Test that custom merge fields are supported."""
    print("Testing custom merge field...")
    
    # Create a test config with a custom merge field
    test_config = [{
        'parent_name': 'Test Region',
        'merge_field': 'custom_field',
        'regions_to_merge': ['Region A', 'Region B']
    }]
    
    # Write to temp file
    test_file = '/tmp/test_config.json'
    with open(test_file, 'w') as f:
        json.dump({'merges': test_config}, f)
    
    # Load and test
    config = load_merge_config(test_file)
    expr = create_mapshaper_expressions(config)
    
    assert 'custom_field' in expr, "Expression should use custom merge field"
    
    print("✓ Custom merge field supported")
    return True


def test_multiple_merges():
    """Test that multiple merge configurations work."""
    print("Testing multiple merge support...")
    
    test_config = [
        {
            'parent_name': 'Region 1',
            'merge_field': 'name',
            'regions_to_merge': ['A', 'B']
        },
        {
            'parent_name': 'Region 2',
            'merge_field': 'name',
            'regions_to_merge': ['C', 'D']
        }
    ]
    
    test_file = '/tmp/test_multi_config.json'
    with open(test_file, 'w') as f:
        json.dump({'merges': test_config}, f)
    
    config = load_merge_config(test_file)
    assert len(config) == 2, "Should load both merge configs"
    
    expr = create_mapshaper_expressions(config)
    assert 'Region 1' in expr and 'Region 2' in expr, "Both regions should be in expression"
    
    print("✓ Multiple merges supported")
    return True


def run_all_tests():
    """Run all tests."""
    tests = [
        test_load_config,
        test_london_config,
        test_expression_generation,
        test_merge_field_support,
        test_multiple_merges
    ]
    
    print("=" * 60)
    print("Running merge_regions.py unit tests")
    print("=" * 60)
    
    passed = 0
    failed = 0
    
    for test in tests:
        try:
            print(f"\n{test.__name__}:")
            test()
            passed += 1
        except AssertionError as e:
            print(f"✗ FAILED: {e}")
            failed += 1
        except Exception as e:
            print(f"✗ ERROR: {e}")
            failed += 1
    
    print("\n" + "=" * 60)
    print(f"Results: {passed} passed, {failed} failed")
    print("=" * 60)
    
    return failed == 0


if __name__ == '__main__':
    success = run_all_tests()
    sys.exit(0 if success else 1)
