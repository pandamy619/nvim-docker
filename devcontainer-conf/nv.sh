#!/usr/bin/env bash

set -euo pipefail

# --- Исполняемый файл для запуска Neovim в Docker с автосборкой ---

# --- Конфигурация ---
IMAGE_NAME="my-dev-nvim"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CALLER_CWD="$PWD"
BUILD_CONTEXT="$SCRIPT_DIR"
DOCKERFILE_PATH="$BUILD_CONTEXT/Dockerfile"

if ! command -v docker >/dev/null 2>&1; then
    echo "❌ Ошибка: Docker не найден в PATH."
    exit 1
fi

mkdir -p \
    "$BUILD_CONTEXT/local/share/nvim" \
    "$BUILD_CONTEXT/local/state/nvim" \
    "$BUILD_CONTEXT/cache/nvim"

# --- 1. ПРОВЕРКА И СБОРКА ОБРАЗА ---
echo "🔎 Проверяю наличие Docker-образа '$IMAGE_NAME'..."
IMAGE_ID="$(docker images -q "$IMAGE_NAME")"
if [ -z "$IMAGE_ID" ]; then
    echo "⚠️  Образ не найден. Требуется сборка."
    if [ ! -f "$DOCKERFILE_PATH" ]; then
        echo -e "\n❌ Ошибка: Dockerfile не найден в $DOCKERFILE_PATH"
        exit 1
    fi

    echo -e "\n🔧 Начинаю сборку образа..."
    docker build -t "$IMAGE_NAME" "$BUILD_CONTEXT"
    echo -e "\n✅ Образ '$IMAGE_NAME' успешно собран."
else
    echo "✅ Образ найден. Пропускаю сборку."
fi

# --- 2. ОПРЕДЕЛЕНИЕ ПУТИ К ПРОЕКТУ И ЗАПУСК ---
echo -e "\n🚀  **Запуск Neovim в Docker**\n"

if [ -n "${1:-}" ]; then
    TARGET_PATH="$1"
    echo "📂 Указана директория проекта: $TARGET_PATH"
else
    TARGET_PATH="$CALLER_CWD"
    echo "📂 Использую текущую директорию как проект: $TARGET_PATH"
fi

if ! PROJECT_PATH_ABSOLUTE="$(cd "$TARGET_PATH" 2>/dev/null && pwd -P)"; then
    echo -e "\n❌ Ошибка: Не удалось определить путь к директории '$TARGET_PATH'. Убедитесь, что она существует."
    exit 1
fi

echo -e "\nЗапускаю контейнер с изолированной конфигурацией..."
sleep 1

docker run -it --rm \
    -v "$PROJECT_PATH_ABSOLUTE:/home/dev/project" \
    -v "$BUILD_CONTEXT/config/nvim:/home/dev/.config/nvim" \
    -v "$BUILD_CONTEXT/local/share/nvim:/home/dev/.local/share/nvim" \
    -v "$BUILD_CONTEXT/local/state/nvim:/home/dev/.local/state/nvim" \
    -v "$BUILD_CONTEXT/cache/nvim:/home/dev/.cache/nvim" \
    "$IMAGE_NAME" nvim /home/dev/project

echo -e "\n✅  **Работа завершена. Контейнер остановлен.**\n"
