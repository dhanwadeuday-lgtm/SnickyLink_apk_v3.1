FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    FLUTTER_HOME=/opt/flutter \
    PATH="/opt/flutter/bin:${PATH}"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      git \
      unzip \
      xz-utils \
      build-essential \
      python3 \
      python3-dev \
      python3-venv \
      python3-pip \
      libpq-dev \
      postgresql \
      postgresql-contrib \
      redis-server \
      nginx-light \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.35.3-stable.tar.xz \
      | tar -xJ -C /opt \
    && git config --system --add safe.directory /opt/flutter \
    && flutter config --no-analytics \
    && flutter precache --web

WORKDIR /workspace
