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

ARDUINO_PATH                 ?= /usr/local/arduino
ARDUINO_LOCAL_LIB_PATH       ?= ${HOME}/Arduino
ARDUINO_TOOLS_PATH           ?= ${ARDUINO_PATH}/hardware/tools
ARDUINO_TOOLS_PARAM          ?= -tools ${ARDUINO_TOOLS_PATH}
ARDUINO_PACKAGE_PATH         ?= ${HOME}/.arduino15/packages
ARDUINO_PACKAGES             := $(shell test -d ${ARDUINO_PACKAGE_PATH} && echo "-hardware \"${ARDUINO_PACKAGE_PATH}\"")
ARDUINO_AVR_GCC_PREFIX_PARAM ?= -prefs "runtime.tools.avr-gcc.path=${AVR_GCC_PREFIX}"

ARDUINO_BUILDER              ?= ${ARDUINO_PATH}/arduino-builder
ARDUINO_IDE_VERSION          ?= 10607

BOARD_HARDWARE_PATH          ?= $(abspath $(dir $(lastword ${MAKEFILE_LIST}))../../../../../)
FQBN                         ?= keyboardio:avr:${BOARD}

ifeq (${OS},FreeBSD)
AVR_NM                       ?= /usr/local/bin/avr-nm
AVR_OBJDUMP                  ?= /usr/local/bin/avr-objdump
AVR_SIZE                     ?= /usr/local/bin/avr-size
else
AVR_NM                       ?= ${ARDUINO_TOOLS_PATH}/avr/bin/avr-nm
AVR_OBJDUMP                  ?= ${ARDUINO_TOOLS_PATH}/avr/bin/avr-objdump
AVR_SIZE                     ?= ${ARDUINO_TOOLS_PATH}/avr/bin/avr-size
endif

AVR_SIZE_FLAGS               ?= -C --mcu=${MCU}

${DESTDIR}${OUTPUT_DIR}:
	install -d $@

compile ${DESTDIR}${OUTPUT_DIR}/${SKETCH}-latest.hex ${DESTDIR}${OUTPUT_DIR}/${SKETCH}-latest.elf: ${DESTDIR}${OUTPUT_DIR}
ifeq (${V},)
	@echo "Building ${OUTPUT_DIR}/${SKETCH} (${SKETCH_VERSION})"
endif
	${ARDUINO_BUILDER} \
		-compile \
		${ARDUINO_PACKAGES} \
		-hardware "${ARDUINO_PATH}/hardware" \
		-hardware "${BOARD_HARDWARE_PATH}" \
		${ARDUINO_TOOLS_PARAM} \
		-tools "${ARDUINO_PATH}/tools-builder" \
		-fqbn "${FQBN}" \
		-libraries "." \
		-build-path "${BUILD_PATH}" \
		-ide-version "${ARDUINO_IDE_VERSION}" \
		-prefs "compiler.cpp.extra_flags=-std=c++11 -Woverloaded-virtual -Wno-unused-parameter -Wno-unused-variable -Wno-ignored-qualifiers ${ARDUINO_CFLAGS} ${LOCAL_CFLAGS}" \
		-warnings all \
		${ARDUINO_VERBOSE} \
		${ARDUINO_AVR_GCC_PREFIX_PARAM} \
		${ARDUINO_BUILDER_ARGS} \
		${SKETCH_SOURCEDIR}/${SKETCH}.ino  \
	| sed -e "/Maximum is [0-9]* bytes/d"

	cp "${BUILD_PATH}/${SKETCH}.ino.hex" "${DESTDIR}${OUTPUT_DIR}/${SKETCH}-${SKETCH_VERSION}.hex"
	cp "${BUILD_PATH}/${SKETCH}.ino.elf" "${DESTDIR}${OUTPUT_DIR}/${SKETCH}-${SKETCH_VERSION}.elf"
	cp "${BUILD_PATH}/${SKETCH}.ino.hex" "${DESTDIR}${OUTPUT_DIR}/${SKETCH}-latest.hex"
	cp "${BUILD_PATH}/${SKETCH}.ino.elf" "${DESTDIR}${OUTPUT_DIR}/${SKETCH}-latest.elf"
	rm -rf "${BUILD_PATH}"

clean:
	rm -rf -- "${DESTDIR}${OUTPUT_DIR}"

size: ${DESTDIR}${OUTPUT_DIR}/${SKETCH}-latest.elf
size: PROG_SIZE = $(shell ${AVR_SIZE} ${AVR_SIZE_FLAGS} $< | sed -ne "s#Program: *\([0-9]*\).*#\1#p" | awk '{printf "%5s", $$1}')
size: DATA_SIZE = $(shell ${AVR_SIZE} ${AVR_SIZE_FLAGS} $< | sed -ne "s#Data: *\([0-9]*\).*#\1#p" | awk '{printf "%5s", $$1}')
size: PROG_SIZE_PERCENT = $(shell echo ${PROG_SIZE} ${PROG_SIZE_MAX} | awk "{ printf \"%02.01f\", \$$1 / \$$2 * 100 }")
size: DATA_SIZE_PERCENT = $(shell echo ${DATA_SIZE} ${DATA_SIZE_MAX} | awk "{ printf \"%02.01f\", \$$1 / \$$2 * 100 }")
size:
	@echo " - Program: ${PROG_SIZE} bytes (${PROG_SIZE_PERCENT}%)"
	@echo " - Data:    ${DATA_SIZE} bytes (${DATA_SIZE_PERCENT}%)"

size-map: ${DESTDIR}${OUTPUT_DIR}/${SKETCH}-latest.elf
	"${AVR_NM}" --size-sort -C -r -l -t decimal "$<"

disassemble decompile: ${DESTDIR}${OUTPUT_DIR}/${SKETCH}-latest.elf
	"${AVR_OBJDUMP}" -C -d "$<"

build: compile size

.PHONY: compile clean build size size-map disassemble decompile
