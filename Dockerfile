FROM node:lts-slim

LABEL maintainer "zhouyueqiu zhouyueqiu@easycorp.ltd"

ENV OS_ARCH="amd64" \
    OS_NAME="debian-11" \
    HOME_PAGE="https://github.com/jgraph/draw-image-export2"

COPY debian/prebuildfs /

ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive

ARG IS_CHINA="true"
ENV MIRROR=${IS_CHINA}

# Install draw-image-export
ARG VERSION
ENV APP_VER=${VERSION}
ENV EASYSOFT_APP_NAME="draw-image-export $APP_VER"

RUN install_packages curl s6 software-properties-common chromium libatk-bridge2.0-0 libgtk-3-0 \
    && apt-add-repository contrib \
    && install_packages ttf-mscorefonts-installer \
    && mkdir -pv /apps/ \
    && curl -Lk https://github.com/jgraph/draw-image-export2/archive/refs/tags/v${APP_VER}.tar.gz | tar xvz -C /apps/ \
    && mv /apps/draw-image-export2-${APP_VER} /apps/draw-image-export \
    && cd /apps/draw-image-export \
    && npm install \
    && apt-get remove -y --purge chromium \
    && rm -rf /root/.npm /tmp/*

# Copy draw-image-export config files
COPY debian/rootfs /

# Copy draw-image-export source code
WORKDIR /apps/draw-image-export

EXPOSE 8000

ENTRYPOINT ["/usr/bin/entrypoint.sh"]