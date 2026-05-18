# syntax=docker/dockerfile:1
FROM hackyo/debian:trixie-slim

LABEL org.opencontainers.image.authors="hackyo" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.source="https://github.com/hackyoMa/docker-image/tree/hermes-2026"

ARG TARGETPLATFORM
ARG UV_VERSION=0.11.14
ARG NODE_VERSION=24.15.0
ARG HIMALAYA_VERSION=1.2.0
ARG HERMES_VERSION=2026.5.16
ARG CLAWHUB_VERSION=0.15.0
ARG PLAYWRIGHT_VERSION=1.60.0
ARG MCPORTER_VERSION=0.11.1
ARG CHROMIUM_VERSION=1223
ARG FFMPEG_VERSION=1011

ENV DEBIAN_FRONTEND=noninteractive
ENV PLAYWRIGHT_BROWSERS_PATH="/home/appuser/.playwright"
ENV HERMES_HOME="/home/appuser/.hermes"
ENV HERMES_INSTALL_DIR="/home/appuser/.hermes-agent"
ENV RUNTIME_HOME="/home/appuser/.local"
ENV PATH="${RUNTIME_HOME}/bin:${PATH}"

WORKDIR /home/appuser
USER appuser

RUN set -eux; \
    mkdir -p "${RUNTIME_HOME}/bin" "${HERMES_INSTALL_DIR}"; \
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
    uv -V; \
    tempDir="$(mktemp -d)"; \
    tarUrl="https://github.com/pimalaya/himalaya/releases/download/v${HIMALAYA_VERSION}/himalaya.${arch}-linux.tgz"; \
    curl -fL -o "${tempDir}/himalaya.tar.gz" "${tarUrl}"; \
    tar -xf "${tempDir}/himalaya.tar.gz" -C "${tempDir}"; \
    mv "${tempDir}/himalaya" "${RUNTIME_HOME}/bin/"; \
    rm -rf "${tempDir}"; \
    himalaya --version; \
    npm install -g "clawhub@${CLAWHUB_VERSION}" "playwright@${PLAYWRIGHT_VERSION}" "mcporter@${MCPORTER_VERSION}"; \
    npm cache clean --force

USER root

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends git build-essential python3-dev libffi-dev ripgrep; \
    playwright install-deps chromium; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

USER appuser

COPY hermes "${RUNTIME_HOME}/bin/hermes"

RUN set -eux; \
    playwright install chromium; \
    ln -s "${PLAYWRIGHT_BROWSERS_PATH}/chromium-${CHROMIUM_VERSION}/chrome-linux/chrome" "${RUNTIME_HOME}/bin/chromium"; \
    ln -s "${PLAYWRIGHT_BROWSERS_PATH}/ffmpeg-${FFMPEG_VERSION}/ffmpeg-linux" "${RUNTIME_HOME}/bin/ffmpeg"; \
    tempDir="$(mktemp -d)"; \
    tarUrl="https://github.com/NousResearch/hermes-agent/archive/refs/tags/v${HERMES_VERSION}.tar.gz"; \
    curl -fL -o "${tempDir}/hermes.tar.gz" "${tarUrl}"; \
    tar -xf "${tempDir}/hermes.tar.gz" -C "${HERMES_INSTALL_DIR}" --strip-components 1; \
    rm -rf "${tempDir}"; \
    cd "${HERMES_INSTALL_DIR}"; \
    echo "AGENT_BROWSER_EXECUTABLE_PATH=${RUNTIME_HOME}/bin/chromium" >> .env.example; \
    uv sync --extra all; \
    source .venv/bin/activate; \
    uv pip install -e '.[all]'; \
    deactivate; \
    npm install; \
    cd ui-tui; \
    npm install; \
    chmod +x "${RUNTIME_HOME}/bin/hermes"; \
    uv cache clean --force; \
    npm cache clean --force; \
    rm -rf /tmp/*

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 CMD hermes status | grep -A1 'Gateway Service' | grep -q 'running'

CMD hermes gateway
