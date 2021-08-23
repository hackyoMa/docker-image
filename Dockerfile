# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/jdk:8 AS build
LABEL maintainer="137120918@qq.com" version="1.0.3"
ENV ELASTICSEARCH_VERSION=6.6.0
RUN mkdir /usr/local/elasticsearch && \
    curl -L https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz -o /usr/local/elasticsearch/elasticsearch.tar.gz && \
    tar -xf /usr/local/elasticsearch/elasticsearch.tar.gz -C /usr/local/elasticsearch && \
    mv /usr/local/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}/* /usr/local/elasticsearch/ && \
    rm -r /usr/local/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION} /usr/local/elasticsearch/elasticsearch.tar.gz

HEALTHCHECK --interval=10s --timeout=5s --start-period=15s --retries=3 CMD curl -f http://localhost:9200/ || exit 1
EXPOSE 9200 9300
ENTRYPOINT ["/usr/local/elasticsearch/bin/elasticsearch"]
