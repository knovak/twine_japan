#!/usr/bin/env bash
set -euo pipefail
VER="${TWEEGO_VERSION:-2.1.1}"
OS="$(uname | tr '[:upper:]' '[:lower:]' )"
ARCH="amd64"
URL="https://github.com/tweego/tweego/releases/download/v${VER}/tweego_${VER}_${OS}_${ARCH}.zip"
mkdir -p .bin
echo "Downloading Tweego ${VER} for ${OS}/${ARCH}..."
curl -L "$URL" -o .bin/tweego.zip
cd .bin
unzip -o tweego.zip
chmod +x tweego
echo "Tweego available at $(pwd)/tweego"
