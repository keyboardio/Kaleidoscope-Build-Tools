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
PID            := 0x2303
BOOTLOADER_VID := ${VID}
BOOTLOADER_PID := ${PID}
MCU            := atmega32u4

PROG_SIZE_MAX  := 28672
DATA_SIZE_MAX  := 2560

include ${MAKEFILE_RULES_DIR}/boards/common.mk
include ${MAKEFILE_RULES_DIR}/flasher/dfu-programmer.mk

flash/prepare:
	@echo "To update your keyboard's firmware, press the reset button on your keyboard,"
	@echo "and then press 'Enter'."
	@echo ""

	@read a

flash: flash/dfu-programmer

supported-device-list:
	@echo 'BOARD=planck'

.PHONY: flash flash/prepare supported-device-list
