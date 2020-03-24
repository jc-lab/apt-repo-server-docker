FROM ubuntu:16.04

LABEL maintainer="JC-Lab <development@jc-lab.net>"

ARG NGINX_DEB_URL_PREFIX=https://nginx.org/packages/ubuntu/pool/nginx/n/nginx/nginx_1.14.0-1~xenial_

RUN set -x \
    && apt-get update \
    && apt-get install -y ca-certificates wget

RUN set -x \
    && dpkgArch="$(dpkg --print-architecture)" \
    && wget -O /tmp/nginx.deb ${NGINX_DEB_URL_PREFIX}${dpkgArch}.deb \
    && dpkg -i /tmp/nginx.deb \
    && rm /tmp/nginx.deb \
    && rm -f /etc/nginx/conf.d/*.conf

COPY ["node-installer.sh", "/tmp/"]

RUN set -x \
    && chmod +x /tmp/node-installer.sh \
    && /tmp/node-installer.sh

RUN set -x \
    && apt-get clean

ENV REPO_UPDATER_APP_PATH=/opt/repo-updater

COPY ["nginx.conf", "nginx-default.conf", "/tmp/"]
ADD ["repo-updater.tar.gz", "/opt/repo-updater"]

RUN set -x \
    && mv -f /tmp/nginx.conf /etc/nginx/nginx.conf \
    && mv -f /tmp/nginx-default.conf /etc/nginx/conf.d/default.conf \
    && mkdir -p /data/pool && mkdir -p /data/dists \
    && chown nginx:nginx -R /data

CMD ["nginx", "-g", "daemon off;"]


