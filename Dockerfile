# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/debian:bullseye-slim AS build
LABEL maintainer="137120918@qq.com" version="20231013"
ARG TARGETPLATFORM
ENV NODE_VERSION=18.18.1 NODE_HOME=/usr/local
ENV PATH=${PATH}:${NODE_HOME}/node_global/bin:${NODE_HOME}/bin
RUN if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then DOWNLOAD_ARCH="x64"; else DOWNLOAD_ARCH="arm64"; fi && \
    mkdir ${NODE_HOME}/node_cache && mkdir ${NODE_HOME}/node_global && \
    curl -L https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${DOWNLOAD_ARCH}.tar.gz -o ${NODE_HOME}/node.tar.gz && \
    tar -xf ${NODE_HOME}/node.tar.gz -C ${NODE_HOME} && \
    cp -r ${NODE_HOME}/node-v${NODE_VERSION}-linux-${DOWNLOAD_ARCH}/* ${NODE_HOME}/ && \
    rm -rf ${NODE_HOME}/node-v${NODE_VERSION}-linux-${DOWNLOAD_ARCH} ${NODE_HOME}/node.tar.gz && \
    npm config set prefix "${NODE_HOME}/node_global" && \
    npm config set cache "${NODE_HOME}/node_cache" && \
    npm config set registry "https://registry.npmmirror.com" && \
    npm install -g npm
CMD node -v && npm -v
