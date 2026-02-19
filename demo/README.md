# RAPS Demo Environment

Docker Compose environment for running the RAPS CLI against a mock APS server — no real Autodesk credentials needed. Includes [yr](https://github.com/dmytro-yemelianov/yr) for rendering terminal session GIFs.

## Architecture

```
┌─────────────────────────────────────────────┐
│  docker compose up                          │
│                                             │
│  ┌──────────┐   ┌──────┐   ┌──────────┐   │
│  │raps-mock │◄──│ raps │   │ examples │   │
│  │ :3000    │◄──│ CLI  │   │ (pytest) │   │
│  │ stateful │   │ bash │   │ --mock   │   │
│  └──────────┘   └──────┘   │ + yr     │   │
│   always up    interactive  └──────────┘   │
│                              profile:test   │
└─────────────────────────────────────────────┘
```

- **mock** — raps-mock server (port 3000, stateful mode, OpenAPI specs baked in)
- **cli** — raps binary in bash shell, preconfigured for mock
- **examples** — Python + pytest + raps + yr binary, runs with `--mock` flag (profile-gated)

## Quick Start

```bash
cd raps-docker/demo

# Start mock server + CLI container
docker compose up -d

# Open interactive shell
docker compose exec cli bash

# Try some commands
raps auth test
raps bucket create -k demo-bucket -p transient -r US
raps bucket list
raps hub list
```

## Running Tests

```bash
# Run the full example test suite against mock
docker compose --profile test up --exit-code-from examples

# Run a specific test section
docker compose run examples pytest tests/test_03_storage.py --mock -v

# Run with extra pytest flags
docker compose run examples pytest --mock -v -k "bucket"
```

## Rendering GIFs with yr

The examples container includes `yr` for rendering terminal session recordings to GIF. Use `--generate-yr` to create `.yr` scripts from test runs, and `--render-yr` to also render them to GIF.

```bash
# Generate .yr scripts and render GIFs (output to ./recordings/ on host)
docker compose run examples pytest --mock --render-yr -v

# Generate .yr scripts only (no rendering)
docker compose run examples pytest --mock --generate-yr -v

# Render with custom worker count
docker compose run examples pytest --mock --render-yr --yr-workers 2 -v
```

GIF files are written to `./recordings/` on the host (bind-mounted volume).

## One-Shot Commands

```bash
# Check raps version
docker compose run cli raps --version

# Run a single command
docker compose run cli raps auth test
```

## Configuration

Environment variables (set in `.env` or override on command line):

| Variable | Default | Description |
|----------|---------|-------------|
| `APS_CLIENT_ID` | `mock-client-id` | Client ID for mock auth |
| `APS_CLIENT_SECRET` | `mock-client-secret` | Client secret for mock auth |
| `MOCK_PORT` | `3000` | Host port for mock server |
| `RAPS_VERSION` | `latest` | raps Docker image tag |

## Building with Pinned Refs

```bash
# Build mock from a specific branch/tag
docker compose build --build-arg MOCK_REF=v0.2.0 mock

# Build examples from a specific branch/yr version
docker compose build --build-arg EXAMPLES_REF=main --build-arg YR_REF=main examples
```

## Cleanup

```bash
docker compose down           # Stop containers
docker compose down -v        # Stop and remove volumes
docker compose down --rmi all # Stop, remove volumes and images
```
