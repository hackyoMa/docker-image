# syntax=docker/dockerfile:1
FROM debian:trixie-slim

LABEL maintainer="137120918@qq.com" version="20260312"

ENV LANG=C.UTF-8 \
    TZ=Asia/Shanghai

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY container-init.sh /usr/local/bin/

RUN set -eux; \
    ln -snf /usr/share/zoneinfo/"${TZ}" /etc/localtime; \
    echo "${TZ}" > /etc/timezone; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates procps iproute2 iputils-ping tcpdump curl netcat-openbsd vim gosu sudo; \
    rm -rf /var/lib/apt/lists/*; \
    chmod +x /usr/local/bin/container-init.sh; \
    mkdir /data; \
    chmod 1777 /data

CMD ["bash"]
