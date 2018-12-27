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

## Note: This file is meant to be included by individual sketches/examples. It
## only builds a single sketch.

ifeq (${BOARD},)
$(error Please set $${BOARD}, otherwise the sketch cannot be compiled.)
endif

MAKEFILE_RULES_DIR := $(dir $(lastword ${MAKEFILE_LIST}))

OUTPUT_DIR         ?= output/$(shell              \
	echo "${CURDIR}" | grep -q ".*/examples/"    && \
	echo "${CURDIR}" | sed -e "s,.*/examples/,," || \
	echo \${SKETCH}                                 \
)

include ${MAKEFILE_RULES_DIR}/verbose.mk
include ${MAKEFILE_RULES_DIR}/common.mk
include ${MAKEFILE_RULES_DIR}/arduino.mk
include ${MAKEFILE_RULES_DIR}/tests.mk
include ${MAKEFILE_RULES_DIR}/boards/${BOARD}.mk

.DEFAULT_GOAL := build
