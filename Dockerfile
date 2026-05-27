# syntax=docker/dockerfile:1
FROM hackyo/debian:trixie-slim

LABEL org.opencontainers.image.authors="hackyo" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.source="https://github.com/hackyoMa/docker-image/tree/frp-0"

ARG TARGETPLATFORM

ENV FRP_HOME="/usr/local/frp"
ENV PATH="${FRP_HOME}:${PATH}"

RUN set -eux; \
    case "${TARGETPLATFORM}" in \
      "linux/amd64") arch="amd64" ;; \
      "linux/arm64") arch="arm64" ;; \
      *) echo "Unsupported platform: ${TARGETPLATFORM}"; exit 1 ;; \
    esac; \
    mkdir -p "${FRP_HOME}"; \
    tempDir="$(mktemp -d)"; \
    tarUrl="https://github.com/fatedier/frp/releases/download/v0.69.0/frp_0.69.0_linux_${arch}.tar.gz"; \
    curl -fL -o "${tempDir}/frp.tar.gz" "${tarUrl}"; \
    tar -xf "${tempDir}/frp.tar.gz" -C "${FRP_HOME}" --strip-components 1; \
    rm -rf "${tempDir}" \
           "${FRP_HOME}/LICENSE"; \
    frps --version

CMD ["frps", "-c", "/usr/local/frp/frps.toml"]
