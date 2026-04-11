# nvim-docker

[Русский](README.ru.md)

Portable Neovim in Docker with an opinionated Lua config, built-in language servers, and a launcher that opens any project inside an isolated editor container.

## Who This Is For

- Developers who want a reproducible Neovim setup without installing local LSPs and toolchains.
- Teams onboarding people onto mixed-language repositories.
- People moving between machines who want the same editor behavior everywhere.

## What You Get

- Lua-based Neovim config
- `lazy.nvim` plugin management
- Treesitter highlighting and parsing
- `nvim-lspconfig` + `nvim-cmp`
- `neo-tree.nvim`, `gitsigns.nvim`, `neogit`
- Go support through `go.nvim`, `gopls`, and `goimports`
- Built-in language servers for Lua, Python, TypeScript, Go, Rust, and CSS

## Supported Hosts

- macOS with Docker Desktop
- Linux with Docker Engine
- `amd64` and `arm64` container builds

## Quick Start

```bash
git clone git@github.com:pandamy619/nvim-docker.git
cd nvim-docker
./devcontainer-conf/nv.sh
```

By default the launcher opens the current directory inside the container.

To open a different project:

```bash
./devcontainer-conf/nv.sh /path/to/project
```

To force an image rebuild:

```bash
./devcontainer-conf/nv.sh --rebuild /path/to/project
```

The launcher stores plugins, editor state, and caches in local ignored directories under `devcontainer-conf/local` and `devcontainer-conf/cache`.

To run the launcher against a prebuilt image instead of a local `my-dev-nvim` tag:

```bash
NVIM_DOCKER_IMAGE=ghcr.io/pandamy619/nvim-docker:v0.1.0 ./devcontainer-conf/nv.sh /path/to/project
```

## One-Command GHCR Run

Once a tagged release is published to GHCR, you can run the image directly without cloning the repo config:

```bash
docker run --rm -it \
  -v "$PWD:/home/dev/project" \
  -v nvim-docker-share:/home/dev/.local/share \
  -v nvim-docker-state:/home/dev/.local/state \
  -v nvim-docker-cache:/home/dev/.cache \
  ghcr.io/pandamy619/nvim-docker:v0.1.0 \
  nvim /home/dev/project
```

The image already contains the Neovim config. The first run still needs network access to fetch plugins.

## Included Keymaps

### General

| Key | Action |
| :--- | :--- |
| `Space` | Leader key |
| `<leader>w` | Save file |
| `<leader>q` | Quit Neovim |

### Navigation

| Key | Action |
| :--- | :--- |
| `Ctrl + h/j/k/l` | Move between windows |

### Plugins and Git

| Key | Action |
| :--- | :--- |
| `<leader>e` | Toggle `neo-tree` |
| `<leader>gg` | Open `Neogit` |
| `]c` | Next hunk |
| `[c` | Previous hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>gb` | Show line blame |

### Completion

| Key | Action |
| :--- | :--- |
| `Ctrl + j/k` | Navigate completion items |
| `Enter` | Confirm selected item |

### LSP

| Key | Action |
| :--- | :--- |
| `gd` | Go to definition |
| `K` | Hover documentation |
| `gi` | Go to implementation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions |

### Go

| Key | Action |
| :--- | :--- |
| `<leader>gt` | Run current function test |
| `<leader>gf` | Run file tests |
| `<leader>gr` | Run `go run` |

## What Is Supported

- Portable editor startup through [`devcontainer-conf/nv.sh`](devcontainer-conf/nv.sh)
- Reproducible Docker build through [`devcontainer-conf/Dockerfile`](devcontainer-conf/Dockerfile)
- Embedded fallback config inside the image for direct GHCR runs
- Local overrides through bind-mounted config when using the launcher

## What Is Not Included

- Project-specific compilers, SDKs, or databases beyond the bundled editor tooling
- Windows-native support
- A full IDE or devcontainer replacement
- Offline first-run plugin installation

## Known Issues

- The image is intentionally not tiny. Expect roughly a 1.5 GB class image after build.
- First startup downloads plugins and is noticeably slower.
- This setup is opinionated. If you want a blank Neovim base, this repo is the wrong starting point.

## Release Notes

- See [CHANGELOG.md](CHANGELOG.md) for tagged changes.
- CI builds and smoke-tests the Docker image on pushes and pull requests.
- Tagged releases publish `ghcr.io/pandamy619/nvim-docker`.
