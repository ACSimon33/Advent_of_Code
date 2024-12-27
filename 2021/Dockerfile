# syntax=docker/dockerfile:1
FROM rustlang/rust:nightly

# Setup rust toolchain
RUN rustup component add rustfmt
RUN cargo install --locked cargo2junit

# Install git-crypt and copy symmetric key
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    git-crypt && \
  rm -rf /var/lib/apt/lists/*

ARG GIT_CRYPT_KEY
COPY ${GIT_CRYPT_KEY} /git-crypt-key.key
