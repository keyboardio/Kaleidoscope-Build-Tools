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
PID            := 0x2301
BOOTLOADER_VID := 0x1209
BOOTLOADER_PID := 0x2300
MCU            := atmega32u4

PROG_SIZE_MAX  := 28672
DATA_SIZE_MAX  := 2560

include ${MAKEFILE_RULES_DIR}/boards/common.mk
include ${MAKEFILE_RULES_DIR}/flasher/avrdude.mk

flash/prepare:
	@echo "To update your keyboard's firmware, hold down the 'Prog' key on your keyboard,"
	@echo "and then press 'Enter'."
	@echo ""
	@echo "When the 'Prog' key glows red, you can release it."
	@echo ""

	@read a

flash/reset:
	${RESET_COMMAND}
	sleep 3

flash/avrdude: flash/check

flash/check: flash/reset
	@if [ -z "${DEVICE_PORT_BOOTLOADER}" ]; then \
		echo "Unable to detect a keyboard in bootloader mode. You may need to hold the 'Prog' key or hit a reset button."; \
		exit 1; \
	fi

flash: ${DESTDIR}${OUTPUT_DIR}/${SKETCH}-latest.hex
	${MAKE} flash/avrdude

supported-device-list:
	@echo 'BOARD=model01'

.PHONY: flash flash/prepare flash/reset flash/check supported-device-list
