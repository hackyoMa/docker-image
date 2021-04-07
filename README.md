### Commonly used docker images

Use example: `docker pull hackyo/debian:buster-slim`

### Dockerfile:

- hackyo/debian
    - [buster-slim](https://github.com/hackyoMa/docker-image/blob/debian-buster-slim/Dockerfile)
- hackyo/jdk
    - [8](https://github.com/hackyoMa/docker-image/blob/jdk-8/Dockerfile)
    - [11](https://github.com/hackyoMa/docker-image/blob/jdk-11/Dockerfile)
- hackyo/nacos
    - [2.0.0](https://github.com/hackyoMa/docker-image/blob/nacos-2.0.0/Dockerfile)
- hackyo/maven
  - [3.6.3-jdk-8](https://github.com/hackyoMa/docker-image/blob/maven-3.6.3-jdk-8/Dockerfile)
  - [3.6.3-jdk-11](https://github.com/hackyoMa/docker-image/blob/maven-3.6.3-jdk-11/Dockerfile)
- hackyo/node
  - [14.16.0](https://github.com/hackyoMa/docker-image/blob/node-14.16.0/Dockerfile)
- hackyo/sentinel
  - [1.8.1](https://github.com/hackyoMa/docker-image/blob/sentinel-1.8.1/Dockerfile)
- hackyo/keycloak
  - [12.0.4](https://github.com/hackyoMa/docker-image/blob/keycloak-12.0.4/Dockerfile)
  - Run: docker run -d -p 8080:8080 -p 8443:8443 -p 9990:9990 hackyo/keycloak:12.0.4
  - Work dir: /root/keycloak/
  - Default admin user: admin/admin
