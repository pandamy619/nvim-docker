1. Предварительно установить docker на OC

2. Сборка образа

    docker build -t my-dev-nvim .

3. Запуск контейнера

    docker run -it \
        -v /path/to/your/project:/home/dev/project \
        -v ~/.config/nvim:/home/dev/.config/nvim \
        -v ~/.local/share/nvim:/home/dev/.local/share/nvim \
        -v ~/.cache/nvim:/home/dev/.cache/nvim \
        my-dev-nvim



help:

-v /path/to/your/project:/home/dev/project — подключает папку с вашим кодом. Замените /path/to/your/project на реальный путь.

-v ~/.config/nvim:/home/dev/.config/nvim — подключает ваши основные конфиги.

-v ~/.local/share/nvim:/home/dev/.local/share/nvim — подключает установленные плагины и данные.

-v ~/.cache/nvim:/home/dev/.cache/nvim — подключает кэш, чтобы не терять его при перезапуске.
