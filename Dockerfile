# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM debian:bookworm-slim AS build
LABEL maintainer="137120918@qq.com" version="20240425"
ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone && \
    rm /etc/apt/sources.list.d/debian.sources && \
    echo "deb http://mirrors.aliyun.com/debian bookworm main contrib non-free non-free-firmware" > /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian-security/ bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian bookworm-backports main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    apt update -y && apt install -y apt-transport-https ca-certificates && \
    sed -i 's/http/https/g' /etc/apt/sources.list && apt update -y && apt upgrade -y && \
    apt install -y procps iproute2 iputils-ping tcpdump telnet curl wget vim ttf-dejavu fontconfig && \
    apt autoremove -y && apt clean
CMD ["bash"]
