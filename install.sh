#!/usr/bin/env sh
set -eu

REPO="${YUTO_PUBLIC_REPO:-hkyutong/yuto-code-public}"
VERSION="${YUTO_VERSION:-latest}"
INSTALL_DIR="${YUTO_INSTALL_DIR:-$HOME/.local/bin}"

usage() {
  cat <<'EOF'
Install Yuto Code from the public release repository.

Usage:
  install.sh [--version <version>] [--install-dir <dir>] [--repo <owner/name>]

Options:
  --version <version>      Install a specific version, for example 1.2.3 or v1.2.3
  --install-dir <dir>     Target install directory (default: ~/.local/bin)
  --repo <owner/name>     Override release repo (default: hkyutong/yuto-code-public)
  -h, --help              Show this help
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --version)
      shift
      [ "$#" -gt 0 ] || { echo "missing value for --version" >&2; exit 1; }
      VERSION="$1"
      ;;
    --install-dir)
      shift
      [ "$#" -gt 0 ] || { echo "missing value for --install-dir" >&2; exit 1; }
      INSTALL_DIR="$1"
      ;;
    --repo)
      shift
      [ "$#" -gt 0 ] || { echo "missing value for --repo" >&2; exit 1; }
      REPO="$1"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "unknown argument: $1" >&2
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
    curl -fsSL "$src" -o "$dest"
    return
  fi
  if command -v wget >/dev/null 2>&1; then
    wget -qO "$dest" "$src"
    return
  fi
  echo "curl or wget is required to install Yuto Code." >&2
  exit 1
}

verify_sha256() {
  checksum_file="$1"
  artifact_file="$2"
  expected="$(awk '{print $1}' "$checksum_file")"
  [ -n "$expected" ] || { echo "failed to read checksum" >&2; exit 1; }

  if command -v sha256sum >/dev/null 2>&1; then
    actual="$(sha256sum "$artifact_file" | awk '{print $1}')"
  elif command -v shasum >/dev/null 2>&1; then
    actual="$(shasum -a 256 "$artifact_file" | awk '{print $1}')"
  elif command -v openssl >/dev/null 2>&1; then
    actual="$(openssl dgst -sha256 "$artifact_file" | awk '{print $NF}')"
  else
    echo "sha256sum, shasum, or openssl is required to verify the download." >&2
    exit 1
  fi

  [ "$expected" = "$actual" ] || {
    echo "checksum mismatch for $(basename "$artifact_file")" >&2
    echo "expected: $expected" >&2
    echo "actual:   $actual" >&2
    exit 1
  }
}

uname_s="$(uname -s)"
case "$uname_s" in
  Darwin) OS_NAME="macos" ;;
  Linux) OS_NAME="linux" ;;
  *)
    echo "unsupported platform: $uname_s" >&2
    echo "Yuto Code currently supports macOS and Linux." >&2
    exit 1
    ;;
esac

uname_m="$(uname -m)"
case "$uname_m" in
  arm64|aarch64) ARCH_NAME="arm64" ;;
  x86_64|amd64) ARCH_NAME="x64" ;;
  *)
    echo "unsupported architecture: $uname_m" >&2
    exit 1
    ;;
esac

ASSET_NAME="yuto-${OS_NAME}-${ARCH_NAME}"
case "$ASSET_NAME" in
  yuto-macos-arm64|yuto-linux-x64) ;;
  *)
    echo "no published binary for ${OS_NAME}/${ARCH_NAME} yet." >&2
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

echo "Downloading Yuto Code ${DISPLAY_VERSION} for ${OS_NAME}/${ARCH_NAME}..."
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

echo "Installed Yuto Code to ${TARGET_PATH}"
"$TARGET_PATH" --version || true

case ":$PATH:" in
  *":$INSTALL_DIR:"*) ;;
  *)
    echo "Add ${INSTALL_DIR} to PATH to run 'yuto' directly."
    ;;
esac
