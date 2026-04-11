# nvim-docker

[English](README.md)

Портативный Neovim в Docker с opinionated Lua-конфигом, profile-based образами и launcher-скриптом, который открывает любой проект в изолированном контейнере.

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
- Профили образов: `base`, `go`, `web`, `full`

## Профили Образов

| Профиль | Что входит | Local target | GHCR tag |
| :--- | :--- | :--- | :--- |
| `base` | `nvim`, `git`, `ripgrep`, встроенный конфиг | `base` | `latest-base` |
| `go` | `base` + Go toolchain, `gopls`, `goimports` | `go` | `latest-go` |
| `web` | `base` + Node runtime, `pyright`, TypeScript/CSS language server'ы | `web` | `latest-web` |
| `full` | `go` + `web` + LuaLS + `rust-analyzer` + Python CLI tools | `full` | `latest` |

## Поддерживаемые Хосты

- macOS с Docker Desktop
- Linux с Docker Engine
- Контейнерные сборки для `amd64` и `arm64`

## Dev Containers и Codespaces

В репозитории также есть четыре devcontainer-конфига:

- `.devcontainer/base/devcontainer.json`
- `.devcontainer/go/devcontainer.json`
- `.devcontainer/web/devcontainer.json`
- `.devcontainer/full/devcontainer.json`

В VS Code можно выбрать `Dev Containers: Reopen in Container` и нужный профиль.

В GitHub Codespaces эти же профили доступны при создании codespace.

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

Чтобы собрать и запустить конкретный локальный профиль:

```bash
NVIM_DOCKER_TARGET=go ./devcontainer-conf/nv.sh /путь/к/проекту
```

Launcher хранит плагины, editor state и cache в локальных игнорируемых директориях `devcontainer-conf/local` и `devcontainer-conf/cache`.

Чтобы использовать launcher поверх уже опубликованного GHCR image, а не локальной сборки:

```bash
NVIM_DOCKER_IMAGE=ghcr.io/pandamy619/nvim-docker:latest-go ./devcontainer-conf/nv.sh /путь/к/проекту
```

## Запуск Через GHCR Одной Командой

После публикации тега в GHCR образ можно запускать напрямую, без bind mount локального конфига:

```bash
docker run --rm -it \
  -v "$PWD:/home/dev/project" \
  -v nvim-docker-share:/home/dev/.local/share \
  -v nvim-docker-state:/home/dev/.local/state \
  -v nvim-docker-cache:/home/dev/.cache \
  ghcr.io/pandamy619/nvim-docker:latest \
  nvim /home/dev/project
```

Конфиг Neovim уже встроен в image. На первом запуске всё равно нужен интернет для загрузки плагинов.

Доступные GHCR теги:

- `ghcr.io/pandamy619/nvim-docker:latest`
- `ghcr.io/pandamy619/nvim-docker:latest-base`
- `ghcr.io/pandamy619/nvim-docker:latest-go`
- `ghcr.io/pandamy619/nvim-docker:latest-web`

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
- Несколько `.devcontainer`-профилей для VS Code Dev Containers и GitHub Codespaces
- Pin на официальный Neovim release binary внутри образа
- Встроенный fallback-конфиг внутри image для прямого запуска из GHCR
- Локальные override'ы через bind mount конфига при использовании launcher

## Чего Здесь Нет

- Проект-специфичных компиляторов, SDK и баз данных кроме встроенного editor tooling
- Нативной поддержки Windows
- Полноценного project dev environment со встроенными сервисами приложения
- Полностью offline первого запуска

## Релизная Информация

- История релизов лежит в [CHANGELOG.md](CHANGELOG.md).
- CI собирает и smoke-test'ит все профили образов через Docker Buildx.
- Тегированные релизы публикуют multi-arch образы `amd64` и `arm64` в `ghcr.io/pandamy619/nvim-docker`.
- Тегированные релизы публикуют `ghcr.io/pandamy619/nvim-docker` с тегами `latest`, `latest-base`, `latest-go` и `latest-web`.
