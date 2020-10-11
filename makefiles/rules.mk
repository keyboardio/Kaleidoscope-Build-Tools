EXTRA_BUILDER_ARGS="-libraries ."
PLUGIN_TEST_SUPPORT_DIR ?= $(BOARD_HARDWARE_PATH)/keyboardio/build-tools/
PLUGIN_TEST_BIN_DIR ?= $(PLUGIN_TEST_SUPPORT_DIR)/../toolchain/$(shell gcc --print-multiarch)/bin

KALEIDOSCOPE_BUILDER_DIR ?= $(BOARD_HARDWARE_PATH)/keyboardio/avr/libraries/Kaleidoscope/bin/


SHELL_FILES = $(shell if [ -d bin ]; then egrep -n -r -l "(env (ba)?sh)|(/bin/(ba)?sh)" bin; fi)



.PHONY: astyle test cpplint cpplint-noisy shellcheck smoke-examples

.DEFAULT_GOAL := all

all: build-all
	@: ## Do not remove this line, otherwise `make all` will trigger the `%` rule too.

astyle:
	PATH="$(PLUGIN_TEST_BIN_DIR):$(PATH)" $(PLUGIN_TEST_SUPPORT_DIR)/quality/run-astyle

test: smoke-examples check-astyle cpplint check-docs


simulator-tests:
	$(MAKE) -C $(BOARD_HARDWARE_PATH)/keyboardio prepare-virtual
	$(MAKE) -C tests all

smoke-examples:
	$(KALEIDOSCOPE_BUILDER_DIR)/kaleidoscope-builder compile-all

check-docs:
	doxygen $(PLUGIN_TEST_SUPPORT_DIR)/quality/etc/check-docs.conf 2> /dev/null >/dev/null
	python $(PLUGIN_TEST_SUPPORT_DIR)/quality/doxy-coverage.py /tmp/undocced/xml

check-astyle: astyle
	PATH="$(PLUGIN_TEST_BIN_DIR):$(PATH)" $(PLUGIN_TEST_SUPPORT_DIR)/quality/astyle-check

cpplint-noisy:
	-$(PLUGIN_TEST_SUPPORT_DIR)/quality/cpplint.py  --filter=-legal/copyright,-build/include,-readability/namespace,-whitespace/line_length,-runtime/references  --recursive --extensions=cpp,h,ino --exclude=$(BOARD_HARDWARE_PATH) src examples


cpplint:
	$(PLUGIN_TEST_SUPPORT_DIR)/quality/cpplint.py  --quiet --filter=-whitespace,-legal/copyright,-build/include,-readability/namespace,-runtime/references  --recursive --extensions=cpp,h,ino src examples

shellcheck:
	@if [ -d "bin" ]; then \
		shellcheck ${SHELL_FILES}; \
	fi

find-filename-conflicts:
	@if [ -d "bin" ]; then \
		bin/find-filename-conflicts; \
	fi

SMOKE_SKETCHES=$(shell if [ -d ./examples ]; then find ./examples -type f -name \*ino | xargs -n 1 dirname; fi)

adjust-git-timestamps:
	bin/set-timestamps-from-git

smoke-sketches: $(SMOKE_SKETCHES)
	@echo "Smoke-tested all the sketches"

.PHONY: force


$(SMOKE_SKETCHES): force
	@BOARD_HARDWARE_PATH="$(BOARD_HARDWARE_PATH)" $(KALEIDOSCOPE_BUILDER_DIR)/kaleidoscope-builder $@ compile


%:
	BOARD_HARDWARE_PATH="$(BOARD_HARDWARE_PATH)" $(KALEIDOSCOPE_BUILDER_DIR)/kaleidoscope-builder $@

