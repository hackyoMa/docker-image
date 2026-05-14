# syntax=docker/dockerfile:1
FROM debian:trixie-slim

LABEL org.opencontainers.image.authors="hackyo" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.source="https://github.com/hackyoMa/docker-image/tree/debian-trixie-slim"

ARG DEBIAN_FRONTEND=noninteractive

ENV LANG=C.UTF-8 \
    TZ=Asia/Shanghai

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -eux; \
    ln -snf /usr/share/zoneinfo/"${TZ}" /etc/localtime; \
    echo "${TZ}" > /etc/timezone; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates procps iproute2 iputils-ping curl netcat-openbsd vim-tiny sudo; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    groupadd -g 1000 appuser; \
    useradd -m -u 1000 -g appuser appuser

CMD ["/bin/bash"]
