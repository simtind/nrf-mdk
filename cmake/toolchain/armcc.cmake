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

##############################################
# Find ARMCC toolchain                       #
##############################################
set(DEFAULT_KEIL_PATH "C:/Keil_v5/ARM/ARMCC/bin")

find_program(ARMCC_C_COMPILER armcc     PATHS "${DEFAULT_KEIL_PATH}" ENV PATH NO_DEFAULT_PATH)
find_program(ARMCC_ASM_COMPILER armasm  PATHS "${DEFAULT_KEIL_PATH}" ENV PATH NO_DEFAULT_PATH)
find_program(ARMCC_LINKER armlink       PATHS "${DEFAULT_KEIL_PATH}" ENV PATH NO_DEFAULT_PATH)
find_program(ARMCC_FROMELF fromelf      PATHS "${DEFAULT_KEIL_PATH}" ENV PATH NO_DEFAULT_PATH)

if (NOT (ARMCC_C_COMPILER AND ARMCC_ASM_COMPILER AND ARMCC_LINKER))
    message(FATAL_ERROR "Could not find ARMCC toolchain.")
endif ()

if (NOT "${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "arm")
    message(FATAL_ERROR "ARMCC only supports ARM targets.")
endif()

function(__armcc_set_processor_list out_var)
  execute_process(COMMAND "${ARMCC_C_COMPILER}" --cpu=list
    OUTPUT_VARIABLE processor_list
    ERROR_VARIABLE processor_list)
  string(REGEX MATCHALL "--cpu=([^ \n]*)" processor_list "${processor_list}")
  string(REGEX REPLACE "--cpu=" "" processor_list "${processor_list}")
  string(TOLOWER "${processor_list}" processor_list)
  set(${out_var} "${processor_list}" PARENT_SCOPE)
endfunction()

__armcc_set_processor_list(ARMCC_SUPPORTS)
if (NOT MDK_TARGET_PROCESSOR IN_LIST ARMCC_SUPPORTS)
    message(FATAL_ERROR
"Unsupported Target CPU ${MDK_TARGET_PROCESSOR}.
    ARMCC supports the following targets:
        ${ARMCC_SUPPORTS}")
endif()

##############################################
# Select ARMCC toolchain                     #
##############################################
set(CMAKE_C_COMPILER                ${ARMCC_C_COMPILER})
set(CMAKE_CXX_COMPILER              ${ARMCC_C_COMPILER})
set(CMAKE_ASM_COMPILER              ${ARMCC_ASM_COMPILER})
set(CMAKE_LINKER                    ${ARMCC_LINKER})

##############################################
# Set C++ Standard flag                      #
##############################################
if (NOT CMAKE_CXX_STANDARD)
    set(CMAKE_CXX_STANDARD 11 CACHE STRING "")
endif()
if (CMAKE_CXX_STANDARD EQUAL 03)
    set(ARMCC_CXX_STANDARD_FLAG "--cpp")
elseif (CMAKE_CXX_STANDARD EQUAL 11)
    set(ARMCC_CXX_STANDARD_FLAG "--cpp11")
else ()
    message(FATAL_ERROR "Unsupported C++ version ${CMAKE_CXX_STANDARD} requested.")
endif()

##############################################
# Set C Standard flag                        #
##############################################
set(CMAKE_C_STANDARD 99 CACHE STRING "")
if (CMAKE_C_STANDARD EQUAL 90)
    set(ARMCC_C_STANDARD_FLAG "--c90")
elseif (CMAKE_C_STANDARD EQUAL 99)
    set(ARMCC_C_STANDARD_FLAG "--c99")
else ()
    message(FATAL_ERROR "Unsupported C version ${CMAKE_C_STANDARD} requested.")
endif()

##############################################
# Find compiler CPU flag                     #
##############################################
set(ARMCC_CPU_FLAG "${MDK_TARGET_PROCESSOR}")
if (MDK_TARGET_FPU_IMPLEMENTED)
    string(APPEND ARMCC_CPU_FLAG ".fp.sp")
endif()

##############################################
# Set initial compiler settings              #
##############################################
set(target_flags "--cpu=${ARMCC_CPU_FLAG}")
set(asm_flags    "--apcs=interwork  --predefine \"__HEAP_SIZE SETA ${MDK_HEAP_SIZE}\"")
set(linker_flags "--map --xref --summary_stderr --info summarysizes --info stack --callgraph --symbols --info sizes --info totals --info unused --info veneers")
# 6304: Suppress the "duplicate input" warning caused by circular linking by CMake
# 6330: Supress undefined symbol warning
set(linker_ignore_errors "--diag_suppress 6304,6330")

set(CMAKE_C_FLAGS_INIT                "${ARMCC_C_STANDARD_FLAG} ${target_flags}")
set(CMAKE_C_FLAGS_DEBUG_INIT          "-O1 --debug")
set(CMAKE_C_FLAGS_MINSIZEREL_INIT     "-Ospace --debug")
set(CMAKE_C_FLAGS_RELWITHDEBINFO_INIT "-O3 --debug" )
set(CMAKE_C_FLAGS_RELEASE_INIT        "-O3 --no_debug")

set(CMAKE_CXX_FLAGS_INIT                "${ARMCC_CXX_STANDARD_FLAG} ${target_flags}")
set(CMAKE_CXX_FLAGS_DEBUG_INIT          "-O1 --debug")
set(CMAKE_CXX_FLAGS_MINSIZEREL_INIT     "-Ospace --debug")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT "-O3 --debug" )
set(CMAKE_CXX_FLAGS_RELEASE_INIT        "-O3 --no_debug")

set(CMAKE_ASM_FLAGS_INIT                "${fpu_flags} ${target_flags} ${asm_flags}")

set(CMAKE_EXE_LINKER_FLAGS_INIT         "${linker_flags} ${linker_ignore_errors} ${target_flags}")

set(CMAKE_EXECUTABLE_SUFFIX ".elf")

##############################################
# Enable optional Microlib standard library  #
##############################################
option(MDK_ARMCC_ENABLE_MICROLIB ON "Enable the ARM microlib?")

if (MDK_ARMCC_ENABLE_MICROLIB)
    string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " --library_type=microlib")
    string(APPEND CMAKE_ASM_FLAGS_INIT        " --predefine \"__MICROLIB SETL {TRUE}\"")
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
        COMMAND ${ARMCC_FROMELF} --i32combined -o ${hex_file}.hex ${source_file}
        BYPRODUCTS ${hex_file})
endfunction(create_hex)