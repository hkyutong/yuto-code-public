# Yuto Code

Public installers and release binaries for Yuto Code.

The source repository stays private. This repository is the public install and update channel.

## Install

Install the latest stable release:

```bash
curl -fsSL https://raw.githubusercontent.com/hkyutong/yuto-code-public/main/install.sh | bash
```

Install a specific version:

```bash
curl -fsSL https://raw.githubusercontent.com/hkyutong/yuto-code-public/main/install.sh | bash -s -- --version <version>
```

Install to a custom directory:

```bash
curl -fsSL https://raw.githubusercontent.com/hkyutong/yuto-code-public/main/install.sh | bash -s -- --install-dir "$HOME/bin"
```

## Update

Install the latest public release in place:

```bash
yuto update
```

Check whether a newer release is available:

```bash
yuto update --check
```

Install a specific public release:

```bash
yuto update <version>
```

## Verify

```bash
yuto --version
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
