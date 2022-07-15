# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM debian:bullseye-slim AS build
LABEL maintainer="137120918@qq.com" version="20220715"
ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone && \
    echo "deb http://mirrors.aliyun.com/debian bullseye main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian-security bullseye-security main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian bullseye-updates main contrib non-free" >> /etc/apt/sources.list && \
    apt update -y && apt install -y apt-transport-https ca-certificates && \
    sed -i 's/http/https/g' /etc/apt/sources.list && apt update -y && apt upgrade -y && \
    apt install -y procps iproute2 iputils-ping tcpdump telnet curl wget vim && \
    apt autoremove -y && apt clean
CMD ["bash"]
