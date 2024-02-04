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

cmake_minimum_required(VERSION 3.6)

message(STATUS "Configuring CMake for MDK Project")

# By default, CMSIS core will be downloaded from github. 
# To provide your own copy, set CMSIS_DIR to point to the root of your cmsis package.

# By default, the MDK will be searched for at ${CMAKE_SOURCE_DIR}/mdk
# If the path to your install is different to this, set MDK_DIR to point to the install root.
if(NOT DEFINED MDK_DIR)
    set(MDK_DIR "${CMAKE_SOURCE_DIR}/mdk")
endif()

find_package(MDK REQUIRED HINTS ${MDK_DIR}/cmake/modules)

if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
    set(CMAKE_TOOLCHAIN_FILE ${MDK_TOOLCHAIN_FILE})
endif()

project(MDK_EXAMPLE LANGUAGES C CXX ASM)

# Get global settings from MDK
include_directories(${MDK_DIR_INCLUDES})
add_compile_definitions(${MDK_DEFINITIONS})

add_executable(exe main.c)

target_link_libraries(exe PUBLIC ${MDK_LIBRARIES})
set_linker_script(exe ${MDK_SOURCE_LINKER_SCRIPT})

create_hex(exe)