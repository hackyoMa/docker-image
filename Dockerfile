# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/jre:11 AS build
LABEL maintainer="137120918@qq.com" version="20220510"

ENV KEYCLOAK_VERSION 18.0.0
ENV JDBC_POSTGRES_VERSION 42.3.3
ENV JDBC_MYSQL_VERSION 8.0.22
ENV JDBC_MARIADB_VERSION 2.5.4
ENV JDBC_MSSQL_VERSION 10.2.0.jre11

ENV LAUNCH_JBOSS_IN_BACKGROUND 1
ENV PROXY_ADDRESS_FORWARDING false
ENV JBOSS_HOME /opt/jboss/keycloak
ENV LANG en_US.UTF-8

ARG GIT_REPO
ARG GIT_BRANCH
ARG KEYCLOAK_DIST=https://github.com/keycloak/keycloak/releases/download/$KEYCLOAK_VERSION/keycloak-legacy-$KEYCLOAK_VERSION.tar.gz

USER root

RUN useradd -m jboss

ADD tools /opt/jboss/tools
RUN /opt/jboss/tools/build-keycloak.sh

USER 1000

EXPOSE 8080
EXPOSE 8443

ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]

CMD ["-b", "0.0.0.0"]
