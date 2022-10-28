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

gen-en-locale: clean
	@mkdir -p ${LOCALES_PATH}
	@echo -e "{" >> ${OUT_GOTEXT_JSON}
	@echo -e "\t\"language\": \"en\"," >> ${OUT_GOTEXT_JSON}
	@echo -e "\t\"messages\": [" >> ${OUT_GOTEXT_JSON}
	@egrep -h -r '\{\{[ ]*_[ ]+' layouts/ \
		| perl -pe 's!^.*\{\{\s*_\s+(.+?)\s*\}\}.*$$!$$1!;' \
		| sort -u -V > ${TMPDIR}/out.gotext.tmpl; \
		NUM_TX=`wc -l ${TMPDIR}/out.gotext.tmpl | awk '{print $$1}'`; \
		COUNTER=0; \
		cat ${TMPDIR}/out.gotext.tmpl | while read ARGS; \
			do \
				COMMA=","; \
				COUNTER=$$(( $$COUNTER + 1 )); \
				if [ "$$COUNTER" -eq "$$NUM_TX" ]; then COMMA=""; fi; \
				STR=`echo "$${ARGS}" | perl -pe '$$_ = "" unless $$_ =~ m!".+?"!;'`; \
				if [ -z "$${STR}" ]; then \
					echo "# $${ARGS} values must be translated manually" 1>&2; \
				else \
					VAL=`echo "$${STR}" | perl -pe 'if ($$_ =~ m!"(.+?)"!) {$$_=$$1;} else {$$_ = ""};'`; \
					RPL=`echo "$${STR}" | perl -pe 'if ($$_ =~ m!".+?"\s+(\S.*)\s*$$!) {$$_=$$1;} else {$$_ = ""};'`; \
					if [ -z "$${RPL}" ]; then \
						echo -e "\t\t{" >> ${OUT_GOTEXT_JSON}; \
						echo -e "\t\t\t\"id\": \"$${VAL}\"," >> ${OUT_GOTEXT_JSON}; \
						echo -e "\t\t\t\"key\": \"$${VAL}\"," >> ${OUT_GOTEXT_JSON}; \
						echo -e "\t\t\t\"message\": \"$${VAL}\"," >> ${OUT_GOTEXT_JSON}; \
						echo -e "\t\t\t\"translation\": \"$${VAL}\"," >> ${OUT_GOTEXT_JSON}; \
						echo -e "\t\t\t\"translatorComment\": \"Copied from source\"" >> ${OUT_GOTEXT_JSON}; \
						echo -e "\t\t}$${COMMA}" >> ${OUT_GOTEXT_JSON}; \
					else \
						echo -e "\t\t{" >> ${OUT_GOTEXT_JSON}; \
						echo -e "\t\t\t\"id\": \"$${VAL}\"," >> ${OUT_GOTEXT_JSON}; \
						echo -e "\t\t\t\"key\": \"$${VAL}\"," >> ${OUT_GOTEXT_JSON}; \
						echo -e "\t\t\t\"message\": \"$${VAL}\"," >> ${OUT_GOTEXT_JSON}; \
						echo -e "\t\t\t\"translation\": \"$${VAL}\"," >> ${OUT_GOTEXT_JSON}; \
						echo -e "\t\t\t\"translatorComment\": \"Copied from source: $${RPL}\"" >> ${OUT_GOTEXT_JSON}; \
						echo -e "\t\t}$${COMMA}" >> ${OUT_GOTEXT_JSON}; \
					fi; \
				fi; \
			done
	@echo -e "\t]" >> ${OUT_GOTEXT_JSON}
	@echo -n "}" >> ${OUT_GOTEXT_JSON}
	@rm -f ${TMPDIR}/out.gotext.tmpl
	@sha256sum ${OUT_GOTEXT_JSON}
