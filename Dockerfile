# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/jdk:11 AS build
LABEL maintainer="137120918@qq.com" version="1.0.5"
ENV ELASTICSEARCH_VERSION=6.6.0
RUN useradd -m elasticsearch -s /bin/bash && \
    mkdir /usr/local/elasticsearch && \
    chown -R elasticsearch /usr/local/elasticsearch
USER elasticsearch
RUN curl -L https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz -o /usr/local/elasticsearch/elasticsearch.tar.gz && \
    tar -xf /usr/local/elasticsearch/elasticsearch.tar.gz -C /usr/local/elasticsearch && \
    mv /usr/local/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}/* /usr/local/elasticsearch/ && \
    rm -r /usr/local/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION} /usr/local/elasticsearch/elasticsearch.tar.gz
COPY elasticsearch.yml /usr/local/elasticsearch/config/elasticsearch.yml

HEALTHCHECK --interval=10s --timeout=5s --start-period=15s --retries=3 CMD curl -f http://localhost:9200/ || exit 1
EXPOSE 9200 9300
ENTRYPOINT ["/usr/local/elasticsearch/bin/elasticsearch"]
