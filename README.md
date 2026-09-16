# Ollama + Tailscale Runpod Template

Docker container running Ollama and Tailscale userspace networking for Runpod applet deployments.

## Package Identity
* **Repository**: `Dj-Codeman/ollama-runpod-template`
* **GHCR Target**: `ghcr.io/dj-codeman/ollama-tailnet`

---

## Tooling & Building Locally

### Quick Commands

```bash
# Build image locally (tagged as ghcr.io/dj-codeman/ollama-tailnet:latest)
make build

# Build and push latest image to GHCR
make push

# Release a specific version (tags v0.2.0 and latest, then pushes)
make release VERSION=v0.2.0
```

### Manual Script Usage

```bash
# Build & push latest
./build-and-push.sh latest

# Build & push a specific tag
./build-and-push.sh v0.2.0

# Build without pushing
NO_PUSH=1 ./build-and-push.sh v0.2.0
```

---

## GitHub Container Registry (GHCR) Authentication

Before pushing manually from your local machine, log into GHCR:

```bash
echo "YOUR_GITHUB_PAT" | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
```

*Note: Your GitHub Personal Access Token (PAT) requires `write:packages` scope.*

---

## Automated GitHub Actions CI/CD

This repository includes `.github/workflows/docker-publish.yml`.
* **Push to `main`**: Automatically builds and publishes `ghcr.io/dj-codeman/ollama-tailnet:latest` and `ghcr.io/dj-codeman/ollama-tailnet:<sha>`.
* **Git Tags (`v*`)**: Pushing a git tag (e.g. `git tag v0.2.0 && git push origin v0.2.0`) builds and publishes `ghcr.io/dj-codeman/ollama-tailnet:v0.2.0`.
* **Manual Dispatch**: Triggerable via GitHub Actions UI.

---

## Environment Variables at Runtime

* `SESSION_ID`: (Optional) Session UUID passed by Session Manager.
* `TS_HOSTNAME`: (Optional) Tailscale hostname. If unset, automatically defaults to `ais-${hex(SESSION_ID[0..13])}`.
* `TS_AUTHKEY`: (Required) Tailscale authentication key (`tskey-auth-...`).
* `TS_SERVE_PORT`: Internal port exposed on Tailnet (default: `11434`).
