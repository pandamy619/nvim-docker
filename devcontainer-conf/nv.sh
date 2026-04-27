#!/usr/bin/env bash

set -euo pipefail

# --- Launcher for Neovim in Docker with auto-build ---

# --- Configuration ---
IMAGE_TARGET="${NVIM_DOCKER_TARGET:-full}"
DEFAULT_IMAGE_NAME="my-dev-nvim"
CUSTOM_IMAGE=0

case "$IMAGE_TARGET" in
  base|go|web|full) ;;
  *)
    echo "❌ Error: unsupported target '$IMAGE_TARGET'. Use one of: base, go, web, full."
    exit 1
    ;;
esac

if [ "$IMAGE_TARGET" != "full" ]; then
  DEFAULT_IMAGE_NAME="${DEFAULT_IMAGE_NAME}-${IMAGE_TARGET}"
fi

if [ -n "${NVIM_DOCKER_IMAGE:-}" ]; then
  IMAGE_NAME="$NVIM_DOCKER_IMAGE"
  CUSTOM_IMAGE=1
else
  IMAGE_NAME="$DEFAULT_IMAGE_NAME"
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CALLER_CWD="$PWD"
BUILD_CONTEXT="$SCRIPT_DIR"
DOCKERFILE_PATH="$BUILD_CONTEXT/Dockerfile"
REBUILD_IMAGE=0

if [ "${1:-}" = "--rebuild" ]; then
  REBUILD_IMAGE=1
  shift
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "❌ Error: Docker not found in PATH."
  exit 1
fi

mkdir -p \
  "$BUILD_CONTEXT/local/share" \
  "$BUILD_CONTEXT/local/state" \
  "$BUILD_CONTEXT/cache"

# --- 1. CHECK AND BUILD IMAGE ---
echo "🔎 Checking for Docker image '$IMAGE_NAME'..."

IMAGE_ID="$(docker images -q "$IMAGE_NAME")"

if [ "$CUSTOM_IMAGE" -eq 1 ]; then
  if [ "$REBUILD_IMAGE" -eq 1 ]; then
    echo "❌ Error: --rebuild cannot be used together with NVIM_DOCKER_IMAGE."
    exit 1
  fi
  if [ -z "$IMAGE_ID" ]; then
    echo "📦 Image not found locally. Pulling '$IMAGE_NAME'..."
    docker pull "$IMAGE_NAME"
    echo -e "\n✅ Image '$IMAGE_NAME' pulled successfully."
  else
    echo "✅ Custom image found locally. Skipping pull."
  fi
else
  echo "🧱 Using local target: $IMAGE_TARGET"
  if [ "$REBUILD_IMAGE" -eq 1 ]; then
    echo "♻️  Forcing image rebuild."
    docker build --pull --target "$IMAGE_TARGET" -t "$IMAGE_NAME" "$BUILD_CONTEXT"
    echo -e "\n✅ Image '$IMAGE_NAME' rebuilt successfully."
  elif [ -z "$IMAGE_ID" ]; then
    echo "⚠️  Image not found. Build required."
    if [ ! -f "$DOCKERFILE_PATH" ]; then
      echo -e "\n❌ Error: Dockerfile not found at $DOCKERFILE_PATH"
      exit 1
    fi
    echo -e "\n🔧 Starting image build..."
    docker build --target "$IMAGE_TARGET" -t "$IMAGE_NAME" "$BUILD_CONTEXT"
    echo -e "\n✅ Image '$IMAGE_NAME' built successfully."
  else
    echo "✅ Image found. Skipping build."
  fi
fi

# --- 2. RESOLVE PROJECT PATH AND RUN ---
echo -e "\n🚀 **Starting Neovim in Docker**\n"

if [ -n "${1:-}" ]; then
  TARGET_PATH="$1"
  echo "📂 Project directory specified: $(basename "$TARGET_PATH")"
else
  TARGET_PATH="$CALLER_CWD"
  echo "📂 Using current directory as project: $(basename "$TARGET_PATH")"
fi

if ! PROJECT_PATH_ABSOLUTE="$(cd "$TARGET_PATH" 2>/dev/null && pwd -P)"; then
  echo -e "\n❌ Error: Could not resolve directory '$TARGET_PATH'. Make sure it exists."
  exit 1
fi

echo -e "\nStarting container with isolated configuration..."
sleep 1

docker run -it --rm \
  -v "$PROJECT_PATH_ABSOLUTE:/home/dev/project" \
  -v "$BUILD_CONTEXT/config/nvim:/home/dev/.config/nvim" \
  -v "$BUILD_CONTEXT/local/share:/home/dev/.local/share" \
  -v "$BUILD_CONTEXT/local/state:/home/dev/.local/state" \
  -v "$BUILD_CONTEXT/cache:/home/dev/.cache" \
  "$IMAGE_NAME" nvim /home/dev/project

echo -e "\n✅ **Done. Container stopped.**\n"