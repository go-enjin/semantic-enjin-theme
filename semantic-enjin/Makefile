#!/usr/bin/make -f

.PHONY: all build

help:
	@echo "usage: make {help,build}"

build:
	@gassc ./src/scss/semantic-enjin.scss \
		> ./static/css/semantic-enjin.css
	@sha256sum ./static/css/semantic-enjin.css
