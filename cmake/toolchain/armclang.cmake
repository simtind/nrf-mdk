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

# In newer versions of CMake, we'll set all armclang compile settings ourselves.
cmake_policy(SET CMP0123 NEW)

##############################################
# Find ARMClang toolchain                    #
##############################################
IF (WIN32)
    set(DEFAULT_KEIL_PATH "C:/Keil_v5/ARM/ARMCLANG/bin")
else()
    set(DEFAULT_KEIL_PATH "")
endif()

find_program(ARMCLANG_C_COMPILER armclang   PATHS "${DEFAULT_KEIL_PATH}" ENV PATH NO_DEFAULT_PATH)
find_program(ARMCLANG_LINKER armlink        PATHS "${DEFAULT_KEIL_PATH}" ENV PATH NO_DEFAULT_PATH)
find_program(ARMCLANG_FROMELF fromelf       PATHS "${DEFAULT_KEIL_PATH}" ENV PATH NO_DEFAULT_PATH)

if (NOT (ARMCLANG_C_COMPILER AND ARMCLANG_LINKER))
    message(FATAL_ERROR "Could not find ARMCLANG toolchain.")
endif ()

if (NOT "${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "arm")
    message(FATAL_ERROR "ARMCLang only supports ARM targets.")
endif()

##############################################
# Select ARMCLANG toolchain                  #
##############################################
set(CMAKE_C_COMPILER                ${ARMCLANG_C_COMPILER})
set(CMAKE_CXX_COMPILER              ${ARMCLANG_C_COMPILER})
set(CMAKE_ASM_COMPILER              ${ARMCLANG_C_COMPILER})
set(CMAKE_LINKER                    ${ARMCLANG_LINKER})

set(CMAKE_COMPILER_TARGET          "arm-arm-none-eabi")
string(TOLOWER "${MDK_TARGET_PROCESSOR}" CMAKE_SYSTEM_PROCESSOR)

##############################################
# Find compiler CPU flags                    #
##############################################
string(TOLOWER "${MDK_TARGET_PROCESSOR}" CLANG_CPU_FLAG)
string(TOLOWER "${MDK_TARGET_PROCESSOR}" LEGACY_CPU_FLAG)
set(CLANG_CPU_SUPPORTS_NOFP  "cortex-m4;cortex-m33")
set(CLANG_CPU_SUPPORTS_NODSP ";cortex-m33")
if (MDK_TARGET_DSP_IMPLEMENTED STREQUAL "NO" AND MDK_TARGET_PROCESSOR IN_LIST CLANG_CPU_SUPPORTS_NODSP)
    string(APPEND CLANG_CPU_FLAG  "+nodsp")
    string(APPEND LEGACY_CPU_FLAG ".no_dsp")
endif()
if (MDK_TARGET_FPU_IMPLEMENTED STREQUAL "NO" AND MDK_TARGET_PROCESSOR IN_LIST CLANG_CPU_SUPPORTS_NOFP)
    string(APPEND LEGACY_CPU_FLAG ".no_fp")
endif()

set(fpu_flags "-mfpu=none")
if (MDK_TARGET_FPU_IMPLEMENTED)
    if (MDK_TARGET_PROCESSOR STREQUAL "cortex-m4")
        set(CLANG_FPU_FLAG "fpv4-sp-d16")
    elseif (MDK_TARGET_PROCESSOR STREQUAL "cortex-m33")
        set(CLANG_FPU_FLAG "fpv5-sp-d16")
    else()
        message(FATAL_ERROR "Processor is not known to implement an FPU in a nordic device." ${MDK_TARGET_PROCESSOR})
    endif()
    set(fpu_flags        "-mfloat-abi=${MDK_TARGET_FPU_ABI} -mfpu=${CLANG_FPU_FLAG}")
endif()

##############################################
# Work around bugs in ARMClang support       #
##############################################
set(CMAKE_USER_MAKE_RULES_OVERRIDE "${MDK_DIR_TOOLCHAIN}/armclang_override.cmake")

##############################################
# Set initial compiler settings              #
##############################################
set(data_flags    "-ffunction-sections -fdata-sections -fno-strict-aliasing -fno-builtin -fshort-enums")
set(warning_flags "-Wall -Wno-attributes -Wno-format")
set(target_flags  "-mthumb -mcpu=${CLANG_CPU_FLAG} --target=${CMAKE_COMPILER_TARGET}")
set(linker_flags  "--cpu=${LEGACY_CPU_FLAG} --map --xref --summary_stderr --info=summarysizes --info=stack --callgraph --symbols --info=sizes --info=totals --info=unused --info=veneers ")
# 6304: Suppress the "duplicate input" warning caused by circular linking by CMake
# 6330: Supress undefined symbol warning
set(linker_errors "--diag_suppress=6304,6330 ")

set(CMAKE_C_FLAGS_INIT                  "${warning_flags} ${data_flags} ${target_flags} ${fpu_flags}")
set(CMAKE_C_FLAGS_DEBUG_INIT            "-Og -g3")
set(CMAKE_C_FLAGS_MINSIZEREL_INIT       "-Os -g")
set(CMAKE_C_FLAGS_RELWITHDEBINFO_INIT   "-O3 -g" )
set(CMAKE_C_FLAGS_RELEASE_INIT          "-O3 -DNDEBUG")
set(CMAKE_C_STANDARD_DEFAULT            "99")

set(CMAKE_CXX_FLAGS_INIT                "${warning_flags} ${data_flags} ${target_flags} ${fpu_flags}")
set(CMAKE_CXX_FLAGS_DEBUG_INIT          "-Og -g3")
set(CMAKE_CXX_FLAGS_MINSIZEREL_INIT     "-Os -g")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT "-O3 -g" )
set(CMAKE_CXX_FLAGS_RELEASE_INIT        "-O3 -DNDEBUG")
set(CMAKE_CXX_STANDARD_DEFAULT          "11")

set(CMAKE_ASM_FLAGS_INIT                  "${warning_flags} ${data_flags} ${target_flags} ${fpu_flags}")
set(CMAKE_ASM_FLAGS_DEBUG_INIT            "-Og -g3")
set(CMAKE_ASM_FLAGS_MINSIZEREL_INIT       "-Os -g")
set(CMAKE_ASM_FLAGS_RELWITHDEBINFO_INIT   "-O3 -g" )
set(CMAKE_ASM_FLAGS_RELEASE_INIT          "-O3 -DNDEBUG")

set(CMAKE_EXE_LINKER_FLAGS_INIT         "${linker_flags} ${linker_errors}")

set(CMAKE_EXECUTABLE_SUFFIX ".elf")

##############################################
# Enable optional Microlib standard library  #
##############################################
option(MDK_ARMCC_ENABLE_MICROLIB ON "Enable the ARM microlib?")
if (MDK_ARMCC_ENABLE_MICROLIB)
    string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " --library_type=microlib")
endif()

##############################################
# Provide toolchain-specific functions       #
##############################################
function (set_linker_script target_name linker_script)
    target_link_options(${target_name} PUBLIC --scatter "${linker_script}")
endfunction (set_linker_script)

# Generate hex file from build result
# Arguments:
# target: Cmake target to create hex file for
# Optional arguments:
# hex_name: Override name of output hex file
function (create_hex target)
    include(${MDK_DIR_TOOLCHAIN}/get_target_paths.cmake)
    get_target_paths(${target} ${ARGN})
    add_custom_command(
        TARGET ${target}
        POST_BUILD
        COMMAND ${ARMCLANG_FROMELF} --i32combined -o ${hex_file} ${source_file}
        BYPRODUCTS ${hex_file})
endfunction(create_hex)
