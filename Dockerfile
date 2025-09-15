# syntax=docker/dockerfile:1
FROM hackyo/debian:trixie-slim

LABEL maintainer="137120918@qq.com" version="20250903"

ARG TARGETPLATFORM
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV UV_INSTALL_DIR="/usr/local/uv"
ENV UV_CACHE_DIR="${UV_INSTALL_DIR}/cache"
ENV UV_PYTHON_INSTALL_DIR="${UV_INSTALL_DIR}/python"
ENV UV_TOOL_DIR="${UV_INSTALL_DIR}/tool"
ENV PATH="${UV_INSTALL_DIR}:${PATH}"

COPY docker-entrypoint.sh /usr/local/bin/

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends gosu; \
    apt-get autoremove -y; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    chmod +x /usr/local/bin/docker-entrypoint.sh; \
    case "${TARGETPLATFORM}" in \
      "linux/amd64") arch="x86_64" ;; \
      "linux/arm64") arch="aarch64" ;; \
      *) echo "Unsupported platform: ${TARGETPLATFORM}"; exit 1 ;; \
    esac; \
    mkdir -p "${UV_INSTALL_DIR}"; \
    tempDir="$(mktemp -d)"; \
    tarUrl="https://github.com/astral-sh/uv/releases/download/0.8.17/uv-${arch}-unknown-linux-gnu.tar.gz"; \
    curl -fL -o "${tempDir}/uv.tar.gz" "${tarUrl}"; \
    tar -xf "${tempDir}/uv.tar.gz" -C "${UV_INSTALL_DIR}" --strip-components 1; \
    rm -rf "${tempDir}"; \
    uv -V

CMD ["uv", "-V"]
