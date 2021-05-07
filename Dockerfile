# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/jdk:11 AS build
LABEL maintainer="137120918@qq.com"
ENV SENTINEL_VERSION=1.8.1
RUN mkdir /usr/local/sentinel && \
    curl -L https://github.com/alibaba/Sentinel/releases/download/${SENTINEL_VERSION}/sentinel-dashboard-${SENTINEL_VERSION}.jar -o /usr/local/sentinel/sentinel-dashboard.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/usr/local/sentinel/sentinel-dashboard.jar"]
