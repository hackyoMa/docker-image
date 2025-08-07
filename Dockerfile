# syntax=docker/dockerfile:1
FROM debian:bookworm-slim

LABEL maintainer="137120918@qq.com" version="20250806"

ENV LANG=C.utf8 \
    TZ=Asia/Shanghai

RUN set -eux; \
    ln -sf /usr/share/zoneinfo/"${TZ}" /etc/localtime; \
    echo "${TZ}" > /etc/timezone; \
    apt update -y; \
    apt upgrade -y; \
    apt install -y apt-transport-https ca-certificates procps iproute2 iputils-ping tcpdump telnet curl; \
    apt autoremove -y; \
    apt clean

CMD ["bash"]
