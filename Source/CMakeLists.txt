#	*Web Development Interface*
#	[Source/CMakeLists.txt]
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

include_directories(${WDI_SRC_DIR})

# Implementation files
file(GLOB WDI_SOURCES ${WDI_SOURCE_FILES})

# Header files
file(GLOB WDI_HEADERS ${WDI_HEADER_FILES})


# Create WDI shared library
add_library(wdi SHARED ${WDI_SOURCES} ${WDI_HEADERS})

# Set WDI library version
set_target_properties(
	wdi PROPERTIES
	VERSION ${WDI_VERSION}
	SOVERSION ${WDI_VERSION_MAJOR})

# Install WDI library
install(
	TARGETS wdi
	LIBRARY DESTINATION ${WDI_LIB_DIR})


# Install WDI headers
install(
	FILES ${WDI_HEADERS}
	DESTINATION ${WDI_INC_DIR})

# Qt-style headers
install(
	DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/
	DESTINATION ${WDI_INC_DIR}
	FILES_MATCHING PATTERN W*)

add_subdirectory("Processor")