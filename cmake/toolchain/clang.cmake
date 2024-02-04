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
# Find GCC toolchain for sysroot libraries   #
##############################################
if ("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "arm")
    set(GCC_PREFIXES ";arm-none-eabi")
elseif ("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "riscv")
    message(FATAL_ERROR "Clang does not currently support the RV32e processor architecture.")
    # Rest of RISC-V code is added for reference only.
    set(GCC_PREFIXES ";riscv64-unknown-elf;riscv32-unknown-elf")
else()
    message(FATAL_ERROR "Unsupported processor architecture" ${CMAKE_SYSTEM_PROCESSOR})
endif()

foreach(prefix ${GCC_PREFIXES})
    find_program(GCC_C_COMPILER     ${prefix}-gcc)
    find_program(GCC_OBJCOPY        ${prefix}-objcopy)
    find_program(GCC_SIZE           ${prefix}-size)

    if (GCC_C_COMPILER)
        set(GCC_PREFIX ${prefix})
        break()
    endif ()
endforeach()

# GCC_C_COMPILER must be passed to try-compile in case it's not detectable
list(APPEND CMAKE_TRY_COMPILE_PLATFORM_VARIABLES GCC_C_COMPILER)

if(NOT (GCC_C_COMPILER AND GCC_OBJCOPY AND GCC_SIZE))
  message(FATAL_ERROR "\nA GCC installation path has to be detected for Clang to work."
                      "\nPlease make sure an installation of arm-none-eabi-gcc, riscv32-none-elf-gcc,"
                      "\nor riscv64-none-elf-gcc is discoverable in PATH,"
                      "\nor specify -DGCC_C_COMPILER=<path> during CMake invocation.\n")
endif()

##############################################
# Select Clang/LLVM toolchain                #
##############################################
find_program(CLANG_C_COMPILER       "clang"   HINTS ${CLANG_BIN_DIR})
find_program(CLANG_CXX_COMPILER     "clang++" HINTS ${CLANG_BIN_DIR})

if (NOT CLANG_C_COMPILER AND CLANG_CXX_COMPILER)
    message(FATAL_ERROR "Could not find clang. Try settting CLANG_BIN_DIR to point to the llvm bin directory")
    set(CLANG_BIN_DIR "" CACHE PATH "An optional hint to a directory for finding a clang / llvm toolchain")
endif()

set(CMAKE_ASM_COMPILER              "${CLANG_C_COMPILER}")
set(CMAKE_C_COMPILER                "${CLANG_C_COMPILER}")
set(CMAKE_CXX_COMPILER              "${CLANG_CXX_COMPILER}")
set(CMAKE_LINKER                    "${GCC_C_COMPILER}") # Clang may not be compiled with the right prefix handling

if ("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "arm")
    set(CMAKE_C_COMPILER_TARGET         "arm-arm-none-eabi")
    set(CMAKE_CXX_COMPILER_TARGET       "arm-arm-none-eabi")
    set(CMAKE_ASM_COMPILER_TARGET       "arm-arm-none-eabi")
elseif ("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "riscv")
    set(CMAKE_C_COMPILER_TARGET         "riscv32-riscv32-none-elf")
    set(CMAKE_CXX_COMPILER_TARGET       "riscv32-riscv32-none-elf")
    set(CMAKE_ASM_COMPILER_TARGET       "riscv32-riscv32-none-elf")
else()
    message(FATAL_ERROR "Unsupported processor architecture" ${CMAKE_SYSTEM_PROCESSOR})
endif()

##############################################
# Find compiler CPU flags                    #
##############################################
if ("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "arm")
    set(CLANG_CPU_SUPPORTS_NOFP  "cortex-m4;cortex-m33")
    set(CLANG_CPU_SUPPORTS_NODSP ";cortex-m33")
    string(TOLOWER "${MDK_TARGET_PROCESSOR}" CLANG_CPU_FLAG)
    if (MDK_TARGET_DSP_IMPLEMENTED STREQUAL "NO" AND MDK_TARGET_PROCESSOR IN_LIST CLANG_CPU_SUPPORTS_NODSP)
        string(APPEND CLANG_CPU_FLAG "+nodsp")
    endif()
    if (MDK_TARGET_FPU_IMPLEMENTED STREQUAL "NO" AND  MDK_TARGET_PROCESSOR IN_LIST CLANG_CPU_SUPPORTS_NOFP)
        string(APPEND CLANG_CPU_FLAG "+nofp")
    endif()
    set(cpu_flags  "-mthumb -mcpu=${CLANG_CPU_FLAG}")
elseif ("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "riscv")
    set(cpu_flags  "-march=${MDK_TARGET_RISCV_ARCH} -mabi=ilp32e")
else()
    message(FATAL_ERROR "Unsupported processor architecture" ${CMAKE_SYSTEM_PROCESSOR})
endif()

set(fpu_flags "")
if (MDK_TARGET_FPU_IMPLEMENTED)
    if ("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "riscv")
        message(FATAL_ERROR "FPU not supported on RISC-V processor architecture")
    endif()

    if (MDK_TARGET_PROCESSOR STREQUAL "cortex-m4")
        set(GCC_FPU_FLAG "fpv4-sp-d16")
    elseif (MDK_TARGET_PROCESSOR STREQUAL "cortex-m33")
        set(GCC_FPU_FLAG "fpv5-sp-d16")
    else()
        message(FATAL_ERROR "CPU does not implement an FPU in nordic devices.")
    endif()
    set(fpu_flags     "-mfloat-abi=${MDK_TARGET_FPU_ABI} -mfpu=${GCC_FPU_FLAG}")
endif()

##############################################
# Find GCC system libraries                  #
##############################################
if ("${CLANG_SYSROOT}" STREQUAL "")
    set(CLANG_ARGS "-print-sysroot ${cpu_flags} ${fpu_flags}")
    string(REPLACE " " ";" CLANG_ARGS ${CLANG_ARGS})
    execute_process(COMMAND "${GCC_C_COMPILER}" ${CLANG_ARGS}
                    OUTPUT_VARIABLE CLANG_SYSROOT
                    ERROR_VARIABLE CLANG_SYSROOT
                    OUTPUT_STRIP_TRAILING_WHITESPACE
                    ERROR_STRIP_TRAILING_WHITESPACE)
    message(STATUS "CLANG_SYSROOT == \"${CLANG_SYSROOT}\"")
endif()
if ("${CLANG_NEWLIB_LIBRARY}" STREQUAL "")
    set(CLANG_ARGS "-print-libgcc-file-name ${cpu_flags} ${fpu_flags}")
    string(REPLACE " " ";" CLANG_ARGS ${CLANG_ARGS})
    execute_process(COMMAND "${GCC_C_COMPILER}" ${CLANG_ARGS}
                    OUTPUT_VARIABLE CLANG_NEWLIB_LIBRARY
                    ERROR_VARIABLE CLANG_NEWLIB_LIBRARY
                    OUTPUT_STRIP_TRAILING_WHITESPACE
                    ERROR_STRIP_TRAILING_WHITESPACE)
endif()

if (NOT "${CLANG_SYSROOT}" STREQUAL "")
    set(CMAKE_SYSROOT "${CLANG_SYSROOT}")
endif()

if (NOT "${CLANG_NEWLIB_LIBRARY}" STREQUAL "")
    link_libraries(${CLANG_NEWLIB_LIBRARY})
endif()

##############################################
# Set initial compiler settings              #
##############################################
set(data_flags    "-ffunction-sections -fdata-sections -fno-strict-aliasing -fno-builtin -fshort-enums")
set(warning_flags "-Wall -Wno-attributes -Wno-format")
set(target_flag   "--target=${CMAKE_C_COMPILER_TARGET}")
set(linker_flags  "--specs=nosys.specs -Wl,--gc-sections -Wl,-Map,${CMAKE_CURRENT_BINARY_DIR}/out.map")

set(CMAKE_C_FLAGS_INIT "${warning_flags} ${data_flags} ${cpu_flags} ${fpu_flags} ${target_flag}")
set(CMAKE_C_FLAGS_DEBUG_INIT          "-Og -g3")
set(CMAKE_C_FLAGS_MINSIZEREL_INIT     "-Os -g")
set(CMAKE_C_FLAGS_RELWITHDEBINFO_INIT "-O3 -g" )
set(CMAKE_C_FLAGS_RELEASE_INIT        "-O3 -DNDEBUG")

set(CMAKE_CXX_FLAGS_INIT "${warning_flags} ${data_flags} ${cpu_flags} ${fpu_flags} ${target_flag}")
set(CMAKE_CXX_FLAGS_DEBUG_INIT          "-Og -g3")
set(CMAKE_CXX_FLAGS_MINSIZEREL_INIT     "-Os -g")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT "-O3 -g" )
set(CMAKE_CXX_FLAGS_RELEASE_INIT        "-O3 -DNDEBUG")

set(CMAKE_ASM_FLAGS_INIT "${warning_flags} ${data_flags} ${cpu_flags} ${fpu_flags} ${target_flag}")
set(CMAKE_ASM_FLAGS_DEBUG_INIT          "-Og -g3")
set(CMAKE_ASM_FLAGS_MINSIZEREL_INIT     "-Os -g")
set(CMAKE_ASM_FLAGS_RELWITHDEBINFO_INIT "-O3 -g" )
set(CMAKE_ASM_FLAGS_RELEASE_INIT        "-O3 -DNDEBUG")

set(CMAKE_EXE_LINKER_FLAGS_INIT         "${linker_flags} ${fpu_flags} ${cpu_flags}")

# Override default linker executable. Clang will not always find the right gcc executable, so we call gcc directly instead.
set(CMAKE_C_LINK_EXECUTABLE     "<CMAKE_LINKER> <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>")
set(CMAKE_CXX_LINK_EXECUTABLE   "<CMAKE_LINKER> <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>")
set(CMAKE_ASM_LINK_EXECUTABLE   "<CMAKE_LINKER> <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>")

##############################################
# Provide toolchain-specific functions       #
##############################################

function (set_linker_script target_name linker_script)
    get_filename_component(linker_script_dir ${linker_script} DIRECTORY)
    target_link_directories(${target_name} PUBLIC ${linker_script_dir})
    target_link_options(${target_name} PUBLIC LINKER:-T,${linker_script})
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
        COMMAND ${GCC_OBJCOPY} -O ihex ${source_file} ${hex_file}
        BYPRODUCTS ${hex_file})

    add_custom_command(
        TARGET ${target}
        POST_BUILD
        COMMAND ${GCC_SIZE} ${source_file})
endfunction(create_hex)

