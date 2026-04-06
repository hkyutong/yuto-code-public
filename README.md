# Yuto Code Public Downloads

This repository hosts the public installers and release binaries for Yuto Code.

The source repository stays private. Public users should install from here.

## Quick start

Install the latest stable build on macOS or Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/hkyutong/yuto-code-public/main/install.sh | bash
```

Install a specific version:

```bash
curl -fsSL https://raw.githubusercontent.com/hkyutong/yuto-code-public/main/install.sh | bash -s -- --version 0.1.3
```

Install to a custom directory:

```bash
curl -fsSL https://raw.githubusercontent.com/hkyutong/yuto-code-public/main/install.sh | bash -s -- --install-dir "$HOME/bin"
```

## Supported platforms

- macOS arm64
- Linux x64

## Release assets

Every public release includes:

- `yuto-macos-arm64`
- `yuto-linux-x64`
- matching `.sha256` files
- `manifest.json` at the repository root for machine-readable release metadata

## Notes

- This repository is for distribution only.
- Checksums are published for every binary.
- If you need source access, use the private maintainer repository.
