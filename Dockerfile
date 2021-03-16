FROM hackyo/debian:buster-slim
LABEL maintainer="137120918@qq.com"
WORKDIR /root
RUN mkdir /usr/local/java && \
    curl -L https://cdn.azul.com/zulu-embedded/bin/zulu8.52.0.23-ca-jdk8.0.282-linux_aarch64.tar.gz -o /usr/local/java/jdk.tar.gz && \
    tar -xf /usr/local/java/jdk.tar.gz -C /usr/local/java && \
    mv /usr/local/java/zulu8.52.0.23-ca-jdk8.0.282-linux_aarch64/* /usr/local/java/ && \
    rm -r /usr/local/java/zulu8.52.0.23-ca-jdk8.0.282-linux_aarch64 /usr/local/java/jdk.tar.gz
ENV JAVA_HOME=/usr/local/java
ENV CLASSPATH=$JAVA_HOME/lib
ENV PATH=$PATH:$JAVA_HOME/bin
CMD ["java", "-version"]
