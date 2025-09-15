# syntax=docker/dockerfile:1
FROM debian:trixie-slim

LABEL maintainer="137120918@qq.com" version="20250903"

ENV LANG=C.UTF-8 \
    TZ=Asia/Shanghai

RUN set -eux; \
    ln -snf /usr/share/zoneinfo/"${TZ}" /etc/localtime; \
    echo "${TZ}" > /etc/timezone; \
    apt-get update; \
    apt-get upgrade -y --no-install-recommends; \
    apt-get install -y --no-install-recommends ca-certificates procps iproute2 iputils-ping tcpdump telnet curl; \
    apt-get autoremove -y; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

CMD ["bash"]
