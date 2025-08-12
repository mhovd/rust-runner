# rust-runner

GitHub Actions self-hosted runner image with Rust preinstalled.

## What's inside

- Base: `myoung34/github-runner`
- Rust via rustup (system-wide in `/opt`)
- Toolchain: `stable` with `rustfmt` and `clippy`
- Build tools: `build-essential`

## Notes

- For reproducibility, consider pinning the base image to a specific tag instead of `latest`.
- Rust is installed with the minimal profile to keep the image smaller.

## Build and test locally

```bash
# Build the image (replace tag as needed)
docker build -t rust-runner:latest .

# Verify Rust is available for the default user
docker run --rm rust-runner:latest bash -lc "rustc --version && cargo --version && rustup toolchain list"
```

## Using in CI

Use this image wherever you need a GitHub runner with Rust ready to go. Ensure the container has the required secrets and registration tokens as per the base image documentation.
