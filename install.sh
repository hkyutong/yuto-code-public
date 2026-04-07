#!/usr/bin/env sh
set -eu

REPO="${YUTO_PUBLIC_REPO:-hkyutong/yuto-code-public}"
VERSION="${YUTO_VERSION:-latest}"
INSTALL_DIR="${YUTO_INSTALL_DIR:-$HOME/.local/bin}"

usage() {
  cat <<'EOF'
从公开发布仓库安装 Yuto Code。

用法：
  install.sh [--version <version>] [--install-dir <dir>] [--repo <owner/name>]

参数：
  --version <version>     安装指定版本，例如 1.2.3 或 v1.2.3
  --install-dir <dir>     安装目录（默认：~/.local/bin）
  --repo <owner/name>     覆盖公开发布仓库（默认：hkyutong/yuto-code-public）
  -h, --help              显示帮助
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --version)
      shift
      [ "$#" -gt 0 ] || { echo "--version 缺少参数值" >&2; exit 1; }
      VERSION="$1"
      ;;
    --install-dir)
      shift
      [ "$#" -gt 0 ] || { echo "--install-dir 缺少参数值" >&2; exit 1; }
      INSTALL_DIR="$1"
      ;;
    --repo)
      shift
      [ "$#" -gt 0 ] || { echo "--repo 缺少参数值" >&2; exit 1; }
      REPO="$1"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "未知参数：$1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

download() {
  src="$1"
  dest="$2"
  if command -v curl >/dev/null 2>&1; then
    curl --retry 4 --retry-delay 2 --retry-all-errors --connect-timeout 20 --max-time 900 -fsSL "$src" -o "$dest"
    return
  fi
  if command -v wget >/dev/null 2>&1; then
    wget --tries=4 --waitretry=2 --timeout=30 -qO "$dest" "$src"
    return
  fi
  echo "安装 Yuto Code 需要 curl 或 wget。" >&2
  exit 1
}

verify_sha256() {
  checksum_file="$1"
  artifact_file="$2"
  expected="$(awk '{print $1}' "$checksum_file")"
  [ -n "$expected" ] || { echo "读取校验和失败" >&2; exit 1; }

  if command -v sha256sum >/dev/null 2>&1; then
    actual="$(sha256sum "$artifact_file" | awk '{print $1}')"
  elif command -v shasum >/dev/null 2>&1; then
    actual="$(shasum -a 256 "$artifact_file" | awk '{print $1}')"
  elif command -v openssl >/dev/null 2>&1; then
    actual="$(openssl dgst -sha256 "$artifact_file" | awk '{print $NF}')"
  else
    echo "校验下载文件需要 sha256sum、shasum 或 openssl。" >&2
    exit 1
  fi

  [ "$expected" = "$actual" ] || {
    echo "$(basename "$artifact_file") 的校验和不匹配" >&2
    echo "期望值：$expected" >&2
    echo "实际值：$actual" >&2
    exit 1
  }
}

uname_s="$(uname -s)"
case "$uname_s" in
  Darwin) OS_NAME="macos" ;;
  Linux) OS_NAME="linux" ;;
  *)
    echo "暂不支持当前平台：$uname_s" >&2
    echo "Yuto Code 当前仅支持 macOS 和 Linux。" >&2
    exit 1
    ;;
esac

uname_m="$(uname -m)"
case "$uname_m" in
  arm64|aarch64) ARCH_NAME="arm64" ;;
  x86_64|amd64) ARCH_NAME="x64" ;;
  *)
    echo "暂不支持当前架构：$uname_m" >&2
    exit 1
    ;;
esac

ASSET_NAME="yuto-${OS_NAME}-${ARCH_NAME}"
case "$ASSET_NAME" in
  yuto-macos-arm64|yuto-linux-x64) ;;
  *)
    echo "当前还没有 ${OS_NAME}/${ARCH_NAME} 的公开二进制。" >&2
    exit 1
    ;;
esac

if [ "$VERSION" = "latest" ]; then
  ASSET_URL="https://github.com/${REPO}/releases/latest/download/${ASSET_NAME}"
  CHECKSUM_URL="${ASSET_URL}.sha256"
  DISPLAY_VERSION="latest"
else
  case "$VERSION" in
    v*) TAG_NAME="$VERSION" ;;
    *) TAG_NAME="v$VERSION" ;;
  esac
  ASSET_URL="https://github.com/${REPO}/releases/download/${TAG_NAME}/${ASSET_NAME}"
  CHECKSUM_URL="${ASSET_URL}.sha256"
  DISPLAY_VERSION="$TAG_NAME"
fi

TMP_DIR="$(mktemp -d 2>/dev/null || mktemp -d -t yuto-install)"
trap 'rm -rf "$TMP_DIR"' EXIT INT TERM HUP

ARTIFACT_PATH="${TMP_DIR}/${ASSET_NAME}"
CHECKSUM_PATH="${TMP_DIR}/${ASSET_NAME}.sha256"

echo "正在下载 Yuto Code ${DISPLAY_VERSION}（${OS_NAME}/${ARCH_NAME}）..."
download "$ASSET_URL" "$ARTIFACT_PATH"
download "$CHECKSUM_URL" "$CHECKSUM_PATH"
verify_sha256 "$CHECKSUM_PATH" "$ARTIFACT_PATH"

mkdir -p "$INSTALL_DIR"
TARGET_PATH="${INSTALL_DIR}/yuto"
if command -v install >/dev/null 2>&1; then
  install -m 0755 "$ARTIFACT_PATH" "$TARGET_PATH"
else
  cp "$ARTIFACT_PATH" "$TARGET_PATH"
  chmod 0755 "$TARGET_PATH"
fi

echo "已安装到 ${TARGET_PATH}"
"$TARGET_PATH" --version || true

case ":$PATH:" in
  *":$INSTALL_DIR:"*) ;;
  *)
    echo "把 ${INSTALL_DIR} 加到 PATH 后，就可以直接运行 yuto。"
    ;;
esac
