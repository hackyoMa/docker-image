# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM debian:buster-slim AS build
LABEL maintainer="137120918@qq.com"
ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8
WORKDIR /root
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list && \
    apt update -y && apt install -y apt-transport-https ca-certificates && \
    sed -i 's/http/https/g' /etc/apt/sources.list && apt update -y && apt upgrade -y && \
    apt install -y procps iproute2 iputils-ping tcpdump telnet curl wget vim && \
    apt autoremove -y && apt clean
CMD ["bash"]
