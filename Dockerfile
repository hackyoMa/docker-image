# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/debian:bullseye-slim AS build
LABEL maintainer="137120918@qq.com" version="2.0.1"
ARG TARGETPLATFORM
ENV NODE_VERSION=16.13.2 NODE_HOME=/usr/local/node
ENV PATH=${PATH}:${NODE_HOME}/bin:${NODE_HOME}/node_global/bin
RUN if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then DOWNLOAD_ARCH="x64"; else DOWNLOAD_ARCH="arm64"; fi && \
    mkdir ${NODE_HOME} && mkdir ${NODE_HOME}/node_cache && mkdir ${NODE_HOME}/node_global && \
    curl -L https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${DOWNLOAD_ARCH}.tar.gz -o ${NODE_HOME}/node.tar.gz && \
    tar -xf ${NODE_HOME}/node.tar.gz -C ${NODE_HOME} && \
    mv ${NODE_HOME}/node-v${NODE_VERSION}-linux-${DOWNLOAD_ARCH}/* ${NODE_HOME}/ && \
    rm -r ${NODE_HOME}/node-v${NODE_VERSION}-linux-${DOWNLOAD_ARCH} ${NODE_HOME}/node.tar.gz && \
    npm config set prefix "${NODE_HOME}/node_global" && \
    npm config set cache "${NODE_HOME}/node_cache" && \
    npm config set registry "https://registry.npmmirror.com"
CMD ["node", "-v"]
