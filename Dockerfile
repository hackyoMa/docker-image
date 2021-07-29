# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/jdk:11 AS build
LABEL maintainer="137120918@qq.com" version="1.0.3"
ENV KEYCLOAK_VERSION=14.0.0
RUN mkdir /usr/local/keycloak && \
    curl -L https://github.com/keycloak/keycloak/releases/download/${KEYCLOAK_VERSION}/keycloak-${KEYCLOAK_VERSION}.tar.gz -o /usr/local/keycloak.tar.gz && \
    tar -xf /usr/local/keycloak.tar.gz -C /usr/local/keycloak && \
    mv /usr/local/keycloak/keycloak-${KEYCLOAK_VERSION}/* /usr/local/keycloak/ && \
    rm -r /usr/local/keycloak/keycloak-${KEYCLOAK_VERSION} /usr/local/keycloak.tar.gz

COPY mysql-module.xml /usr/local/keycloak/modules/system/layers/keycloak/com/mysql/main/module.xml
RUN curl -L https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.22/mysql-connector-java-8.0.22.jar -o /usr/local/keycloak/modules/system/layers/keycloak/com/mysql/main/mysql-connector-java.jar

COPY standalone.xml /usr/local/keycloak/standalone/configuration/standalone.xml
COPY standalone-ha.xml /usr/local/keycloak/standalone/configuration/standalone-ha.xml

HEALTHCHECK --interval=10s --timeout=5s --start-period=15s --retries=3 CMD curl -f http://localhost:8080/ || exit 1
EXPOSE 8080 8443
ENTRYPOINT ["/bin/bash", "/usr/local/keycloak/bin/standalone.sh", "--server-config=standalone-ha.xml"]
