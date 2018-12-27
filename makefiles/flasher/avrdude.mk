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

ifeq (${OS},FreeBSD)
AVRDUDE      ?= /usr/local/bin/avrdude
AVRDUDE_CONF ?= /usr/local/etc/avrdude.conf
else
AVRDUDE      ?= ${ARDUINO_TOOLS_PATH}/avr/bin/avrdude
AVRDUDE_CONF ?= ${ARDUINO_TOOLS_PATH}/avr/etc/avrdude.conf
endif

flash/avrdude: ${DESTDIR}${OUTPUT_DIR}/${SKETCH}-latest.hex flash/prepare
	${AVRDUDE} \
		-q -q \
		-C "${AVRDUDE_CONF}" \
		-p"${MCU}" \
		-cavr109 \
		-D \
		-P "${DEVICE_PORT_BOOTLOADER}" \
		-b57600 \
		"-Uflash:w:$<:i"

.PHONY: flash/avrdude
