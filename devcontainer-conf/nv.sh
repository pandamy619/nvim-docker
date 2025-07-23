#!/bin/bash

# --- Исполняемый файл для запуска Neovim в Docker с автосборкой ---

# --- Конфигурация ---
IMAGE_NAME="my-dev-nvim"
# Директория, где гарантированно лежит наш Dockerfile
BUILD_CONTEXT="$PWD"
DOCKERFILE_PATH="$BUILD_CONTEXT/Dockerfile"

# --- 1. ПРОВЕРКА И СБОРКА ОБРАЗА (без изменений) ---
echo "🔎 Проверяю наличие Docker-образа '$IMAGE_NAME'..."
IMAGE_ID=$(docker images -q "$IMAGE_NAME")
if [ -z "$IMAGE_ID" ]; then
    echo "⚠️  Образ не найден. Требуется сборка."
    if [ ! -f "$DOCKERFILE_PATH" ]; then
        echo -e "\n❌ Ошибка: Dockerfile не найден в $DOCKERFILE_PATH"
        exit 1
    fi
    echo -e "\n🔧 Начинаю сборку образа..."
    docker build -t "$IMAGE_NAME" "$BUILD_CONTEXT"
    if [ $? -ne 0 ]; then
        echo -e "\n❌ Ошибка: Сборка Docker-образа не удалась."
        exit 1
    else
        echo -e "\n✅ Образ '$IMAGE_NAME' успешно собран."
    fi
else
    echo "✅ Образ найден. Пропускаю сборку."
fi

# --- 2. ОПРЕДЕЛЕНИЕ ПУТИ К ПРОЕКТУ И ЗАПУСК ---
# --------------------------------------------------
echo -e "\n🚀  **Запуск Neovim в Docker**\n"

# ===== ГЛАВНОЕ ИЗМЕНЕНИЕ ЗДЕСЬ =====
# Если скрипту передан аргумент (путь к проекту), используем его.
if [ -n "$1" ]; then
    TARGET_PATH="$1"
    echo "📂 Указана директория проекта: $TARGET_PATH"
else
    # Иначе, используем текущую директорию по умолчанию.
    TARGET_PATH="$PWD"
    echo "📂 Использую текущую директорию как проект: $TARGET_PATH"
fi

# Преобразуем путь в абсолютный, чтобы Docker его точно понял.
# Это также является проверкой, что директория существует.
PROJECT_PATH_ABSOLUTE=$(realpath "$TARGET_PATH" 2>/dev/null)

if [ -z "$PROJECT_PATH_ABSOLUTE" ]; then
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