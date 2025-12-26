# 🌼 RAPS Docker Image

Official Docker image for [RAPS](https://rapscli.xyz) — the Rust CLI for Autodesk Platform Services.

[![DockerHub](https://img.shields.io/docker/v/dmytroyemelianov/raps?label=DockerHub&logo=docker)](https://hub.docker.com/r/dmytroyemelianov/raps)
[![Docker Pulls](https://img.shields.io/docker/pulls/dmytroyemelianov/raps)](https://hub.docker.com/r/dmytroyemelianov/raps)
[![Image Size](https://img.shields.io/docker/image-size/dmytroyemelianov/raps/latest)](https://hub.docker.com/r/dmytroyemelianov/raps)

## Quick Start

```bash
# Pull the image
docker pull dmytroyemelianov/raps

# Run RAPS
docker run --rm dmytroyemelianov/raps --version

# With credentials (environment variables)
docker run --rm \
  -e APS_CLIENT_ID=your_client_id \
  -e APS_CLIENT_SECRET=your_client_secret \
  dmytroyemelianov/raps auth token
```

## Usage Examples

### Authentication

```bash
# Get 2-legged token
docker run --rm \
  -e APS_CLIENT_ID=$APS_CLIENT_ID \
  -e APS_CLIENT_SECRET=$APS_CLIENT_SECRET \
  dmytroyemelianov/raps auth token

# Inspect token
docker run --rm \
  -e APS_ACCESS_TOKEN=$TOKEN \
  dmytroyemelianov/raps auth inspect-token
```

### Object Storage (OSS)

```bash
# List buckets
docker run --rm \
  -e APS_ACCESS_TOKEN=$TOKEN \
  dmytroyemelianov/raps oss buckets list

# Upload file (mount local directory)
docker run --rm \
  -e APS_ACCESS_TOKEN=$TOKEN \
  -v $(pwd)/files:/data \
  dmytroyemelianov/raps oss objects upload my-bucket /data/model.rvt
```

### Model Derivative

```bash
# Translate model
docker run --rm \
  -e APS_ACCESS_TOKEN=$TOKEN \
  dmytroyemelianov/raps md translate urn:base64encodedurn --output-format svf2

# Check translation status
docker run --rm \
  -e APS_ACCESS_TOKEN=$TOKEN \
  dmytroyemelianov/raps md manifest urn:base64encodedurn
```

### Pipeline Execution

```bash
# Run a pipeline from YAML
docker run --rm \
  -e APS_CLIENT_ID=$APS_CLIENT_ID \
  -e APS_CLIENT_SECRET=$APS_CLIENT_SECRET \
  -v $(pwd)/pipeline.yaml:/pipeline.yaml \
  dmytroyemelianov/raps pipeline run /pipeline.yaml
```

## Docker Compose

```yaml
version: '3.8'

services:
  raps:
    image: dmytroyemelianov/raps:latest
    environment:
      - APS_CLIENT_ID=${APS_CLIENT_ID}
      - APS_CLIENT_SECRET=${APS_CLIENT_SECRET}
    volumes:
      - ./data:/data
      - ./pipelines:/pipelines
    command: ["--help"]
```

## CI/CD Integration

### GitHub Actions

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    container:
      image: dmytroyemelianov/raps:latest
    steps:
      - name: Upload and translate model
        env:
          APS_CLIENT_ID: ${{ secrets.APS_CLIENT_ID }}
          APS_CLIENT_SECRET: ${{ secrets.APS_CLIENT_SECRET }}
        run: |
          TOKEN=$(raps auth token --quiet)
          raps oss objects upload my-bucket model.rvt
          raps md translate $(raps oss objects info my-bucket model.rvt --urn)
```

### GitLab CI

```yaml
translate-model:
  image: dmytroyemelianov/raps:latest
  variables:
    APS_CLIENT_ID: $APS_CLIENT_ID
    APS_CLIENT_SECRET: $APS_CLIENT_SECRET
  script:
    - raps auth token
    - raps oss objects upload my-bucket model.rvt
    - raps md translate $URN --wait
```

### Azure DevOps

```yaml
- task: Docker@2
  inputs:
    command: run
    arguments: >
      -e APS_CLIENT_ID=$(APS_CLIENT_ID)
      -e APS_CLIENT_SECRET=$(APS_CLIENT_SECRET)
      dmytroyemelianov/raps auth token
```

## Supported Architectures

| Architecture | Tag |
|--------------|-----|
| linux/amd64 | `latest`, `2.0.0` |
| linux/arm64 | `latest`, `2.0.0` |

## Tags

- `latest` — Latest stable release
- `2.0.0` — Specific version
- `2.0` — Latest patch of minor version
- `2` — Latest minor of major version

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `APS_CLIENT_ID` | Autodesk app client ID | For auth |
| `APS_CLIENT_SECRET` | Autodesk app client secret | For auth |
| `APS_ACCESS_TOKEN` | Pre-obtained access token | Alternative to ID/secret |
| `APS_REGION` | Region (US/EMEA) | Optional, defaults to US |

## Building Locally

```bash
# Clone the repository
git clone https://github.com/dmytro-yemelianov/raps-docker.git
cd raps-docker

# Build for current platform
docker build -t raps:local --build-arg VERSION=2.0.0 .

# Build multi-platform
docker buildx build --platform linux/amd64,linux/arm64 \
  -t dmytroyemelianov/raps:2.0.0 \
  --build-arg VERSION=2.0.0 \
  --push .
```

## Links

- 🌐 **Website**: https://rapscli.xyz
- 📚 **Documentation**: https://rapscli.xyz/docs
- 💻 **GitHub**: https://github.com/dmytro-yemelianov/raps
- 📦 **Crates.io**: https://crates.io/crates/raps
- 🐳 **DockerHub**: https://hub.docker.com/r/dmytroyemelianov/raps

## License

Apache 2.0 — See [LICENSE](https://github.com/dmytro-yemelianov/raps/blob/main/LICENSE)

