FROM hackyo/jdk:8
LABEL maintainer="137120918@qq.com"
WORKDIR /root
RUN mkdir /usr/local/maven && mkdir /usr/local/maven/repo && \
    curl -L https://mirrors.bfsu.edu.cn/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -o /usr/local/maven/maven.tar.gz && \
    tar -xf /usr/local/maven/maven.tar.gz -C /usr/local/maven && \
    mv /usr/local/maven/apache-maven-3.6.3/* /usr/local/maven/ && \
    rm -r /usr/local/maven/apache-maven-3.6.3 /usr/local/maven/maven.tar.gz
COPY settings.xml /usr/local/maven/conf/settings.xml
ENV M2_HOME=/usr/local/maven
ENV PATH=$PATH:$M2_HOME/bin
CMD ["mvn", "-v"]
