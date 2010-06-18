#	*Web Development Interface*
#	[CMake/Modules/Pedantic.cmake]
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

if (Pedantic)
    if (${CMAKE_COMPILER_IS_GNUCC} OR ${CMAKE_COMPILER_IS_GNUCXX})
        message(STATUS "Pedantic mode enabled for GCC compiler")
        add_definitions(-O2 -W -Wall -pedantic -Werror)
    else (${CMAKE_COMPILER_IS_GNUCC} OR ${CMAKE_COMPILER_IS_GNUCXX})
        message(STATUS "Unable to find a supported compiler")
    endif (${CMAKE_COMPILER_IS_GNUCC} OR ${CMAKE_COMPILER_IS_GNUCXX})
else (Pedantic)
    message(STATUS "Pedantic mode is NOT enabled")
endif (Pedantic)
