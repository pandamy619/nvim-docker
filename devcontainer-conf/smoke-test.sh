#!/usr/bin/env bash

set -euo pipefail

IMAGE_NAME="${1:-my-dev-nvim}"
IMAGE_PROFILE="${2:-full}"

case "$IMAGE_PROFILE" in
  base|go|web|full) ;;
  *)
    echo "Unsupported smoke-test profile: $IMAGE_PROFILE" >&2
    exit 1
    ;;
esac

docker run --rm "$IMAGE_NAME" sh -lc "
  test -f /home/dev/.config/nvim/init.lua
  nvim --version | head -n 1
  nvim --clean --headless '+qall'
  git --version
  rg --version
"

case "$IMAGE_PROFILE" in
  go)
    docker run --rm "$IMAGE_NAME" sh -lc '
      go version
      gopls version | head -n 1
      command -v goimports
    '
    ;;
  web)
    docker run --rm "$IMAGE_NAME" sh -lc '
      node --version
      pyright --version
      typescript-language-server --version
      command -v pyright-langserver
      command -v vscode-css-language-server
    '
    ;;
  full)
    docker run --rm "$IMAGE_NAME" sh -lc '
      go version
      gopls version | head -n 1
      pyright --version
      typescript-language-server --version
      lua-language-server --version
      rust-analyzer --version
      command -v goimports
      command -v pyright-langserver
      command -v vscode-css-language-server
      command -v black
      command -v isort
      command -v pyflakes
    '
    ;;
esac
