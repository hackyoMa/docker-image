FROM debian:buster-slim
LABEL maintainer="137120918@qq.com"
WORKDIR /root
RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list
RUN apt update -y && \
    apt install -y apt-transport-https ca-certificates && \
    sed -i 's/http/https/g' /etc/apt/sources.list && \
    apt update -y && apt upgrade -y && \
    apt install -y procps iproute2 iputils-ping tcpdump telnet curl wget vim && \
    apt autoremove -y && apt clean
CMD ["bash"]
