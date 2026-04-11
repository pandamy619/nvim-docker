#!/usr/bin/env bash

set -euo pipefail

IMAGE_PROFILE="${1:-full}"

case "$IMAGE_PROFILE" in
  base|go|web|full) ;;
  *)
    echo "Unsupported devcontainer smoke-test profile: $IMAGE_PROFILE" >&2
    exit 1
    ;;
esac

test -f /home/dev/.config/nvim/init.lua
test -d /home/dev/.local/share/nvim/lazy/lazy.nvim

nvim --version | head -n 1
nvim --clean --headless '+qall'
git --version
rg --version

case "$IMAGE_PROFILE" in
  go)
    go version
    gopls version | head -n 1
    command -v goimports
    ;;
  web)
    node --version
    pyright --version
    typescript-language-server --version
    command -v pyright-langserver
    command -v vscode-css-language-server
    ;;
  full)
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
    ;;
esac
