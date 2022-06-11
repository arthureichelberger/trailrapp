.DEFAULT_GOAL := help
.PHONY: build
IMG="ghcr.io/arthureichelberger/trailrapp"

help: ## Makefile help
help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

start: ## Start the app locally
start:
	npm run start

build: ## Build the app locally
build:
	npm run build

lint: ## Run the linter
lint:
	npm run lint

deploy: ## Deploy the image
deploy:
	./deploy.sh $(IMG) -f ./dist/Dockerfile .
