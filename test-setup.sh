#!/bin/bash

# Test script for Reforger Mod Manager
# This creates a test environment to verify the script works correctly

echo "Setting up test environment for Reforger Mod Manager..."

# Create test directory structure
TEST_DIR="/tmp/reforger-test"
TEST_CONFIG="$TEST_DIR/armaserver_config.json"
TEST_ADDONS="$TEST_DIR/addons"

# Clean up any existing test directory
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
mkdir -p "$TEST_ADDONS"

# Create a sample config file with some test mods
cat > "$TEST_CONFIG" << 'EOF'
{
  "bindAddress": "127.0.0.1",
  "bindPort": 2001,
  "game": {
    "name": "Test Server",
    "maxPlayers": 64,
    "mods": [
      {
        "modId": "TEST001",
        "name": "Test Mod 1",
        "required": true
      },
      {
        "modId": "TEST002",
        "name": "Test Mod 2",
        "required": true
      },
      {
        "modId": "TEST003",
        "name": "Test Mod 3",
        "required": true
      },
      {
        "modId": "TEST004",
        "name": "Test Mod 4",
        "required": true
      },
      {
        "modId": "TEST005",
        "name": "Test Mod 5",
        "required": true
      },
      {
        "modId": "TEST006",
        "name": "Test Mod 6",
        "required": true
      },
      {
        "modId": "TEST007",
        "name": "Test Mod 7",
        "required": true
      },
      {
        "modId": "TEST008",
        "name": "Test Mod 8",
        "required": true
      },
      {
        "modId": "TEST009",
        "name": "Test Mod 9",
        "required": true
      },
      {
        "modId": "TEST010",
        "name": "Test Mod 10",
        "required": true
      },
      {
        "modId": "TEST011",
        "name": "Test Mod 11",
        "required": true
      },
      {
        "modId": "TEST012",
        "name": "Test Mod 12",
        "required": true
      }
    ]
  }
}
EOF

echo "✓ Test environment created at: $TEST_DIR"
echo "✓ Test config file: $TEST_CONFIG (12 test mods)"
echo "✓ Test addons directory: $TEST_ADDONS"
echo ""
echo "To test the mod manager with this setup:"
echo "1. Run: ./reforger-mod-manager.sh"
echo "2. When prompted for config path, enter: $TEST_CONFIG"
echo "3. When prompted for addons path, enter: $TEST_ADDONS"
echo ""
echo "After testing, you can clean up with: rm -rf $TEST_DIR"
