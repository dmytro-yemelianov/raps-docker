#!/bin/bash
set -e

# Wait for mock server to be ready
/wait-for-mock.sh

# Pre-login with a mock 3-legged token so commands requiring user context work
echo "Setting up 3-legged auth token for mock..."
raps auth login --token mock-3leg-token --expires-in 86400 --preset all 2>/dev/null || true

echo "Running raps-examples test suite against mock..."
exec pytest --mock -v "$@"
