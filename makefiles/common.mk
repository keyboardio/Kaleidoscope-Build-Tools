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

SKETCH_SOURCEDIR    ?= .
SKETCH              ?= $(notdir ${CURDIR})
SKETCH_DATE         := $(shell date +%Y%m%d%H%M%S)
SKETCH_VERSION      ?= ${SKETCH_DATE}

OS                  := $(shell uname -s)

TOOLS_DIR           := ${MAKEFILE_RULES_DIR}/../tools

DESTDIR             ?= ./
OUTPUT_DIR          ?= output
BUILD_PATH          := $(shell mktemp -d 2>/dev/null || mktemp -d -t 'build')
