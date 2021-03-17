FROM hackyo/debian:buster-slim
LABEL maintainer="137120918@qq.com"
WORKDIR /root
RUN mkdir /usr/local/node && mkdir /usr/local/node/node_cache && mkdir /usr/local/node/node_global && \
    curl -L https://npm.taobao.org/mirrors/node/v14.16.0/node-v14.16.0-linux-arm64.tar.gz -o /usr/local/node/node.tar.gz && \
    tar -xf /usr/local/node/node.tar.gz -C /usr/local/node && \
    mv /usr/local/node/node-v14.16.0-linux-arm64/* /usr/local/node/ && \
    rm -r /usr/local/node/node-v14.16.0-linux-arm64 /usr/local/node/node.tar.gz
ENV NODE_HOME=/usr/local/node
ENV PATH=$PATH:$NODE_HOME/bin:$NODE_HOME/node_global/bin
RUN npm config set prefix "/usr/local/node/node_global" && \
    npm config set cache "/usr/local/node/node_cache" && \
    npm config set registry "https://registry.npm.taobao.org"
CMD ["node", "-v"]
