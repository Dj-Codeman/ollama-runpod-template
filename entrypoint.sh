#!/bin/sh
set -eu

mkdir -p "${OLLAMA_MODELS}"
mkdir -p "${TS_STATE_DIR}"

if [ -z "${TS_AUTHKEY:-}" ]; then
  echo "TS_AUTHKEY is required"
  exit 1
fi

if [ -z "${TS_HOSTNAME:-}" ]; then
  if [ -n "${SESSION_ID:-}" ]; then
    HEX_ID=$(printf '%s' "${SESSION_ID}" | cut -c 1-13 | od -An -tx1 | tr -d ' \r\n' | sed 's/0a$//')
    TS_HOSTNAME="ais-${HEX_ID}"
  else
    TS_HOSTNAME="runpod-ollama"
  fi
fi

echo "[start] hostname set to ${TS_HOSTNAME}"

echo "[start] starting tailscaled"
tailscaled \
  --tun=userspace-networking \
  --state="${TS_STATE_DIR}/tailscaled.state" \
  --socket=/tmp/tailscaled.sock &
TS_PID=$!

sleep 3

echo "[start] bringing tailscale up"
tailscale --socket=/tmp/tailscaled.sock up \
  --auth-key="${TS_AUTHKEY}" \
  --hostname="${TS_HOSTNAME}" \
  --accept-dns=false

echo "[start] starting ollama"
ollama serve &
OLLAMA_PID=$!

sleep 3

echo "[start] publishing ollama to tailnet with tailscale serve"
tailscale --socket=/tmp/tailscaled.sock serve --bg "${TS_SERVE_PORT}"

echo "[start] tailscale status"
tailscale --socket=/tmp/tailscaled.sock status || true

wait "${TS_PID}"