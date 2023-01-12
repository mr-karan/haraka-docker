.PHONY: build
build:
	docker buildx build --file Dockerfile .
