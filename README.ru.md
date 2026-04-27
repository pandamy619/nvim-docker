# nvim-docker

[![CI](https://github.com/pandamy619/nvim-docker/actions/workflows/ci.yml/badge.svg?branch=main&event=push)](https://github.com/pandamy619/nvim-docker/actions/workflows/ci.yml)
[![Build](https://github.com/pandamy619/nvim-docker/actions/workflows/release-check.yml/badge.svg?branch=main&event=push)](https://github.com/pandamy619/nvim-docker/actions/workflows/release-check.yml)
[![GHCR](https://img.shields.io/badge/GHCR-ghcr.io%2Fpandamy619%2Fnvim--docker-blue?logo=github)](https://github.com/pandamy619/nvim-docker/pkgs/container/nvim-docker)

[English](README.md)

Портативный Neovim в Docker с opinionated Lua-конфигом, profile-based образами и launcher-скриптом, который открывает любой проект в изолированном контейнере.

![demo](docs/media/demo.gif)

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

## Сравнение Профилей

Числа ниже приблизительные и выведены из текущего состава Dockerfile. Фактические значения зависят от машины, сети и того, прогреты ли plugin cache.

| Профиль | Для чего лучше всего | Примерный размер образа | Примерное первое открытие | Комментарий |
| :--- | :--- | :--- | :--- | :--- |
| `base` | минимальный editing и обычные репозитории | `0.4-0.6 GB` | `20-40 sec` | самый маленький образ, без language-specific runtime |
| `go` | Go-репозитории | `0.7-0.9 GB` | `30-60 sec` | включает `go`, `gopls` и `goimports` |
| `web` | TypeScript, CSS и Python-adjacent репозитории | `0.6-0.8 GB` | `30-60 sec` | включает `node`, `pyright` и TypeScript/CSS language server'ы |
| `full` | mixed-language репозитории и дефолтный Codespaces сценарий | `1.3-1.5 GB` | `45-90 sec` | самый тяжёлый образ, но и самый полный |

## Поддерживаемые Хосты

- macOS с Docker Desktop
- Linux с Docker Engine
- Контейнерные сборки для `amd64` и `arm64`

## Старт За 30 Секунд

- Локальный launcher: `./devcontainer-conf/nv.sh`
- VS Code / Codespaces: дефолтный [`.devcontainer/devcontainer.json`](.devcontainer/devcontainer.json) открывает профиль `full`
- Альтернативные профили: `.devcontainer/base`, `.devcontainer/go`, `.devcontainer/web`, `.devcontainer/full`
- Готовый образ: `NVIM_DOCKER_IMAGE=ghcr.io/pandamy619/nvim-docker:latest ./devcontainer-conf/nv.sh`

## Dev Containers и Codespaces

В репозитории есть один дефолтный devcontainer и четыре профильных альтернативы:

- `.devcontainer/devcontainer.json` по умолчанию ведёт на `full`
- `.devcontainer/base/devcontainer.json`
- `.devcontainer/go/devcontainer.json`
- `.devcontainer/web/devcontainer.json`
- `.devcontainer/full/devcontainer.json`

В VS Code можно выбрать `Dev Containers: Reopen in Container` и нужный профиль.

В GitHub Codespaces эти же профили доступны при создании codespace.

У каждого профиля есть небольшой `onCreateCommand`, который один раз делает `Lazy sync`. Это делает конфиг совместимым с Codespaces prebuild.
У каждого профиля также включён `overrideCommand: true`, чтобы Dev Containers не завершал контейнер сразу после image `CMD`.

Примечание про prebuild:
- GitHub Codespaces prebuild включается в настройках репозитория, а не через tracked файл в git.
- Репозиторий уже подготовлен к prebuild, а дефолтная рекомендация это `.devcontainer/devcontainer.json`.
- Точные ручные шаги вынесены в [docs/CODESPACES_PREBUILD.md](docs/CODESPACES_PREBUILD.md).

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
- CI валидирует репозиторий и прогоняет реальные devcontainer smoke-test'ы для дефолтного профиля и всех профильных альтернатив.
- Тегированные релизы публикуют multi-arch образы `amd64` и `arm64` в `ghcr.io/pandamy619/nvim-docker`.
- Тегированные релизы публикуют `ghcr.io/pandamy619/nvim-docker` с тегами `latest`, `latest-base`, `latest-go` и `latest-web`.
