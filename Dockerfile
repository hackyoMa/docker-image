# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/jre:11 AS build
LABEL maintainer="137120918@qq.com" version="2.0.3"
ENV KEYCLOAK_VERSION=16.1.1 KEYCLOAK_HOME=/opt/jboss/keycloak
RUN mkdir -p ${KEYCLOAK_HOME} && \
    curl -L https://github.com/keycloak/keycloak/releases/download/${KEYCLOAK_VERSION}/keycloak-${KEYCLOAK_VERSION}.tar.gz -o ${KEYCLOAK_HOME}/keycloak.tar.gz && \
    tar -xf ${KEYCLOAK_HOME}/keycloak.tar.gz -C ${KEYCLOAK_HOME} && \
    mv ${KEYCLOAK_HOME}/keycloak-${KEYCLOAK_VERSION}/* ${KEYCLOAK_HOME}/ && \
    rm -r ${KEYCLOAK_HOME}/keycloak-${KEYCLOAK_VERSION} ${KEYCLOAK_HOME}/keycloak.tar.gz && \
    mkdir -p ${KEYCLOAK_HOME}/modules/system/layers/keycloak/com/mysql/jdbc/main && \
    curl -L https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.27/mysql-connector-java-8.0.27.jar -o ${KEYCLOAK_HOME}/modules/system/layers/keycloak/com/mysql/jdbc/main/mysql-connector-java.jar

COPY mysql-module.xml ${KEYCLOAK_HOME}/modules/system/layers/keycloak/com/mysql/jdbc/main/module.xml
COPY standalone.xml ${KEYCLOAK_HOME}/standalone/configuration/standalone.xml
COPY standalone-ha.xml ${KEYCLOAK_HOME}/standalone/configuration/standalone-ha.xml

HEALTHCHECK --interval=10s --timeout=5s --start-period=15s --retries=3 CMD curl -f http://localhost:8080/ || exit 1
EXPOSE 8080 8443
ENTRYPOINT /bin/bash ${KEYCLOAK_HOME}/bin/standalone.sh --server-config=standalone-ha.xml
