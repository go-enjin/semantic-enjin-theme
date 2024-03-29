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

THEME_NAME      := semantic-enjin
SITE_THEME_NAME := semantic-enjin-site

THEME_MENUS_SCSS    := ${THEME_NAME}/src/scss/targets-page-menus.scss
THEME_CAROUSEL_SCSS := ${THEME_NAME}/src/scss/targets-block-carousel.scss

SHELL = /bin/bash

.PHONY = all build release locales tidy local unlocal be-update

export BE_LOCAL_PATH ?= ../be

help:
	@echo "# usage: make <help|build|release|tidy|local|unlocal|be-update>"

compile:
	@echo "# build-testing ${THEME_NAME} package"
	@go build -v -tags fs_theme,locals

generate:
	@echo "# generating ${THEME_MENUS_SCSS}"
	@./_scripts/make-targets-page-menus.pl > ${THEME_MENUS_SCSS}
	@echo "# generating ${THEME_CAROUSEL_SCSS}"
	@./_scripts/make-targets-block-carousel.pl > ${THEME_CAROUSEL_SCSS}

build-theme: generate
	@pushd ${THEME_NAME} > /dev/null \
		&& make build \
		&& popd > /dev/null

build-site-theme:
	@pushd ${SITE_THEME_NAME} > /dev/null \
		&& make build \
		&& popd > /dev/null
	@echo "# build-testing ${SITE_THEME_NAME}-theme package"
	@go build -v -tags fs_theme,locals

build: build-theme build-site-theme compile

release-theme:
	@pushd ${THEME_NAME} > /dev/null \
		&& make release \
		&& popd > /dev/null
	@echo "# release-testing ${THEME_NAME}-theme package"
	@go build -v -tags fs_theme,embeds

release-site-theme:
	@pushd ${SITE_THEME_NAME} > /dev/null \
		&& make release \
		&& popd > /dev/null
	@echo "# release-testing ${SITE_THEME_NAME}-theme package"
	@go build -v -tags fs_theme,embeds

release: release-theme release-site-theme compile

locales-theme:
	@pushd ${THEME_NAME} > /dev/null \
		&& make locales \
		&& popd > /dev/null

locales-site:
	@pushd ${SITE_THEME_NAME} > /dev/null \
		&& make locales \
		&& popd > /dev/null

locales: locales-theme locales-site

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
