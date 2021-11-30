# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/jre:11 AS build
LABEL maintainer="137120918@qq.com" version="1.0.5"
ENV SENTINEL_VERSION=1.8.2
RUN mkdir /usr/local/sentinel && \
    curl -L https://github.com/alibaba/Sentinel/releases/download/${SENTINEL_VERSION}/sentinel-dashboard-${SENTINEL_VERSION}.jar -o /usr/local/sentinel/sentinel-dashboard.jar
HEALTHCHECK --interval=10s --timeout=5s --start-period=5s --retries=3 CMD curl -f http://localhost:8080/ || exit 1
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/usr/local/sentinel/sentinel-dashboard.jar"]
