# syntax=docker/dockerfile:latest
FROM hackyo/jre:21
LABEL maintainer="137120918@qq.com" version="20241030"
ENV SENTINEL_VERSION=1.8.8
RUN mkdir /opt/app && \
    curl -L https://github.com/alibaba/Sentinel/releases/download/${SENTINEL_VERSION}/sentinel-dashboard-${SENTINEL_VERSION}.jar -o /opt/app/app.jar
ENTRYPOINT ["java", "-jar", "/opt/app/app.jar"]
