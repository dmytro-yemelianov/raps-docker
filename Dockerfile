# 🌼 RAPS (rapeseed) — Rust Autodesk Platform Services CLI
# https://rapscli.xyz
# DockerHub: dmytroyemelianov/raps

FROM debian:bookworm-slim

# OCI Image Labels
LABEL org.opencontainers.image.title="RAPS"
LABEL org.opencontainers.image.description="Rust CLI for Autodesk Platform Services - CI/CD automation for AEC workflows"
LABEL org.opencontainers.image.url="https://rapscli.xyz"
LABEL org.opencontainers.image.source="https://github.com/dmytro-yemelianov/raps"
LABEL org.opencontainers.image.documentation="https://rapscli.xyz/docs"
LABEL org.opencontainers.image.vendor="Dmytro Yemelianov"
LABEL org.opencontainers.image.licenses="Apache-2.0"

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Set version as an argument
ARG VERSION=3.4.0
ARG TARGETARCH

# Map Docker's TARGETARCH to RAPS release naming
RUN ARCH=$(case "${TARGETARCH}" in \
        "amd64") echo "x64" ;; \
        "arm64") echo "arm64" ;; \
        *) echo "x64" ;; \
    esac) && \
    curl -fsSL -o raps.tar.gz "https://github.com/dmytro-yemelianov/raps/releases/download/v${VERSION}/raps-linux-${ARCH}.tar.gz" && \
    tar -xzf raps.tar.gz -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/raps && \
    rm raps.tar.gz

# Create non-root user for security
RUN useradd -m -s /bin/bash raps
USER raps
WORKDIR /home/raps

# Set the entrypoint
ENTRYPOINT ["raps"]
CMD ["--help"]
