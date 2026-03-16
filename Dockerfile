# syntax=docker/dockerfile:1
FROM hackyo/debian:trixie-slim

LABEL maintainer="137120918@qq.com" version="20260312"

ARG TARGETPLATFORM
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

RUN set -eux; \
    case "${TARGETPLATFORM}" in \
      "linux/amd64") arch="x86_64" ;; \
      "linux/arm64") arch="aarch64" ;; \
      *) echo "Unsupported platform: ${TARGETPLATFORM}"; exit 1 ;; \
    esac; \
    tempDir="$(mktemp -d)"; \
    tarUrl="https://github.com/astral-sh/uv/releases/download/0.10.9/uv-${arch}-unknown-linux-gnu.tar.gz"; \
    curl -fL -o "${tempDir}/uv.tar.gz" "${tarUrl}"; \
    tar -xf "${tempDir}/uv.tar.gz" -C "/usr/local/bin" --strip-components 1; \
    rm -rf "${tempDir}"; \
    uv -V

CMD ["uv"]
