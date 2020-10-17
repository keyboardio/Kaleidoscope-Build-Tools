EXTRA_BUILDER_ARGS="-libraries ."
PLUGIN_TEST_SUPPORT_DIR ?= $(BOARD_HARDWARE_PATH)/keyboardio/build-tools/
PLUGIN_TEST_BIN_DIR ?= $(PLUGIN_TEST_SUPPORT_DIR)/../toolchain/$(shell gcc --print-multiarch)/bin

KALEIDOSCOPE_BUILDER_DIR ?= $(BOARD_HARDWARE_PATH)/keyboardio/avr/libraries/Kaleidoscope/bin/


.DEFAULT_GOAL := all

all: build-all
	@: ## Do not remove this line, otherwise `make all` will trigger the `%` rule too.

%:
	BOARD_HARDWARE_PATH="$(BOARD_HARDWARE_PATH)" $(KALEIDOSCOPE_BUILDER_DIR)/kaleidoscope-builder $@

