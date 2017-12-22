EXTRA_BUILDER_ARGS="-libraries ."
PLUGIN_TEST_SUPPORT_DIR ?= $(BOARD_HARDWARE_PATH)/keyboardio/avr/build-tools/
PLUGIN_TEST_BIN_DIR ?= $(PLUGIN_TEST_SUPPORT_DIR)/../$(shell gcc --print-multiarch)/bin

KALEIDOSCOPE_BUILDER_DIR ?= $(BOARD_HARDWARE_PATH)/keyboardio/avr/libraries/Kaleidoscope/bin/

TRAVIS_ARDUINO=arduino-1.8.2
TRAVIS_ARDUINO_FILE = $(TRAVIS_ARDUINO)-linux64.tar.xz
TRAVIS_ARDUINO_PATH ?= $(shell pwd)/$(TRAVIS_ARDUINO)
TRAVIS_ARDUINO_DOWNLOAD_URL = http://downloads.arduino.cc/$(TRAVIS_ARDUINO_FILE)

# TODO check the shasum of the travis arduino file

.PHONY: travis-install-arduino astyle travis-test travis-check-astyle travis-smoke-examples test cpplint cpplint-noisy

.DEFAULT_GOAL := all

all: build-all
	@: ## Do not remove this line, otherwise `make all` will trigger the `%` rule too.

astyle:	
	$(PLUGIN_TEST_SUPPORT_DIR)/quality/run-astyle

travis-test: travis-smoke-examples travis-check-astyle

test: smoke-examples check-astyle cpplint-noisy check-docs

smoke-examples:
	$(KALEIDOSCOPE_BUILDER_DIR)/kaleidoscope-builder build-all 

check-docs:
	doxygen $(PLUGIN_TEST_SUPPORT_DIR)/quality/etc/check-docs.conf 2> /dev/null >/dev/null
	python $(PLUGIN_TEST_SUPPORT_DIR)/quality/doxy-coverage.py /tmp/undocced/xml

check-astyle: astyle
	$(PLUGIN_TEST_SUPPORT_DIR)/quality/astyle-check
	
cpplint-noisy:
	-$(PLUGIN_TEST_SUPPORT_DIR)/quality/cpplint.py  --filter=-legal/copyright,-build/include,-readability/namespace,,-whitespace/line_length  --recursive --extensions=cpp,h,ino --exclude=$(BOARD_HARDWARE_PATH) --exclude=$(TRAVIS_ARDUINO) src examples


cpplint:
	$(PLUGIN_TEST_SUPPORT_DIR)/quality/cpplint.py  --quiet --filter=-whitespace,-legal/copyright,-build/include,-readability/namespace  --recursive --extensions=cpp,h,ino src examples

## NOTE: HERE BE DRAGONS, DO NOT CLEAN THIS UP!
# When building outside of Arduino-Boards, we want to use the current library,
# not whatever version is in Arduino-Boards at the time. To do so, we must tell
# arduino-builder about the library, because the current directory is not
# considered by default.
#
# Now, we can't use -libraries ., because arduino-builder will search for a
# directory named like the library, and we don't have that. We are already in
# the library directory at this point.
#
# So, we need a library outside of the current dir. We could use .., but we want
# to be safe, to only have the current library there. For this reason, the
# travis-smoke-examples target will create a current-libraries directory one
# level up, symlink the current directory there, under the library name, and add
# -libraries $(pwd)/../current-libraries to the arduino-builder arguments.
#
# All of this makes the builder consider the current library the best to use.
travis-smoke-examples: travis-install-arduino
	install -d ../current-libraries
	ln -s $$(pwd) ../current-libraries/
	ARDUINO_PATH="$(TRAVIS_ARDUINO_PATH)" BOARD_HARDWARE_PATH="$(BOARD_HARDWARE_PATH)" EXTRA_BUILDER_ARGS="-libraries $$(pwd)/../current-libraries" $(KALEIDOSCOPE_BUILDER_DIR)/kaleidoscope-builder build-all
	rm -rf ../current-libraries


travis-check-astyle:
	PATH="$(PLUGIN_TEST_BIN_DIR):$(PATH)" $(PLUGIN_TEST_SUPPORT_DIR)/quality/run-astyle
	$(PLUGIN_TEST_SUPPORT_DIR)/quality/astyle-check

%:	
	BOARD_HARDWARE_PATH="$(BOARD_HARDWARE_PATH)" $(KALEIDOSCOPE_BUILDER_DIR)/kaleidoscope-builder $@


travis-install-arduino:
	@if [ ! -d "$(TRAVIS_ARDUINO_PATH)" ]; then \
		echo "Installing Arduino..."; \
		wget -O "$(TRAVIS_ARDUINO_FILE)" -c $(TRAVIS_ARDUINO_DOWNLOAD_URL); \
		tar xf $(TRAVIS_ARDUINO_FILE); \
	fi
