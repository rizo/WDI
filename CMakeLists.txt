#	*Web Development Interface*
#	[CMakeLists.txt]
#
# 	Copyright (c) 2009 - 2010, ODIS, Rizo Isrofov <irm@odisproject.com>
# 	All rights reserved.
#
#	Redistribution and use in source and binary forms, with or without
#	modification, are permitted provided that the following conditions are met:
#		* Redistributions of source code must retain the above copyright notice,
#		this list of conditions and the following disclaimer.
#		* Redistributions in binary form must reproduce the above copyright
#		notice, this list of conditions and the following disclaimer in the
#		documentation and/or other materials provided with the distribution.
#		* Neither the name of the ODIS nor the names of its contributors may be
#		used to endorse or promote products derived from this software without
#		specific prior written permission.
#
#	THIS SOFTWARE IS PROVIDED BY ODIS ''AS IS'' AND ANY EXPRESS OR IMPLIED
#	WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#	MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
#	IN NO EVENT SHALL ODIS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#	SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
#	TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
#	PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
#	LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
#	NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

cmake_minimum_required(VERSION 2.6)

# Project settings
project(WDI)
set(WDI "wdi")
set(Pedantic 1)

# Project directories
set(WDI_SRC_DIR "Source/")
set(WDI_TST_DIR "Tests/")

# Default installation path
set(WDI_LIB_DIR "lib/${WDI}")
set(WDI_INC_DIR "include/${WDI}")

# Filename patterns
set(WDI_SOURCE_FILES "*.c" "*.c++")
set(WDI_HEADER_FILES "*.h" "*.h++")

# Set cmake module path
set(CMAKE_MODULE_PATH
	${CMAKE_MODULE_PATH}${CMAKE_SOURCE_DIR}/CMake/Modules/)

include(Version)
include(Pedantic)

add_subdirectory(${WDI_SRC_DIR})

# WDI tests
#add_subdirectory(${WDI_TST_DIR})