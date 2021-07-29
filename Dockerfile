# syntax=docker/dockerfile:latest
FROM --platform=$TARGETPLATFORM hackyo/debian:bullseye-slim AS build
LABEL maintainer="137120918@qq.com" version="1.0.3"
ARG TARGETPLATFORM
ENV NODE_VERSION=16.5.0 NODE_HOME=/usr/local/node
ENV PATH=${PATH}:${NODE_HOME}/bin:${NODE_HOME}/node_global/bin
RUN if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then DOWNLOAD_ARCH="x64"; else DOWNLOAD_ARCH="arm64"; fi && \
    mkdir /usr/local/node && mkdir /usr/local/node/node_cache && mkdir /usr/local/node/node_global && \
    curl -L https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${DOWNLOAD_ARCH}.tar.gz -o /usr/local/node/node.tar.gz && \
    tar -xf /usr/local/node/node.tar.gz -C /usr/local/node && \
    mv /usr/local/node/node-v${NODE_VERSION}-linux-${DOWNLOAD_ARCH}/* /usr/local/node/ && \
    rm -r /usr/local/node/node-v${NODE_VERSION}-linux-${DOWNLOAD_ARCH} /usr/local/node/node.tar.gz
RUN npm config set prefix "/usr/local/node/node_global" && \
    npm config set cache "/usr/local/node/node_cache" && \
    npm config set registry "https://registry.npm.taobao.org"
CMD ["node", "-v"]
