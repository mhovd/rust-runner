# syntax=docker/dockerfile:1

FROM myoung34/github-runner:latest

# Install Rust system-wide with a minimal profile and keep the image lean.
# The base image tag is intentionally `latest`: the publish workflow rebuilds
# this image automatically whenever the upstream base digest changes.
# Rust lives in /opt so it is available to every user (including `runner`).

USER root

ENV DEBIAN_FRONTEND=noninteractive \
    RUSTUP_HOME=/opt/rustup \
    CARGO_HOME=/opt/cargo \
    CARGO_TERM_COLOR=always \
    PATH=/opt/cargo/bin:$PATH

# A single layer for system packages + rustup keeps the image small.
# System packages commonly required to build Rust crates in CI:
# - build-essential : C/C++ toolchain for crates with native build scripts
# - pkg-config       : used by many `*-sys` crates to locate system libraries
# - libssl-dev       : required by openssl-sys (reqwest, native-tls, etc.)
# - git              : fetching crates and git dependencies
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        bash \
        git \
        build-essential \
        pkg-config \
        libssl-dev; \
    rm -rf /var/lib/apt/lists/*; \
    \
    # Install rustup (minimal profile) together with rustfmt and clippy in a
    # single invocation to avoid an extra network round-trip and image layer.
    curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs | \
        sh -s -- -y --no-modify-path --profile minimal --default-toolchain stable \
            --component rustfmt --component clippy; \
    \
    # Allow the non-root `runner` user to use/update the toolchain and to write
    # to the cargo registry cache during builds.
    chown -R runner:runner "$RUSTUP_HOME" "$CARGO_HOME"

# OCI metadata for provenance and discoverability.
LABEL org.opencontainers.image.title="rust-runner" \
      org.opencontainers.image.description="GitHub Actions self-hosted runner with Rust (stable, rustfmt, clippy) preinstalled" \
      org.opencontainers.image.source="https://github.com/mhovd/rust-runner" \
      org.opencontainers.image.base.name="docker.io/myoung34/github-runner:latest"

# Drop back to the default non-root user provided by the base image.
USER runner
