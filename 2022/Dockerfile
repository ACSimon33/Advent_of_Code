# syntax=docker/dockerfile:1
FROM node:19.5.0

# Install aha (Ansi HTML Adapter), git-crypt and copy symmetric key
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    aha \
    git-crypt && \
  rm -rf /var/lib/apt/lists/*

ARG GIT_CRYPT_KEY
COPY ${GIT_CRYPT_KEY} /git-crypt-key.key
