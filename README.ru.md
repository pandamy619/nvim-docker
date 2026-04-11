# nvim-docker

[English](README.md)

Портативный Neovim в Docker с opinionated Lua-конфигом, встроенными language server'ами и launcher-скриптом, который открывает любой проект в изолированном контейнере.

## Для Кого Это

- Для разработчиков, которые хотят воспроизводимый Neovim без локальной установки LSP и toolchain.
- Для команд, которым нужен простой onboarding в polyglot-репозитории.
- Для тех, кто переключается между машинами и хочет одинаковый редактор везде.

## Что Внутри

- Конфиг Neovim на Lua
- Менеджер плагинов `lazy.nvim`
- Подсветка и парсеры через Treesitter
- `nvim-lspconfig` + `nvim-cmp`
- `neo-tree.nvim`, `gitsigns.nvim`, `neogit`
- Go-поддержка через `go.nvim`, `gopls` и `goimports`
- Встроенные language server'ы для Lua, Python, TypeScript, Go, Rust и CSS

## Поддерживаемые Хосты

- macOS с Docker Desktop
- Linux с Docker Engine
- Контейнерные сборки для `amd64` и `arm64`

## Быстрый Старт

```bash
git clone git@github.com:pandamy619/nvim-docker.git
cd nvim-docker
./devcontainer-conf/nv.sh
```

По умолчанию launcher открывает в контейнере текущую директорию.

Чтобы открыть другой проект:

```bash
./devcontainer-conf/nv.sh /путь/к/проекту
```

Чтобы принудительно пересобрать образ:

```bash
./devcontainer-conf/nv.sh --rebuild /путь/к/проекту
```

Launcher хранит плагины, editor state и cache в локальных игнорируемых директориях `devcontainer-conf/local` и `devcontainer-conf/cache`.

Чтобы использовать launcher поверх уже опубликованного image, а не локального `my-dev-nvim`:

```bash
NVIM_DOCKER_IMAGE=ghcr.io/pandamy619/nvim-docker:v0.1.0 ./devcontainer-conf/nv.sh /путь/к/проекту
```

## Запуск Через GHCR Одной Командой

После публикации тега в GHCR образ можно запускать напрямую, без bind mount локального конфига:

```bash
docker run --rm -it \
  -v "$PWD:/home/dev/project" \
  -v nvim-docker-share:/home/dev/.local/share \
  -v nvim-docker-state:/home/dev/.local/state \
  -v nvim-docker-cache:/home/dev/.cache \
  ghcr.io/pandamy619/nvim-docker:v0.1.0 \
  nvim /home/dev/project
```

Конфиг Neovim уже встроен в image. На первом запуске всё равно нужен интернет для загрузки плагинов.

## Основные Горячие Клавиши

### Общие

| Клавиша | Действие |
| :--- | :--- |
| `Space` | Лидер-клавиша |
| `<leader>w` | Сохранить файл |
| `<leader>q` | Выйти из Neovim |

### Навигация

| Клавиша | Действие |
| :--- | :--- |
| `Ctrl + h/j/k/l` | Перемещение между окнами |

### Плагины и Git

| Клавиша | Действие |
| :--- | :--- |
| `<leader>e` | Переключить `neo-tree` |
| `<leader>gg` | Открыть `Neogit` |
| `]c` | Следующий hunk |
| `[c` | Предыдущий hunk |
| `<leader>hs` | Застейджить hunk |
| `<leader>hr` | Откатить hunk |
| `<leader>gb` | Показать blame строки |

### Автодополнение

| Клавиша | Действие |
| :--- | :--- |
| `Ctrl + j/k` | Навигация по completion |
| `Enter` | Подтвердить выбранный вариант |

### LSP

| Клавиша | Действие |
| :--- | :--- |
| `gd` | Перейти к определению |
| `K` | Показать документацию |
| `gi` | Перейти к реализации |
| `<leader>rn` | Переименовать символ |
| `<leader>ca` | Code actions |

### Go

| Клавиша | Действие |
| :--- | :--- |
| `<leader>gt` | Запустить тест текущей функции |
| `<leader>gf` | Запустить тесты файла |
| `<leader>gr` | Выполнить `go run` |

## Что Поддерживается

- Портативный запуск редактора через [`devcontainer-conf/nv.sh`](devcontainer-conf/nv.sh)
- Воспроизводимая Docker-сборка через [`devcontainer-conf/Dockerfile`](devcontainer-conf/Dockerfile)
- Встроенный fallback-конфиг внутри image для прямого запуска из GHCR
- Локальные override'ы через bind mount конфига при использовании launcher

## Чего Здесь Нет

- Проект-специфичных компиляторов, SDK и баз данных кроме встроенного editor tooling
- Нативной поддержки Windows
- Полноценной замены IDE или devcontainer
- Полностью offline первого запуска

## Известные Ограничения

- Образ специально не “микроскопический”. Ожидай размер порядка 1.5 GB.
- Первый запуск заметно медленнее из-за загрузки плагинов.
- Конфиг намеренно opinionated. Если нужен чистый Neovim baseline, этот репозиторий не лучший старт.

## Релизная Информация

- История релизов лежит в [CHANGELOG.md](CHANGELOG.md).
- CI собирает и smoke-test'ит Docker image на push и pull request.
- Тегированные релизы публикуют `ghcr.io/pandamy619/nvim-docker`.
