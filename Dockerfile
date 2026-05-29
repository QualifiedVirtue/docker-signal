# syntax=docker/dockerfile:1

# Runtime Stage
FROM ghcr.io/linuxserver/baseimage-selkies:arch

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SIGNAL_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

ENV TITLE="Signal" \
    NO_GAMEPAD=true \
    PIXELFLUX_WAYLAND=true 

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/signal-logo.png && \
  echo "**** install packages ****" && \
  pacman -Syu --noconfirm \
   "signal-desktop${SIGNAL_VERSION:+=$SIGNAL_VERSION}" && \
  echo "**** allow optional chromium sandbox (opt-in via SIGNAL_SANDBOX) ****" && \
  if [ -f /usr/lib/signal-desktop/chrome-sandbox ]; then \
    chown root:root /usr/lib/signal-desktop/chrome-sandbox && \
    chmod 4755 /usr/lib/signal-desktop/chrome-sandbox; \
  fi && \
  echo "**** cleanup ****" && \
  printf \
    "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" \
    > /build_version && \
  pacman -Scc --noconfirm && \
  rm -rf \
    /tmp/* \
    /var/cache/pacman/pkg/* \
    /var/lib/pacman/sync/*

# add local files and files from buildstage
COPY root/ /

# ports and volumes
VOLUME /config
EXPOSE 3001
