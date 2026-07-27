# syntax=docker/dockerfile:1
FROM hackyo/debian:trixie-slim

LABEL org.opencontainers.image.authors="hackyo" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.source="https://github.com/hackyoMa/docker-image/tree/hermes-2026"

ARG TARGETPLATFORM

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /home/appuser

USER root

# base: git ffmpeg ripgrep wget jq zip unzip
# hermes: build-essential python3-dev libffi-dev
# minimax-docx: dotnet-sdk-10.0 pandoc libreoffice-core
# chromium: at-spi2-common fonts-freefont-ttf fonts-ipafont-gothic fonts-liberation fonts-noto-color-emoji
#           fonts-tlwg-loma-otf fonts-unifont fonts-wqy-zenhei libatk-bridge2.0-0t64 libatk1.0-0t64
#           libatspi2.0-0t64 libfontenc1 libunwind8 libxaw7 libxcomposite1 libxdamage1 libxfont2
#           libxkbfile1 libxmu6 libxpm4 libxt6t64 x11-xkb-utils xfonts-encodings xfonts-scalable
#           xfonts-utils xserver-common xvfb
RUN set -eux; \
    curl -L -o packages-microsoft-prod.deb https://packages.microsoft.com/config/debian/13/packages-microsoft-prod.deb; \
    dpkg -i packages-microsoft-prod.deb; \
    rm packages-microsoft-prod.deb; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      git ffmpeg ripgrep wget jq zip unzip \
      build-essential python3-dev libffi-dev \
      dotnet-sdk-10.0 pandoc libreoffice-core \
      at-spi2-common fonts-freefont-ttf fonts-ipafont-gothic fonts-liberation fonts-noto-color-emoji \
      fonts-tlwg-loma-otf fonts-unifont fonts-wqy-zenhei libatk-bridge2.0-0t64 libatk1.0-0t64 \
      libatspi2.0-0t64 libfontenc1 libunwind8 libxaw7 libxcomposite1 libxdamage1 libxfont2 \
      libxkbfile1 libxmu6 libxpm4 libxt6t64 x11-xkb-utils xfonts-encodings xfonts-scalable \
      xfonts-utils xserver-common xvfb; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    rm -rf /tmp/*

USER appuser

ARG UV_VERSION=0.11.31
ARG PYTHON_VERSION=3.13
ARG NODE_VERSION=24.18.0
ARG HIMALAYA_VERSION=1.2.0
ARG HERMES_VERSION=2026.7.20
ARG CLAWHUB_VERSION=0.23.1
ARG PLAYWRIGHT_VERSION=1.61.1
ARG MCPORTER_VERSION=0.12.3
ARG PPTXGENJS_VERSION=4.0.1
ARG REACT_ICONS_VERSION=5.7.0
ARG REACT_VERSION=19.2.8
ARG REACT_DOM_VERSION=19.2.8
ARG SHARP_VERSION=0.35.3
ARG CHROMIUM_VERSION=1228
ARG MARKITDOWN_VERSION=0.1.6
ARG REPORTLAB_VERSION=5.0.0
ARG PYPDF_VERSION=6.14.2
ARG MATPLOTLIB_VERSION=3.11.1

ENV PLAYWRIGHT_BROWSERS_PATH="/home/appuser/.playwright"
ENV HERMES_HOME="/home/appuser/.hermes"
ENV HERMES_INSTALL_DIR="/home/appuser/.hermes-agent"
ENV RUNTIME_HOME="/home/appuser/.local"
ENV PATH="${RUNTIME_HOME}/bin:${RUNTIME_HOME}/share/python/bin:${PATH}"

# base: clawhub playwright mcporter
# pptx-generator: pptxgenjs react-icons react react-dom sharp markitdown[pptx]
# minimax-pdf: reportlab pypdf matplotlib
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
    uv python install "${PYTHON_VERSION}"; \
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
    npm install -g \
      "clawhub@${CLAWHUB_VERSION}" "playwright@${PLAYWRIGHT_VERSION}" "mcporter@${MCPORTER_VERSION}" \
      "pptxgenjs@${PPTXGENJS_VERSION}" "react-icons@${REACT_ICONS_VERSION}" "react@${REACT_VERSION}" "react-dom@${REACT_DOM_VERSION}" "sharp@${SHARP_VERSION}"; \
    playwright install chromium; \
    ln -s "${PLAYWRIGHT_BROWSERS_PATH}/chromium-${CHROMIUM_VERSION}/chrome-linux/chrome" "${RUNTIME_HOME}/bin/chromium"; \
    pip install --break-system-packages \
      "markitdown[pptx]==${MARKITDOWN_VERSION}" \
      "reportlab==${REPORTLAB_VERSION}" "pypdf==${PYPDF_VERSION}" "matplotlib==${MATPLOTLIB_VERSION}"; \
    tempDir="$(mktemp -d)"; \
    tarUrl="https://github.com/NousResearch/hermes-agent/archive/refs/tags/v${HERMES_VERSION}.tar.gz"; \
    curl -fL -o "${tempDir}/hermes.tar.gz" "${tarUrl}"; \
    tar -xf "${tempDir}/hermes.tar.gz" -C "${HERMES_INSTALL_DIR}" --strip-components 1; \
    rm -rf "${tempDir}"; \
    cd "${HERMES_INSTALL_DIR}"; \
    echo "git" > .install_method; \
    echo "AGENT_BROWSER_EXECUTABLE_PATH=${RUNTIME_HOME}/bin/chromium" >> .env.example; \
    UV_PROJECT_ENVIRONMENT=venv uv sync --extra all --locked; \
    npm install; \
    rm -rf ~/.npm; \
    rm -rf ~/.cache; \
    rm -rf /tmp/*

COPY --chown=appuser:appuser --chmod=775 hermes "${RUNTIME_HOME}/bin/hermes"

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 CMD hermes status | grep -A1 'Gateway Service' | grep -q 'running'

CMD hermes gateway
