#!/bin/bash
set -e

# Wait for mock server to be ready
/wait-for-mock.sh

echo "Running raps-examples test suite against mock..."
exec pytest --mock -v "$@"
