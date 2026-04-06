# Yuto Code

[简体中文](#简体中文) | [English](#english)

## 简体中文

Yuto Code 的公开安装器和发布二进制在这个仓库里。

源码仓库保持私密；这个仓库只负责公开安装和公开更新。

### 安装

安装最新版：

```bash
curl -fsSL https://raw.githubusercontent.com/hkyutong/yuto-code-public/main/install.sh | bash
```

安装指定版本：

```bash
curl -fsSL https://raw.githubusercontent.com/hkyutong/yuto-code-public/main/install.sh | bash -s -- --version <version>
```

安装到自定义目录：

```bash
curl -fsSL https://raw.githubusercontent.com/hkyutong/yuto-code-public/main/install.sh | bash -s -- --install-dir "$HOME/bin"
```

### 更新

更新到最新公开版本：

```bash
yuto update
```

只检查是否有新版本：

```bash
yuto update --check
```

安装指定公开版本：

```bash
yuto update <version>
```

### 验证

```bash
yuto --version
```

### 支持平台

- macOS arm64
- Linux x64

### 发布资产

每个公开版本都包含：

- `yuto-macos-arm64`
- `yuto-linux-x64`
- 对应的 `.sha256`
- 仓库根目录里的 `manifest.json`

## English

Public installers and release binaries for Yuto Code.

The source repository stays private. This repository is the public install and update channel.

### Install

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

### Update

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

### Verify

```bash
yuto --version
```

### Supported platforms

- macOS arm64
- Linux x64

### Release assets

Each public release includes:

- `yuto-macos-arm64`
- `yuto-linux-x64`
- matching `.sha256` files
- `manifest.json` at the repository root for machine-readable release metadata
