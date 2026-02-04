# syntax=docker/dockerfile:1
FROM hackyo/debian:trixie-slim

LABEL maintainer="137120918@qq.com" version="20260204"

ARG TARGETPLATFORM
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV UV_HOME="/usr/local/uv"
ENV UV_CACHE_DIR="${UV_HOME}/cache"
ENV UV_CREDENTIALS_DIR="${UV_HOME}/config"
ENV UV_PYTHON_BIN_DIR="${UV_HOME}/python_bin"
ENV UV_PYTHON_CACHE_DIR="${UV_HOME}/python_cache"
ENV UV_PYTHON_INSTALL_DIR="${UV_HOME}/python_install"
ENV UV_TOOL_BIN_DIR="${UV_HOME}/tool_bin"
ENV UV_TOOL_DIR="${UV_HOME}/tool"
ENV PATH="${UV_HOME}/bin:${UV_PYTHON_BIN_DIR}:${UV_TOOL_BIN_DIR}:${PATH}"

RUN set -eux; \
    case "${TARGETPLATFORM}" in \
      "linux/amd64") arch="x86_64" ;; \
      "linux/arm64") arch="aarch64" ;; \
      *) echo "Unsupported platform: ${TARGETPLATFORM}"; exit 1 ;; \
    esac; \
    mkdir -p "${UV_HOME}/bin"; \
    tempDir="$(mktemp -d)"; \
    tarUrl="https://github.com/astral-sh/uv/releases/download/0.9.28/uv-${arch}-unknown-linux-gnu.tar.gz"; \
    curl -fL -o "${tempDir}/uv.tar.gz" "${tarUrl}"; \
    tar -xf "${tempDir}/uv.tar.gz" -C "${UV_HOME}/bin" --strip-components 1; \
    rm -rf "${tempDir}"; \
    uv -V

CMD ["uv"]
