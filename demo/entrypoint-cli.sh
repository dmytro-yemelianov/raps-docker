#!/bin/bash
set -e

# Wait for mock server to be ready
/wait-for-mock.sh

# Set up default config profile
raps config profile create default 2>/dev/null || true
raps config profile use default 2>/dev/null || true

# Pre-authenticate with mock token (valid for 24h)
raps auth login --token mock-3leg-token --expires-in 86400 --preset all 2>/dev/null || true

echo "Ready — raps CLI configured against mock server at $APS_BASE_URL"
exec /bin/bash "$@"
