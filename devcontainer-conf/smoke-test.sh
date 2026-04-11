#!/usr/bin/env bash

set -euo pipefail

IMAGE_NAME="${1:-my-dev-nvim}"

docker run --rm "$IMAGE_NAME" sh -lc '
  test -f /home/dev/.config/nvim/init.lua
  nvim --clean --headless "+qall"
  go version
  gopls version | head -n 1
  pyright --version
  typescript-language-server --version
  lua-language-server --version
  rust-analyzer --version
  command -v goimports
  command -v pyright-langserver
  command -v vscode-css-language-server
'
