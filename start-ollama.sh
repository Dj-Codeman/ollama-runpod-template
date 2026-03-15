#!/bin/sh
set -eu

mkdir -p "${OLLAMA_MODELS}"

echo "[ollama] starting server"
exec ollama serve