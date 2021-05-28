### Commonly used docker images

Supported Platforms: `linux/amd64, linux/arm64`

Use example: `docker pull hackyo/debian:buster-slim`

### Dockerfile:

- hackyo/debian
    - [buster-slim](https://github.com/hackyoMa/docker-image/blob/debian-buster-slim/Dockerfile)
- hackyo/jdk
    - [8](https://github.com/hackyoMa/docker-image/blob/jdk-8/Dockerfile)
    - [11](https://github.com/hackyoMa/docker-image/blob/jdk-11/Dockerfile)
- hackyo/nacos
    - [2.0](https://github.com/hackyoMa/docker-image/blob/nacos-2.0/Dockerfile)
    - Usage reference: [https://github.com/nacos-group/nacos-docker/blob/master/README.md](https://github.com/nacos-group/nacos-docker)
- hackyo/maven
  - [3.6-jdk-8](https://github.com/hackyoMa/docker-image/blob/maven-3.6-jdk-8/Dockerfile)
  - [3.6-jdk-11](https://github.com/hackyoMa/docker-image/blob/maven-3.6-jdk-11/Dockerfile)
  - [3.8-jdk-8](https://github.com/hackyoMa/docker-image/blob/maven-3.8-jdk-8/Dockerfile)
  - [3.8-jdk-11](https://github.com/hackyoMa/docker-image/blob/maven-3.8-jdk-11/Dockerfile)
- hackyo/node
  - [14](https://github.com/hackyoMa/docker-image/blob/node-14/Dockerfile)
  - [16](https://github.com/hackyoMa/docker-image/blob/node-16/Dockerfile)
- hackyo/sentinel
  - [1.8](https://github.com/hackyoMa/docker-image/blob/sentinel-1.8/Dockerfile)
- hackyo/zipkin
  - [2](https://github.com/hackyoMa/docker-image/blob/zipkin-2/Dockerfile)
- hackyo/keycloak
  - [4.8.3.Final](https://github.com/hackyoMa/docker-image/blob/keycloak-4.8.3.Final/Dockerfile)
  - [12](https://github.com/hackyoMa/docker-image/blob/keycloak-12/Dockerfile)
  - Run: `docker run -d -p 8080:8080 -p 8443:8443 -p 9990:9990 hackyo/keycloak:12.0.4`
  - Work dir: `/usr/local/keycloak/`
  - Admin default password: `admin`
