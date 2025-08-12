FROM myoung34/github-runner:latest

# Install Rust system-wide with a minimal profile and keep the image lean.
# Notes:
# - Consider pinning the base image tag instead of `latest` for reproducibility.
# - Rust is installed to /opt to be available for all users (including `runner`).

USER root

ENV DEBIAN_FRONTEND=noninteractive \
    RUSTUP_HOME=/opt/rustup \
    CARGO_HOME=/opt/cargo \
    PATH=/opt/cargo/bin:$PATH

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        bash \
        build-essential; \
    rm -rf /var/lib/apt/lists/*; \
    \
    # Install rustup with minimal profile and stable toolchain
    curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs | sh -s -- -y --no-modify-path --profile minimal --default-toolchain stable; \
    # Commonly expected components for CI
    rustup component add rustfmt clippy; \
    # Ensure non-root user can use Rust
    chown -R runner:runner "$RUSTUP_HOME" "$CARGO_HOME"

# Drop back to the default non-root user provided by the base image
USER runner
