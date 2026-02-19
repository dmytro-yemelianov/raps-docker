#!/bin/bash
set -e

PORT="${MOCK_PORT:-3000}"
MODE="${MOCK_MODE:-stateful}"
OPENAPI_DIR="${OPENAPI_DIR:-/opt/openapi}"

echo "Starting raps-mock on port ${PORT} (mode: ${MODE})"
exec raps-mock --port "${PORT}" --mode "${MODE}" --openapi-dir "${OPENAPI_DIR}"
