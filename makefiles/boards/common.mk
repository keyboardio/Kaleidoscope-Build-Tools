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

ifeq (${OS},Linux)
RESET_COMMAND = stty -F ${DEVICE_PORT} 1200 hupcl
PORT_FINDER   = ${TOOLS_DIR}/find-device-port-linux-udev
else
ifeq (${OS},Darwin)
RESET_COMMAND = stty -f ${DEVICE_PORT} 1200
PORT_FINDER   = ${TOOLS_DIR}/find-device-port-macos
else
ifeq (${OS},FreeBSD)
RESET_COMMAND = stty -f ${DEVICE_PORT} 1200
PORT_FINDER   = ${TOOLS_DIR}/find-device-port-freebsd
else
$(error "Unsupported platform: \`${OS}\`, please file an issue.")
endif
endif
endif

DEVICE_PORT            ?= $(shell perl ${PORT_FINDER} ${VID} ${PID})
DEVICE_PORT_BOOTLOADER ?= $(shell perl ${PORT_FINDER} ${BOOTLOADER_VID} ${BOOTLOADER_PID})
