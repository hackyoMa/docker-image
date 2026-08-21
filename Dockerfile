# syntax=docker/dockerfile:1
FROM hackyo/debian:trixie-slim

ARG TARGETPLATFORM
ARG UV_VERSION=0.12.5

RUN set -eux; \
    case "${TARGETPLATFORM}" in \
      "linux/amd64") arch="x86_64" ;; \
      "linux/arm64") arch="aarch64" ;; \
      *) echo "Unsupported platform: ${TARGETPLATFORM}"; exit 1 ;; \
    esac; \
    curl -fsSL "https://github.com/astral-sh/uv/releases/download/${UV_VERSION}/uv-${arch}-unknown-linux-gnu.tar.gz" \
      | tar -xzf - -C "/usr/local/bin" --strip-components 1; \
    uv -V

CMD ["uv"]
