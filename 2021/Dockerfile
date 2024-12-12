# syntax=docker/dockerfile:1
FROM rustlang/rust:nightly

# Setup rust toolchain
RUN rustup component add rustfmt
RUN cargo install --locked cargo2junit
