# syntax=docker/dockerfile:1
FROM alpine:3.21.0 AS builder
RUN apk add --no-cache alpine-sdk

# Build aha (Ansi HTML Adapter) 0.5.1 from source
RUN \
  wget https://github.com/theZiz/aha/archive/refs/tags/0.5.1.tar.gz && \
  aha_sha512="0eb88e681208c0956e344d6574f9d7ba155d38bfb386d0a9f17022c5e925fb16d0efb6aa04804191b4cac1697a87a0f16ba51bcd97b6135cc7606046eaf89288" && \
  echo "$aha_sha512 0.5.1.tar.gz" | sha512sum -c - && \
  tar -xf 0.5.1.tar.gz && \
  cd aha-0.5.1 && \
  make

FROM alpine:3.21.0
RUN apk add --no-cache git-crypt bash zig

COPY --from=builder /aha-0.5.1/aha /usr/local/bin

ARG GIT_CRYPT_KEY
COPY ${GIT_CRYPT_KEY} /git-crypt-key.key
