SOURCE_COMMIT = $(shell git rev-parse --short HEAD)

.PHONY: all
all: build
	docker-compose up -d

.PHONY: build
build:
	docker-compose build --build-arg SOURCE_COMMIT=$(SOURCE_COMMIT)

