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

##############################################
# Set working directory paths.               #
##############################################
find_path(MDK_DIR_ROOT include/nrf.h HINTS ${MDK_DIR} ${CMAKE_CURRENT_LIST_DIR}/../..)
include("${MDK_DIR_ROOT}/cmake/paths.cmake")

##############################################
# Utility libraries.                         #
##############################################


include(FindPackageHandleStandardArgs)

include(CMakeDependentOption)
include(${MDK_DIR_CMAKE}/mdkDependentOptionList.cmake)
include(${MDK_DIR_CMAKE}/target.cmake)

##############################################
# MDK version data                           #
##############################################
file(READ ${MDK_DIR_ROOT}/include/nrf.h nrf_h)

string(REGEX MATCH "#define MDK_MAJOR_VERSION *([0-9]*)" _ ${nrf_h})
set(MDK_VERSION_MAJOR ${CMAKE_MATCH_1})
string(REGEX MATCH "#define MDK_MINOR_VERSION *([0-9]*)" _ ${nrf_h})
set(MDK_VERSION_MINOR ${CMAKE_MATCH_1})
string(REGEX MATCH "#define MDK_MICRO_VERSION *([0-9]*)" _ ${nrf_h})
set(MDK_VERSION_BUGFIX ${CMAKE_MATCH_1})

set(MDK_VERSION_STRING "${MDK_VERSION_MAJOR}.${MDK_VERSION_MINOR}.${MDK_VERSION_BUGFIX}")

message(DEBUG "Configuring CMake for nRF MDK ${MDK_VERSION_STRING}")

##############################################
# Create MDK Source Library                  #
##############################################

add_library(nRFMDK INTERFACE)

if (MDK_TOOLCHAIN MATCHES "arm.*")
    set(MDK_DEFAULT_LINKER_SCRIPT ${MDK_TARGET_SOURCE_SCATTER_FILE})
else()
    set(MDK_DEFAULT_LINKER_SCRIPT ${MDK_TARGET_SOURCE_LINKER_SCRIPT})
endif()

# Find source and include files
find_file(MDK_SOURCE_STARTUP ${MDK_TARGET_SOURCE_STARTUP} HINT ${MDK_DIR_SOURCE})
find_file(MDK_SOURCE_SYSTEM ${MDK_TARGET_SOURCE_SYSTEM} HINT ${MDK_DIR_SOURCE})
find_file(MDK_SOURCE_LINKER_SCRIPT ${MDK_DEFAULT_LINKER_SCRIPT} HINT ${MDK_DIR_SCRIPT})

set(MDK_TOOLCHAIN_FILE ${MDK_DIR_CMAKE}/toolchain.cmake CACHE STRING "NRF MDK Toolchain file")

message(DEBUG "MDK_SOURCE_SYSTEM  = ${MDK_SOURCE_SYSTEM}")
message(DEBUG "MDK_SOURCE_STARTUP = ${MDK_SOURCE_STARTUP}")
message(DEBUG "MDK_SOURCE_LINKER  = ${MDK_SOURCE_LINKER_SCRIPT}")

# Load MDK source files
target_sources(nRFMDK INTERFACE ${MDK_SOURCE_STARTUP} ${MDK_SOURCE_SYSTEM})

# Print a message indicating the target we're compiling for
message(DEBUG "Compiling for SOC='${MDK_TARGET_SOC}'")
if ( MDK_TARGET_CORE_VALUES )
    message(DEBUG "             CORE='${MDK_TARGET_CORE}'")
endif ()

# Set include directories
target_include_directories(nRFMDK INTERFACE ${MDK_DIR_INCLUDE})

if (${MDK_TOOLCHAIN} MATCHES "gcc|clang|armclang")
    set(MDK_NEEDS_SBRK ON)
endif()

