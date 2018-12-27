# Copyright (C) 2018  Keyboard.io, Inc.
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program. If not, see <http://www.gnu.org/licenses/>.

PLUGIN_TEST_SUPPORT_DIR     ?= ${MAKEFILE_RULES_DIR}/..
PLUGIN_TEST_BIN_DIR         ?= $(PLUGIN_TEST_SUPPORT_DIR)/../toolchain/$(shell gcc --print-multiarch)/bin

astyle:
	PATH="$(PLUGIN_TEST_BIN_DIR):$(PATH)" $(PLUGIN_TEST_SUPPORT_DIR)/quality/run-astyle
check-astyle: astyle
	PATH="$(PLUGIN_TEST_BIN_DIR):$(PATH)" $(PLUGIN_TEST_SUPPORT_DIR)/quality/astyle-check

.PHONY: astyle check-astyle

cpplint-noisy:
	-$(PLUGIN_TEST_SUPPORT_DIR)/quality/cpplint.py  --filter=-legal/copyright,-build/include,-readability/namespace,-whitespace/line_length,-runtime/references  --recursive --extensions=cpp,h,ino --exclude=$(BOARD_HARDWARE_PATH) --exclude=$(TRAVIS_ARDUINO) src examples

cpplint:
	$(PLUGIN_TEST_SUPPORT_DIR)/quality/cpplint.py  --quiet --filter=-whitespace,-legal/copyright,-build/include,-readability/namespace,-runtime/references  --recursive --extensions=cpp,h,ino src examples

.PHONY: cpplint cpplint-noisy
