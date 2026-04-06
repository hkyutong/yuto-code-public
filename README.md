# Yuto Code

Yuto Code is a terminal coding assistant for macOS and Linux.

This repository is the public distribution channel for installers and release binaries. The source repository stays private.

## Install

Install the latest stable release:

```bash
curl -fsSL https://raw.githubusercontent.com/hkyutong/yuto-code-public/main/install.sh | bash
```

Install a specific version:

```bash
curl -fsSL https://raw.githubusercontent.com/hkyutong/yuto-code-public/main/install.sh | bash -s -- --version 0.1.4
```

Install to a custom directory:

```bash
curl -fsSL https://raw.githubusercontent.com/hkyutong/yuto-code-public/main/install.sh | bash -s -- --install-dir "$HOME/bin"
```

## Update

After Yuto Code is installed, upgrade in place with:

```bash
yuto update
```

Check whether a newer release is available:

```bash
yuto update --check
```

## Supported platforms

- macOS arm64
- Linux x64

## Release assets

Each public release includes:

- `yuto-macos-arm64`
- `yuto-linux-x64`
- matching `.sha256` files
- `manifest.json` at the repository root for machine-readable release metadata

## Notes

- This repository is for public binaries and installers only.
- Checksums are published for every binary.
- Releases are hosted directly on GitHub.
