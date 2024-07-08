# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM debian:bookworm-slim AS build
LABEL maintainer="137120918@qq.com" version="20240708"
ENV LANG=C.utf8
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone && \
    apt update -y && apt upgrade -y && \
    apt install -y apt-transport-https ca-certificates procps iproute2 iputils-ping tcpdump telnet curl wget vim fonts-dejavu fontconfig && \
    apt autoremove -y && apt clean && \
    sed -i 's/mouse=a/mouse-=a/g' /usr/share/vim/vim90/defaults.vim
CMD ["bash"]
