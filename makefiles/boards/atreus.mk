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

VID            := 0x1209
PID            := 0xa1e5
BOOTLOADER_VID := ${VID}
BOOTLOADER_PID := ${PID}
MCU            := atmega32u4
PINOUT         ?= post-2016
CPU            ?= teensy

DATA_SIZE_MAX  := 2560

include ${MAKEFILE_RULES_DIR}/boards/common.mk
include ${MAKEFILE_RULES_DIR}/flasher/avrdude.mk
include ${MAKEFILE_RULES_DIR}/flasher/teensy-cli.mk

ifeq (${PINOUT},post-2016)
ARDUINO_CFLAGS  = -DKALEIDOSCOPE_HARDWARE_ATREUS_PINOUT_ASTAR=1
else
ifeq (${PINOUT},pre-2016)
ARDUINO_CFLAGS  = -DKALEIDOSCOPE_HARDWARE_ATREUS_PINOUT_ASTAR_DOWN=1
else
ifeq (${PINOUT},legacy-teensy)
ARDUINO_CFLAGS  = -DKALEIDOSCOPE_HARDWARE_ATREUS_PINOUT_LEGACY_TEENSY2=1
else
$(error "Unknown PINOUT: ${PINOUT}.")
endif
endif
endif

ifeq (${CPU},teensy)
PROG_SIZE_MAX  := 32256
else
PROG_SIZE_MAX  := 28672
endif

flash/prepare:
	@echo "To update your keyboard's firmware, press the reset button on the back of"
	@echo "your keyboard, and then press 'Enter'."
	@echo ""

	@read a

flash: flash/${CPU}
flash/astar: flash/avrdude

supported-device-list:
	@echo 'BOARD=atreus'
	@echo ' - CPU: "astar" or "teensy"'
	@echo ' - PINOUT: "legacy-teensy", "pre-2016", or "post-2016"'

.PHONY: flash flash/prepare supported-device-list