# Set device options
cmake_dependent_option(MDK_OPT_ENABLE_SWO                   "Enable SWO at startup"                         OFF "MDK_TARGET_SWO_IMPLEMENTED"                    OFF)
cmake_dependent_option(MDK_OPT_ENABLE_TRACE                 "Enable instruction trace at startup"           OFF "MDK_TARGET_TRACE_IMPLEMENTED"                  OFF)
cmake_dependent_option(MDK_OPT_CONFIG_NFCT_PINS_AS_GPIOS    "Configure NFC output pins to be regular GPIO." ON  "MDK_TARGET_CONFIGURABLENFCPINS_IMPLEMENTED"    OFF)
cmake_dependent_option(MDK_OPT_CONFIG_GPIO_AS_PINRESET      "Enable pin reset"                              OFF "MDK_TARGET_CONFIGURABLEPINRESET_IMPLEMENTED"   OFF)
cmake_dependent_option(MDK_OPT_BUILD_TZ_SECURE              "Compile for secure trustzone execution"        OFF "MDK_TARGET_TRUSTZONE_IMPLEMENTED"              OFF)
cmake_dependent_option(MDK_OPT_BUILD_TZ_NONSECURE           "Compile for nonsecure trustzone execution"     OFF "MDK_TARGET_TRUSTZONE_IMPLEMENTED"              OFF)
cmake_dependent_option(MDK_OPT_SBRK_WITH_HEAP_LIMIT         "Enable newlib heap limiting"                   ON  "MDK_NEEDS_SBRK"                                OFF)

mdk_dependent_option_list(MDK_OPT_BUILD_TZ "What Trust Zone context to build for" "No;Secure;NonSecure" "${MDK_TARGET_TRUSTZONE_IMPLEMENTED}" "No")

# Set link options and preprocessor macros for optional features.
if (MDK_OPT_BUILD_TZ_SECURE)
    target_compile_options(nRFMDK INTERFACE -mcmse)
    target_link_options(nRFMDK INTERFACE -mcmse )
    list(APPEND MDK_TARGET_MACROS NRF_TRUSTZONE_SECURE)
elseif (MDK_OPT_BUILD_TZ_NONSECURE)
    list(APPEND MDK_TARGET_MACROS NRF_TRUSTZONE_NONSECURE)
endif()

if (MDK_OPT_ENABLE_SWO_ENABLED)
    list(APPEND MDK_TARGET_MACROS ENABLE_SWO)
endif()
if (MDK_OPT_ENABLE_TRACE_ENABLED)
    list(APPEND MDK_TARGET_MACROS ENABLE_TRACE)
endif()
if (MDK_OPT_CONFIG_NFCT_PINS_AS_GPIOS_ENABLED)
    list(APPEND MDK_TARGET_MACROS CONFIG_NFCT_PINS_AS_GPIOS)
endif()
if (MDK_OPT_CONFIG_GPIO_AS_PINRESET_ENABLED)
    list(APPEND MDK_TARGET_MACROS CONFIG_GPIO_AS_PINRESET)
endif()
if (MDK_OPT_SBRK_WITH_HEAP_LIMIT_ENABLED)
    list(APPEND MDK_TARGET_MACROS NRF_ENABLE_HEAP_LIMIT)
endif()


# Set preprocessor macros
target_compile_definitions(nRFMDK INTERFACE ${MDK_TARGET_MACROS})

##############################################
# Create MDK Package                         #
##############################################

find_package(CMSIS_CORE REQUIRED HINTS ${CMAKE_CURRENT_LIST_DIR} ${CMSIS_DIR})

find_package_handle_standard_args(
    MDK
        REQUIRED_VARS MDK_DIR_ROOT MDK_DIR_INCLUDE MDK_SOURCE_STARTUP MDK_SOURCE_SYSTEM MDK_TARGET_MACROS
        VERSION_VAR MDK_VERSION_STRING
    )

if(MDK_FOUND)
    set(MDK_LIBRARIES nRFMDK CACHE STRING "NRF MDK startup library")
    set(MDK_DIR_INCLUDES ${MDK_DIR_INCLUDE} ${CMSIS_CORE_INCLUDE_DIRS} CACHE STRING "NRF MDK include paths")
    set(MDK_DEFINITIONS  ${MDK_TARGET_MACROS} CACHE STRING "NRF MDK Compiler definitions")
    mark_as_advanced(MDK_DIR_INCLUDE MDK_TOOLCHAIN_FILE MDK_DIR MDK_DEFINITIONS MDK_LIBRARIES)
else()
    set(MDK_DIR "" CACHE PATH "An optional hint to a directory for finding `MDK`")
endif()