# Yuto Code

## 安装

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

## 更新

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

## 验证

```bash
yuto --version
```

## 公开发布

```text
https://github.com/hkyutong/yuto-code-public/releases
```

## 支持平台

- macOS arm64
- Linux x64
