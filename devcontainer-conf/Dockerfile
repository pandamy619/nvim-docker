# syntax=docker/dockerfile:1

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    gettext \
    git \
    ninja-build \
    python3 \
    python3-pip \
    ripgrep \
    unzip && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_20.x -o /tmp/nodesource_setup.sh && \
    bash /tmp/nodesource_setup.sh && \
    apt-get install -y --no-install-recommends nodejs && \
    rm -rf /var/lib/apt/lists/* /tmp/nodesource_setup.sh

ARG TARGETARCH

RUN git clone https://github.com/neovim/neovim.git /tmp/neovim && \
    cd /tmp/neovim && \
    git checkout stable && \
    make CMAKE_BUILD_TYPE=Release && \
    make install

RUN pip3 install --upgrade pip pynvim && \
    pip3 install pyflakes black isort && \
    npm install -g pyright typescript typescript-language-server

RUN case "${TARGETARCH}" in \
        amd64) GO_ARCH="amd64" ;; \
        arm64) GO_ARCH="arm64" ;; \
        *) echo "Unsupported TARGETARCH: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    curl -fsSL "https://go.dev/dl/go1.23.4.linux-${GO_ARCH}.tar.gz" -o /tmp/go.tgz && \
    rm -rf /usr/local/go && \
    tar -C /usr/local -xzf /tmp/go.tgz && \
    rm /tmp/go.tgz

RUN useradd -ms /bin/bash dev
USER dev
WORKDIR /home/dev

ENV GOPATH=/home/dev/go
ENV PATH="/usr/local/go/bin:/home/dev/go/bin:/home/dev/.local/share/nvim/mason/bin:${PATH}"

RUN mkdir -p "$GOPATH" && \
    go install golang.org/x/tools/gopls@latest && \
    go install golang.org/x/tools/cmd/goimports@latest

CMD ["bash"]
