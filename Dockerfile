FROM node:22-alpine

ENV FFMPEG_VERSION=7.0.2

WORKDIR /tmp/ffmpeg

# Install build dependencies
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
  librsvg

# Install graphicsmagick from the edge repository
RUN apk add --no-cache \
  --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
  graphicsmagick

# Download FFmpeg source with HTTPS and check the contents
RUN DIR=$(mktemp -d) && cd ${DIR} && \
  curl -sL "https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz" -o ffmpeg-${FFMPEG_VERSION}.tar.gz && \
  echo "Downloaded file:" && ls -l ffmpeg-${FFMPEG_VERSION}.tar.gz && \
  file ffmpeg-${FFMPEG_VERSION}.tar.gz && \
  tar -xvf ffmpeg-${FFMPEG_VERSION}.tar.gz && \
  cd ffmpeg-${FFMPEG_VERSION} && \
  ./configure --enable-version3 --enable-gpl --enable-nonfree --enable-small --enable-libfdk-aac --disable-debug && \
  make && \
  make install && \
  make distclean

# Clean up temporary files and unnecessary packages
RUN rm -rf ${DIR} && \
  apk del build-base curl tar bzip2 && \
  rm -rf /var/cache/apk/*
