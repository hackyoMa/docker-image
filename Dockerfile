# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/jdk:11 AS build
LABEL maintainer="137120918@qq.com" version="1.0.3"
ENV ZIPKIN_VERSION=2.23.2
RUN mkdir /usr/local/zipkin && \
    curl -L https://repo1.maven.org/maven2/io/zipkin/zipkin-server/${ZIPKIN_VERSION}/zipkin-server-${ZIPKIN_VERSION}-exec.jar -o /usr/local/zipkin/zipkin.jar
HEALTHCHECK --interval=10s --timeout=5s --start-period=5s --retries=3 CMD curl -f http://localhost:9411/ || exit 1
EXPOSE 9411
ENTRYPOINT ["java", "-jar", "/usr/local/zipkin/zipkin.jar"]
