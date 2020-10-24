KALEIDOSCOPE_BUILDER_DIR ?= $(BOARD_HARDWARE_PATH)/keyboardio/avr/libraries/Kaleidoscope/bin/

.DEFAULT_GOAL := compile

all: 
	@echo "Make all target doesn't do anything"
	@: ## Do not remove this line, otherwise `make all` will trigger the `%` rule too.

decompile: disassemble
	@: ## Do not remove this line, otherwise `make all` will trigger the `%` rule too.

build: compile
	@: ## Do not remove this line, otherwise `make all` will trigger the `%` rule too.

%:
	BOARD_HARDWARE_PATH="$(BOARD_HARDWARE_PATH)" $(KALEIDOSCOPE_BUILDER_DIR)/kaleidoscope-builder $@

