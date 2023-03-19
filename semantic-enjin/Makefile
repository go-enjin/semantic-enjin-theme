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

SHELL=/bin/bash

INPUT_SCSS      := src/scss/semantic-enjin.scss
OUTPUT_CSS      := static/css/semantic-enjin.css
LOCALES_PATH    := locales/en
OUT_GOTEXT_JSON := ${LOCALES_PATH}/out.gotext.json
OUTPUT_LOCALES   := en,ja

.PHONY: all help build release clean locales

help:
	@echo "usage: make [help|build|release|clean|locales]"

build: clean locales
	@gassc --output-file=${OUTPUT_CSS} ${INPUT_SCSS}
	@sha256sum ./static/css/semantic-enjin.css*

release: clean locales
	@gassc --release --output-file=${OUTPUT_CSS} ${INPUT_SCSS}
	@sha256sum ${OUTPUT_CSS}*

clean:
	@rm -fv ${OUTPUT_CSS}*
	@rm -fv ${OUT_GOTEXT_JSON}

locales:
	@echo "# updating locales..."
	@enjenv be-update-locales -lang=${OUTPUT_LOCALES} -out=locales layouts
