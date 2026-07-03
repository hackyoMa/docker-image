# syntax=docker/dockerfile:1
FROM hackyo/debian:trixie-slim

LABEL org.opencontainers.image.authors="hackyo" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.source="https://github.com/hackyoMa/docker-image/tree/openclaw-2026"

ARG TARGETPLATFORM
ARG UV_VERSION=0.11.26
ARG PYTHON_VERSION=3.13
ARG NODE_VERSION=24.18.0
ARG HIMALAYA_VERSION=1.2.0
ARG OPENCLAW_VERSION=2026.6.11
ARG CLAWHUB_VERSION=0.23.1
ARG PLAYWRIGHT_VERSION=1.61.1
ARG MCPORTER_VERSION=0.12.3
ARG CHROMIUM_VERSION=1228

ENV DEBIAN_FRONTEND=noninteractive
ENV PLAYWRIGHT_BROWSERS_PATH="/home/appuser/.playwright"
ENV RUNTIME_HOME="/home/appuser/.local"
ENV PATH="${RUNTIME_HOME}/bin:${RUNTIME_HOME}/share/python/bin:${PATH}"

WORKDIR /home/appuser
USER appuser

RUN set -eux; \
    mkdir -p "${RUNTIME_HOME}/bin"; \
    case "${TARGETPLATFORM}" in \
      "linux/amd64") arch="x86_64"; node_arch="x64" ;; \
      "linux/arm64") arch="aarch64"; node_arch="arm64" ;; \
      *) echo "Unsupported platform: ${TARGETPLATFORM}"; exit 1 ;; \
    esac; \
    tempDir="$(mktemp -d)"; \
    tarUrl="https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${node_arch}.tar.gz"; \
    curl -fL -o "${tempDir}/node.tar.gz" "${tarUrl}"; \
    tar -xf "${tempDir}/node.tar.gz" -C "${RUNTIME_HOME}" --strip-components 1; \
    rm -rf "${tempDir}" \
           "${RUNTIME_HOME}/CHANGELOG.md" \
           "${RUNTIME_HOME}/LICENSE" \
           "${RUNTIME_HOME}/README.md" \
           "${RUNTIME_HOME}/share"; \
    node -v; \
    npm -v; \
    tempDir="$(mktemp -d)"; \
    tarUrl="https://github.com/astral-sh/uv/releases/download/${UV_VERSION}/uv-${arch}-unknown-linux-gnu.tar.gz"; \
    curl -fL -o "${tempDir}/uv.tar.gz" "${tarUrl}"; \
    tar -xf "${tempDir}/uv.tar.gz" -C "${RUNTIME_HOME}/bin" --strip-components 1; \
    rm -rf "${tempDir}"; \
    uv python install "${PYTHON_VERSION}"; \
    uv cache clean --force; \
    rm "${RUNTIME_HOME}/bin/python${PYTHON_VERSION}"; \
    ln -s "${RUNTIME_HOME}/share/uv/python/cpython-${PYTHON_VERSION}-linux-${arch}-gnu" "${RUNTIME_HOME}/share/python"; \
    python3 -V; \
    uv -V; \
    tempDir="$(mktemp -d)"; \
    tarUrl="https://github.com/pimalaya/himalaya/releases/download/v${HIMALAYA_VERSION}/himalaya.${arch}-linux.tgz"; \
    curl -fL -o "${tempDir}/himalaya.tar.gz" "${tarUrl}"; \
    tar -xf "${tempDir}/himalaya.tar.gz" -C "${tempDir}"; \
    mv "${tempDir}/himalaya" "${RUNTIME_HOME}/bin/"; \
    rm -rf "${tempDir}"; \
    himalaya --version; \
    npm install -g "openclaw@${OPENCLAW_VERSION}" "clawhub@${CLAWHUB_VERSION}" "playwright@${PLAYWRIGHT_VERSION}" "mcporter@${MCPORTER_VERSION}"; \
    npm cache clean --force

USER root

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends git ffmpeg ripgrep; \
    playwright install-deps chromium; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

USER appuser

RUN set -eux; \
    playwright install chromium; \
    ln -s "${PLAYWRIGHT_BROWSERS_PATH}/chromium-${CHROMIUM_VERSION}/chrome-linux/chrome" "${RUNTIME_HOME}/bin/chromium"; \
    rm -rf /tmp/*

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 CMD openclaw gateway health | grep -A1 'Gateway Health' | grep -q 'OK'

CMD openclaw gateway
