# rust-runner

GitHub Actions self-hosted runner image with Rust preinstalled.

## What's inside

- Base: `myoung34/github-runner`
- Rust via rustup (system-wide in `/opt`)
- Toolchain: `stable` with `rustfmt` and `clippy`
- Build tools: `build-essential`, `pkg-config`, `libssl-dev`, `git`
- Published for `linux/amd64` and `linux/arm64`

## Build and test locally

```bash
# Build the image (replace tag as needed)
docker build -t rust-runner:latest .

# Verify Rust is available for the default user
docker run --rm rust-runner:latest bash -lc "rustc --version && cargo --version && rustup toolchain list"
```

## Pull the published image

```bash
docker pull ghcr.io/mhovd/rust-runner:latest
```

Images are built nightly and automatically rebuilt whenever the upstream base
image changes. Multi-arch images are built natively (no QEMU emulation) and the
published manifests are signed with [cosign](https://github.com/sigstore/cosign).

## Using in CI

Use this image wherever you need a GitHub runner with Rust ready to go. Ensure the container has the required secrets and registration tokens as per the base image documentation, see https://github.com/myoung34/docker-github-actions-runner .