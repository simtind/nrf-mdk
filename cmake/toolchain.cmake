# Copyright (c) 2010 - 2024, Nordic Semiconductor ASA All rights reserved.
# 
# SPDX-License-Identifier: BSD-3-Clause
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 
# 3. Neither the name of Nordic Semiconductor ASA nor the names of its
#    contributors may be used to endorse or promote products derived from this
#    software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL NORDIC SEMICONDUCTOR ASA OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

# default max_path length is 260.  Ninja fails if >245 chars.  This option lets cmake use tricks to shrink the path.
if( NOT CMAKE_HOST_UNIX)
  set(CMAKE_OBJECT_PATH_MAX 240)
endif()

##############################################
# Set general settings                       #
##############################################

if (NOT CMAKE_VERSION VERSION_LESS 3.9)
    # Allow user to enable CMAKE_INTERPROCEDURAL_OPTIMIZATION (LTO) if supported for the toolchain.
    # This is supported from CMake version 9 and later.
    cmake_policy(SET CMP0069 NEW)
endif ()

##############################################
# Set working directory paths                #
##############################################

file(RELATIVE_PATH MDK_DIR_ROOT_Temp ${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_LIST_DIR}/..)
set(MDK_DIR_ROOT "${CMAKE_SOURCE_DIR}/${MDK_DIR_ROOT_Temp}" CACHE PATH "Path to MDK package")
include("${MDK_DIR_ROOT}/cmake/paths.cmake")

##############################################
# Set build and detection settings           #
##############################################

list(APPEND CMAKE_MODULE_PATH ${MDK_DIR_MODULES})

set(CMAKE_CROSSCOMPILING            TRUE)
set(CMAKE_SYSTEM_NAME               Generic)
set(CMAKE_TRY_COMPILE_TARGET_TYPE   STATIC_LIBRARY)

set(BUILD_SHARED_LIBS OFF)
set(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS "")
set(CMAKE_EXECUTABLE_SUFFIX ".elf")
# Export compilation commands to .json file (used by clang-complete backends)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(MDK_TOOLCHAIN "gcc" CACHE STRING "Toolchain used for compiling the target")
set_property(CACHE MDK_TOOLCHAIN PROPERTY STRINGS "gcc" "armcc" "armclang" "clang")

list(APPEND CMAKE_TRY_COMPILE_PLATFORM_VARIABLES
            MDK_TOOLCHAIN
            MDK_TARGET_SOC
            MDK_TARGET_CORE)

##############################################
# Get target properties                      #
##############################################

include("${MDK_DIR_CMAKE}/target.cmake")

##############################################
# Load toolchain data                       #
##############################################

if (EXISTS "${MDK_DIR_TOOLCHAIN}/${MDK_TOOLCHAIN}.cmake")
    message(STATUS "Loading file '${MDK_DIR_TOOLCHAIN}/${MDK_TOOLCHAIN}.cmake'")
    include("${MDK_DIR_TOOLCHAIN}/${MDK_TOOLCHAIN}.cmake")
else ()
    message(FATAL_ERROR "Toolchain \"${MDK_TOOLCHAIN}\" not recognized.")
endif ()

##############################################
# Add VCPKG if installed                     #
##############################################

if(DEFINED ENV{VCPKG_ROOT} AND NOT DEFINED MDK_NO_VCPKG)
  set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake"
      CACHE STRING "")
endif()