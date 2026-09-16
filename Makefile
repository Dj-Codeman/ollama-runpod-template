IMAGE_NAME ?= ghcr.io/dj-codeman/ollama-tailnet
VERSION ?= latest
PLATFORM ?= linux/amd64

.PHONY: help build push release clean

help:
	@echo "Available targets:"
	@echo "  make build             - Build Docker image locally (default tag: latest)"
	@echo "  make push              - Build and push Docker image to GHCR"
	@echo "  make release VERSION=v0.2.0 - Build, tag with VERSION and latest, and push to GHCR"

build:
	NO_PUSH=1 IMAGE_NAME=$(IMAGE_NAME) PLATFORM=$(PLATFORM) ./build-and-push.sh $(VERSION)

push:
	IMAGE_NAME=$(IMAGE_NAME) PLATFORM=$(PLATFORM) ./build-and-push.sh $(VERSION)

release:
	@if [ "$(VERSION)" = "latest" ]; then \
		echo "Error: Specify a version for release (e.g. make release VERSION=v0.2.0)"; \
		exit 1; \
	fi
	IMAGE_NAME=$(IMAGE_NAME) PLATFORM=$(PLATFORM) ./build-and-push.sh $(VERSION)
