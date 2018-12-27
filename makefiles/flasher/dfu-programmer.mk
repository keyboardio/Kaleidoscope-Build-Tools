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

DFU_PROGRAMMER ?= dfu-programmer

flash/dfu-programmer: ${DESTDIR}${OUTPUT_DIR}/${SKETCH}-latest.hex flash/prepare
	${DFU_PROGRAMMER} ${MCU} erase
	${DFU_PROGRAMMER} ${MCU} flash "$<"
	${DFU_PROGRAMMER} ${MCU} start

.PHONY: flash/dfu-programmer
