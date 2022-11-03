#!/usr/bin/make -f

SHELL=/bin/bash

TMPDIR=/tmp
LOCALES_PATH = locales/en
OUT_GOTEXT_JSON = ${LOCALES_PATH}/out.gotext.json

.PHONY: all build

help:
	@echo "usage: make {help,build}"

build:
	@gassc ./src/scss/semantic-enjin.scss \
		> ./static/css/semantic-enjin.css
	@sha256sum ./static/css/semantic-enjin.css

clean:
	@rm -fv ${OUT_GOTEXT_JSON}

gen-locales:
	@echo "# updating locales..."
	@enjenv be-update-locales -lang=en,ja -out=locales layouts
