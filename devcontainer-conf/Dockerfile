# syntax=docker/dockerfile:1

FROM ubuntu:22.04 AS nvim-builder

ENV DEBIAN_FRONTEND=noninteractive
ARG NVIM_REF=7ac5a26d5633a41d7e291141488ca635242973a5

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    gettext \
    git \
    ninja-build \
    unzip && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --filter=blob:none https://github.com/neovim/neovim.git /tmp/neovim && \
    git -C /tmp/neovim checkout "${NVIM_REF}" && \
    make -C /tmp/neovim CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/opt/nvim install


FROM golang:1.25 AS go-tools-builder
ARG GOPLS_VERSION=v0.21.1
ARG GOIMPORTS_VERSION=v0.43.0

RUN go install golang.org/x/tools/gopls@"${GOPLS_VERSION}" && \
    go install golang.org/x/tools/cmd/goimports@"${GOIMPORTS_VERSION}"


FROM ubuntu:22.04 AS node-tools-builder

ENV DEBIAN_FRONTEND=noninteractive
ARG NODE_VERSION=20.20.2-1nodesource1

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_20.x -o /tmp/nodesource_setup.sh && \
    bash /tmp/nodesource_setup.sh && \
    apt-get install -y --no-install-recommends nodejs="${NODE_VERSION}" && \
    npm install -g \
      pyright@1.1.408 \
      typescript@6.0.2 \
      typescript-language-server@5.1.3 \
      vscode-langservers-extracted@4.10.0 && \
    npm cache clean --force && \
    rm -rf /var/lib/apt/lists/* /tmp/nodesource_setup.sh


FROM ubuntu:22.04 AS lsp-assets-builder

ENV DEBIAN_FRONTEND=noninteractive
ARG TARGETARCH
ARG LUA_LS_VERSION=3.18.0
ARG RUST_ANALYZER_VERSION=2026-04-06

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gzip \
    tar && \
    rm -rf /var/lib/apt/lists/*

RUN case "${TARGETARCH}" in \
        amd64) LUA_LS_ARCH="x64"; RUST_ANALYZER_ARCH="x86_64-unknown-linux-gnu" ;; \
        arm64) LUA_LS_ARCH="arm64"; RUST_ANALYZER_ARCH="aarch64-unknown-linux-gnu" ;; \
        *) echo "Unsupported TARGETARCH: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    curl -fsSL "https://github.com/LuaLS/lua-language-server/releases/download/${LUA_LS_VERSION}/lua-language-server-${LUA_LS_VERSION}-linux-${LUA_LS_ARCH}.tar.gz" -o /tmp/lua-language-server.tar.gz && \
    mkdir -p /opt/lua-language-server && \
    tar -C /opt/lua-language-server -xzf /tmp/lua-language-server.tar.gz && \
    rm /tmp/lua-language-server.tar.gz && \
    curl -fsSL "https://github.com/rust-lang/rust-analyzer/releases/download/${RUST_ANALYZER_VERSION}/rust-analyzer-${RUST_ANALYZER_ARCH}.gz" -o /tmp/rust-analyzer.gz && \
    gzip -d /tmp/rust-analyzer.gz && \
    install -m 0755 /tmp/rust-analyzer /opt/rust-analyzer && \
    rm /tmp/rust-analyzer


FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    git \
    python3 \
    python3-pip \
    ripgrep && \
    rm -rf /var/lib/apt/lists/*

COPY --from=nvim-builder /opt/nvim /opt/nvim
COPY --from=go-tools-builder /usr/local/go /usr/local/go
COPY --from=go-tools-builder /go/bin/gopls /usr/local/bin/gopls
COPY --from=go-tools-builder /go/bin/goimports /usr/local/bin/goimports
COPY --from=node-tools-builder /usr/bin/node /usr/local/bin/node
COPY --from=node-tools-builder /usr/lib/node_modules /usr/lib/node_modules
COPY --from=lsp-assets-builder /opt/lua-language-server /opt/lua-language-server
COPY --from=lsp-assets-builder /opt/rust-analyzer /usr/local/bin/rust-analyzer
COPY config/nvim /tmp/nvim-config

RUN ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim && \
    ln -sf /opt/lua-language-server/bin/lua-language-server /usr/local/bin/lua-language-server && \
    printf '%s\n' '#!/usr/bin/env sh' 'exec node /usr/lib/node_modules/pyright/index.js "$@"' > /usr/local/bin/pyright && \
    printf '%s\n' '#!/usr/bin/env sh' 'exec node /usr/lib/node_modules/pyright/langserver.index.js "$@"' > /usr/local/bin/pyright-langserver && \
    printf '%s\n' '#!/usr/bin/env sh' 'exec node /usr/lib/node_modules/typescript-language-server/lib/cli.mjs "$@"' > /usr/local/bin/typescript-language-server && \
    printf '%s\n' '#!/usr/bin/env sh' 'exec node /usr/lib/node_modules/typescript/bin/tsserver "$@"' > /usr/local/bin/tsserver && \
    printf '%s\n' '#!/usr/bin/env sh' 'exec node /usr/lib/node_modules/vscode-langservers-extracted/bin/vscode-css-language-server "$@"' > /usr/local/bin/vscode-css-language-server && \
    chmod +x \
      /usr/local/bin/pyright \
      /usr/local/bin/pyright-langserver \
      /usr/local/bin/typescript-language-server \
      /usr/local/bin/tsserver \
      /usr/local/bin/vscode-css-language-server

RUN pip3 install --no-cache-dir --upgrade pip pynvim && \
    pip3 install --no-cache-dir pyflakes black isort

RUN useradd -ms /bin/bash dev && \
    mkdir -p \
      /home/dev/.cache \
      /home/dev/.config \
      /home/dev/.local/share \
      /home/dev/.local/state \
      /home/dev/go && \
    cp -R /tmp/nvim-config /home/dev/.config/nvim && \
    rm -rf /tmp/nvim-config && \
    chown -R dev:dev /home/dev

USER dev
WORKDIR /home/dev

ENV XDG_CACHE_HOME=/home/dev/.cache
ENV XDG_DATA_HOME=/home/dev/.local/share
ENV XDG_STATE_HOME=/home/dev/.local/state
ENV GOPATH=/home/dev/go
ENV GOCACHE=/home/dev/.cache/go-build
ENV PATH="/usr/local/go/bin:/home/dev/go/bin:${PATH}"

CMD ["bash"]
