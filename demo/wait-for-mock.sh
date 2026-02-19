#!/bin/bash
# Wait for raps-mock /health endpoint to respond
set -e

MOCK_URL="${APS_BASE_URL:-http://mock:3000}"
MAX_RETRIES=30
RETRY_INTERVAL=2

echo "Waiting for mock server at ${MOCK_URL}/health ..."

for i in $(seq 1 $MAX_RETRIES); do
    if curl -sf "${MOCK_URL}/health" > /dev/null 2>&1; then
        echo "Mock server is ready."
        exit 0
    fi
    echo "  attempt ${i}/${MAX_RETRIES} — retrying in ${RETRY_INTERVAL}s..."
    sleep $RETRY_INTERVAL
done

echo "ERROR: Mock server did not become ready after ${MAX_RETRIES} attempts."
exit 1
