FROM hackyo/jdk:8
LABEL maintainer="137120918@qq.com"
WORKDIR /root/keycloak
RUN curl -L https://downloads.jboss.org/keycloak/4.8.3.Final/keycloak-4.8.3.Final.tar.gz -o /root/keycloak.tar.gz && \
    tar -xf /root/keycloak.tar.gz -C /root/keycloak && \
    mv /root/keycloak/keycloak-4.8.3.Final/* /root/keycloak/ && \
    rm -r /root/keycloak/keycloak-4.8.3.Final /root/keycloak.tar.gz

COPY mysql-module.xml /root/keycloak/modules/system/layers/keycloak/com/mysql/main/module.xml
RUN curl -L https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.22/mysql-connector-java-8.0.22.jar -o /root/keycloak/modules/system/layers/keycloak/com/mysql/main/mysql-connector-java.jar

COPY standalone.xml /root/keycloak/standalone/configuration/standalone.xml
COPY standalone-ha.xml /root/keycloak/standalone/configuration/standalone-ha.xml
RUN /bin/bash /root/keycloak/bin/add-user-keycloak.sh -u admin -p admin

ENTRYPOINT ["/bin/bash", "/root/keycloak/bin/standalone.sh", "--server-config=standalone-ha.xml"]
