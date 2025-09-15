#!/usr/bin/env bash
set -euo pipefail

VER="${TWEEGO_VERSION:-2.1.1}"

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"   # linux or darwin
ARCH="$(uname -m)"                               # x86_64, arm64, aarch64

case "$OS" in
  linux)  PLATFORM="linux" ;;
  darwin) PLATFORM="macos" ;;
  *) echo "Unsupported OS: $OS"; exit 1 ;;
esac

case "$ARCH" in
  x86_64|amd64) CPU="x64" ;;
  arm64|aarch64) CPU="arm64" ;;
  *) echo "Unsupported arch: $ARCH"; exit 1 ;;
esac

ASSET="tweego-${VER}-${PLATFORM}-${CPU}.zip"
URL="https://github.com/tmedwards/tweego/releases/download/v${VER}/${ASSET}"

mkdir -p .bin
echo "Downloading Tweego ${VER} from:"
echo "  ${URL}"

# -f fail on HTTP errors, -S show errors, -L follow redirects
curl -fSL "$URL" -o .bin/tweego.zip

echo "Unzipping..."
cd .bin
unzip -q -o tweego.zip
chmod +x tweego
echo "Tweego installed at $(pwd)/tweego"
