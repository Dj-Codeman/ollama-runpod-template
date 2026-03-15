FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV OLLAMA_HOST=127.0.0.1:11434
ENV OLLAMA_MODELS=/workspace/ollama-models
ENV TS_STATE_DIR=/workspace/tailscale-state
ENV TS_USERSPACE=true
ENV TS_HOSTNAME=runpod-ollama
ENV TS_SERVE_PORT=11434

RUN apt-get update && apt-get install -y \
    zstd \
    ca-certificates \
    curl \
    gnupg \
    iproute2 \
    jq \
    lsof \
    procps \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Install Tailscale
RUN mkdir -p /usr/share/keyrings && \
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg \
      -o /usr/share/keyrings/tailscale-archive-keyring.gpg && \
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.tailscale-keyring.list \
      -o /etc/apt/sources.list.d/tailscale.list && \
    apt-get update && \
    apt-get install -y tailscale && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 11434

ENTRYPOINT ["/entrypoint.sh"]