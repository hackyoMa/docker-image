# syntax=docker/dockerfile:latest
FROM amd64/buildpack-deps:buster-curl as installer
LABEL maintainer="137120918@qq.com" version="20241030"

ARG NACOS_VERSION=2.4.3
ARG HOT_FIX_FLAG=""

RUN set -x \
    && curl -SL --output /var/tmp/nacos-server.tar.gz https://github.com/alibaba/nacos/releases/download/${NACOS_VERSION}${HOT_FIX_FLAG}/nacos-server-${NACOS_VERSION}.tar.gz \
    && tar -xzvf /var/tmp/nacos-server.tar.gz -C /home \
    && rm -rf /var/tmp/nacos-server.tar.gz /home/nacos/bin/* /home/nacos/conf/*.properties /home/nacos/conf/*.example /home/nacos/conf/nacos-mysql.sql

FROM hackyo/jre:8

# set environment
ENV MODE="cluster" \
    PREFER_HOST_MODE="ip"\
    BASE_DIR="/home/nacos" \
    CLASSPATH=".:/home/nacos/conf:$CLASSPATH" \
    CLUSTER_CONF="/home/nacos/conf/cluster.conf" \
    FUNCTION_MODE="all" \
    NACOS_USER="nacos" \
    JAVA="/usr/java/openjdk-8/bin/java" \
    JVM_XMS="1g" \
    JVM_XMX="1g" \
    JVM_XMN="512m" \
    JVM_MS="128m" \
    JVM_MMS="320m" \
    NACOS_DEBUG="n" \
    TOMCAT_ACCESSLOG_ENABLED="false"

WORKDIR $BASE_DIR

# copy nacos bin
COPY --from=installer ["/home/nacos", "/home/nacos"]

ADD bin/docker-startup.sh bin/docker-startup.sh
ADD conf/application.properties conf/application.properties

# set startup log dir
RUN mkdir -p logs \
    && cd logs \
    && touch start.out \
    && ln -sf /dev/stdout start.out \
    && ln -sf /dev/stderr start.out
RUN chmod +x bin/docker-startup.sh

EXPOSE 8848
ENTRYPOINT ["bin/docker-startup.sh"]
