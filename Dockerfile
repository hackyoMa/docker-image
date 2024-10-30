# syntax=docker/dockerfile:latest
FROM debian:bookworm-slim
LABEL maintainer="137120918@qq.com" version="20241030"
ENV LANG=C.utf8
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone && \
    apt update -y && apt upgrade -y && \
    apt install -y apt-transport-https ca-certificates procps iproute2 iputils-ping tcpdump telnet curl fonts-dejavu fontconfig && \
    apt autoremove -y && apt clean
CMD ["bash"]
