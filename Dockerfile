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
    xz-utils \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Set version as an argument
ARG VERSION=3.9.0
ARG TARGETARCH

# Map Docker's TARGETARCH to cargo-dist naming convention
RUN ARCH=$(case "${TARGETARCH}" in \
        "amd64") echo "x86_64-unknown-linux-gnu" ;; \
        "arm64") echo "aarch64-unknown-linux-gnu" ;; \
        *) echo "x86_64-unknown-linux-gnu" ;; \
    esac) && \
    curl -fsSL -o raps.tar.xz "https://github.com/dmytro-yemelianov/raps/releases/download/v${VERSION}/raps-cli-${ARCH}.tar.xz" && \
    tar -xJf raps.tar.xz -C /usr/local/bin/ && \
    mv /usr/local/bin/raps-cli /usr/local/bin/raps && \
    chmod +x /usr/local/bin/raps && \
    rm raps.tar.xz

# Create non-root user for security
RUN useradd -m -s /bin/bash raps
USER raps
WORKDIR /home/raps

# Set the entrypoint
ENTRYPOINT ["raps"]
CMD ["--help"]
