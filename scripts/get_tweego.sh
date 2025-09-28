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

# Note: As of v2.1.1, Tweego doesn't have native ARM64 builds yet
# Apple Silicon Macs can run the x64 version through Rosetta 2
case "$ARCH" in
  x86_64|amd64|arm64|aarch64) CPU="x64" ;;  # Use x64 for both Intel and Apple Silicon
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

# Check if we're on Apple Silicon and suggest Rosetta 2 if needed
if [[ "$OS" == "darwin" && ("$ARCH" == "arm64" || "$ARCH" == "aarch64") ]]; then
  echo "Tweego installed at $(pwd)/tweego"
  echo "Note: You're on Apple Silicon. If you get 'Bad CPU type' errors,"
  echo "install Rosetta 2 with: softwareupdate --install-rosetta"
else
  echo "Tweego installed at $(pwd)/tweego"
fi
