# Используем свежий образ Ubuntu
FROM ubuntu:22.04

# Обновляем систему и ставим зависимости для сборки Neovim и плагинов
RUN apt update && apt install -y \
    ninja-build gettext cmake unzip curl git \
    build-essential python3 python3-pip nodejs npm \
    ripgrep

# Собираем и устанавливаем последнюю стабильную версию Neovim
RUN git clone https://github.com/neovim/neovim.git /tmp/neovim && \
    cd /tmp/neovim && \
    git checkout stable && \
    make CMAKE_BUILD_TYPE=Release && \
    make install

# Устанавливаем утилиты для Python и Node.js (LSP-серверы и т.д.)
RUN pip3 install --upgrade pip pynvim
RUN npm install -g pyright typescript typescript-language-server

# Создаём пользователя 'dev', чтобы не работать под root
RUN useradd -ms /bin/bash dev
USER dev
WORKDIR /home/dev

# Команда по умолчанию при запуске контейнера
CMD ["bash"]