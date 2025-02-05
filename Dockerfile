FROM node:22.13.1-alpine

ENV FFMPEG_VERSION=4.2.1

WORKDIR /tmp/ffmpeg

RUN apk add --no-cache \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    fdk-aac-dev && \
  apk add --no-cache --update \
    build-base curl tar bzip2 zlib-dev \
    automake \
    autoconf \
    coreutils \
    nasm \
    file \
    libpng-dev \
    make \
    bash \
    git \
    python3 \
    g++ \
    imagemagick \
    gettext \
    librsvg && \
  apk add --no-cache \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    graphicsmagick && \

  DIR=$(mktemp -d) && cd ${DIR} && \

  curl -s http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz | tar zxvf - -C . && \
  cd ffmpeg-${FFMPEG_VERSION} && \
  ./configure --enable-version3 --enable-gpl --enable-nonfree --enable-small --enable-libfdk-aac --disable-debug && \
  make && \
  make install && \
  make distclean && \

  rm -rf ${DIR} && \
  apk del build-base curl tar bzip2 && rm -rf /var/cache/apk/*
