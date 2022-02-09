# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/jdk:8 AS build
LABEL maintainer="137120918@qq.com" version="2.0.2"
ENV ELASTICSEARCH_VERSION=6.6.0 ELASTICSEARCH_HOME=/usr/local/elasticsearch
RUN useradd -m elasticsearch -s /bin/bash && \
    mkdir ${ELASTICSEARCH_HOME} && \
    chown -R elasticsearch ${ELASTICSEARCH_HOME}
USER elasticsearch
RUN curl -L https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz -o ${ELASTICSEARCH_HOME}/elasticsearch.tar.gz && \
    tar -xf ${ELASTICSEARCH_HOME}/elasticsearch.tar.gz -C ${ELASTICSEARCH_HOME} && \
    mv ${ELASTICSEARCH_HOME}/elasticsearch-${ELASTICSEARCH_VERSION}/* ${ELASTICSEARCH_HOME}/ && \
    rm -r ${ELASTICSEARCH_HOME}/elasticsearch-${ELASTICSEARCH_VERSION} ${ELASTICSEARCH_HOME}/elasticsearch.tar.gz
COPY elasticsearch.yml ${ELASTICSEARCH_HOME}/config/elasticsearch.yml

HEALTHCHECK --interval=10s --timeout=5s --start-period=15s --retries=3 CMD curl -f http://localhost:9200/ || exit 1
EXPOSE 9200 9300
ENTRYPOINT ${ELASTICSEARCH_HOME}/bin/elasticsearch
