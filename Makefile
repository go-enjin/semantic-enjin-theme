#!/usr/bin/make -f

# Copyright (c) 2023  The Go-Enjin Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

SHELL = /bin/bash

.PHONY = all build release locales tidy local unlocal be-update

BE_LOCAL_PATH = ../be

help:
	@echo "# usage: make <help|build|release|tidy|local|unlocal|be-update>"

build:
	@pushd ./semantic-enjin > /dev/null \
		&& make build \
		&& popd > /dev/null

release:
	@pushd ./semantic-enjin > /dev/null \
		&& make release \
		&& popd > /dev/null

locales:
	@pushd ./semantic-enjin > /dev/null \
		&& make locales \
		&& popd > /dev/null

tidy:
	@go mod tidy

local:
	@echo "# go.mod local: github.com/go-enjin/be"
	@enjenv go-local
	@go mod tidy

unlocal:
	@echo "# go.mod unlocal: github.com/go-enjin/be"
	@enjenv go-unlocal
	@go mod tidy

be-update: export GOPROXY=direct
be-update:
	@echo "# updating github.com/go-enjin/be"
	@go get github.com/go-enjin/be@latest
