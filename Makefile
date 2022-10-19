#!/usr/bin/make -f

SHELL = /bin/bash

.PHONY = all build tidy local unlocal

BE_REPO_PATH ?= ../be

help:
	@echo "# usage: make <help|build|tidy|local|unlocal>"

build:
	@pushd ./semantic-enjin > /dev/null \
		&& make build \
		&& popd > /dev/null

tidy:
	@go mod tidy

local: export BE_LOCAL_PATH=${BE_REPO_PATH}
local:
	@echo "# go.mod local: github.com/go-enjin/be"
	@enjenv go-local
	@go mod tidy

unlocal:
	@echo "# go.mod unlocal: github.com/go-enjin/be"
	@enjenv go-unlocal
	@go mod tidy
