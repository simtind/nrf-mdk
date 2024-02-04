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
# Find GCC toolchain                         #
##############################################
if ("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "arm")
    set(GCC_PREFIXES ";arm-none-eabi")
elseif ("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "riscv")
    set(GCC_PREFIXES ";riscv64-unknown-elf;riscv32-unknown-elf")
else()
    message(FATAL_ERROR "Unsupported processor architecture" ${CMAKE_SYSTEM_PROCESSOR})
endif()

foreach(prefix ${GCC_PREFIXES})
    find_program(GCC_C_COMPILER     ${prefix}-gcc)
    find_program(GCC_CXX_COMPILER   ${prefix}-g++)
    find_program(GCC_ASM_COMPILER   ${prefix}-gcc)
    find_program(GCC_LINKER         ${prefix}-gcc)
    find_program(GCC_OBJCOPY        ${prefix}-objcopy)
    find_program(GCC_SIZE           ${prefix}-size)

    if (GCC_C_COMPILER AND GCC_CXX_COMPILER AND GCC_ASM_COMPILER AND GCC_LINKER)
        set(GCC_PREFIX ${prefix})
        break()
    endif ()
endforeach()

if (NOT (GCC_C_COMPILER AND GCC_ASM_COMPILER AND GCC_LINKER))
    message(FATAL_ERROR "Could not find GCC toolchain.")
endif ()

##############################################
# Select GCC toolchain                       #
##############################################
set(CMAKE_ASM_COMPILER              ${GCC_ASM_COMPILER})
set(CMAKE_C_COMPILER                ${GCC_C_COMPILER})
set(CMAKE_CXX_COMPILER              ${GCC_CXX_COMPILER})
set(CMAKE_LINKER                    ${GCC_LINKER})

if ("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "arm")
    set(CMAKE_C_COMPILER_TARGET         "arm-arm-none-eabi")
    SET(CMAKE_CXX_COMPILER_TARGET       "arm-arm-none-eabi")
    SET(CMAKE_ASM_COMPILER_TARGET       "arm-arm-none-eabi")
elseif ("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "riscv")
    set(CMAKE_C_COMPILER_TARGET         "riscv32-riscv32-none-elf")
    SET(CMAKE_CXX_COMPILER_TARGET       "riscv32-riscv32-none-elf")
    SET(CMAKE_ASM_COMPILER_TARGET       "riscv32-riscv32-none-elf")
else()
    message(FATAL_ERROR "Unsupported processor architecture " ${CMAKE_SYSTEM_PROCESSOR})
endif()

##############################################
# Find compiler CPU flags                    #
##############################################
if ("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "arm")
    set(GCC_CPU_SUPPORTS_NOFP  "cortex-m4;cortex-m33")
    set(GCC_CPU_SUPPORTS_NODSP ";cortex-m33")
    string(TOLOWER "${MDK_TARGET_PROCESSOR}" GCC_CPU_FLAG)
    if (MDK_TARGET_DSP_IMPLEMENTED STREQUAL "NO" AND MDK_TARGET_PROCESSOR IN_LIST GCC_CPU_SUPPORTS_NODSP)
        string(APPEND GCC_CPU_FLAG "+nodsp")
    endif()
    if (MDK_TARGET_FPU_IMPLEMENTED STREQUAL "NO" AND  MDK_TARGET_PROCESSOR IN_LIST GCC_CPU_SUPPORTS_NOFP)
        string(APPEND GCC_CPU_FLAG "+nofp")
    endif()
    set(cpu_flags  "-mthumb -mcpu=${GCC_CPU_FLAG}")
elseif ("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "riscv")
    set(cpu_flags  "-march=${MDK_TARGET_RISCV_ARCH} -mabi=ilp32e")
else()
    message(FATAL_ERROR "Unsupported processor architecture " ${CMAKE_SYSTEM_PROCESSOR})
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
# Set initial compiler settings              #
##############################################
set(data_flags    "-ffunction-sections -fdata-sections -fno-strict-aliasing -fno-builtin --short-enums")
set(warning_flags "-Wall -Wno-attributes -Wno-format")
set(linker_flags  "--specs=nosys.specs -Wl,--gc-sections -Wl,-Map,${CMAKE_CURRENT_BINARY_DIR}/out.map")

set(CMAKE_C_FLAGS_INIT "${warning_flags} ${data_flags} ${cpu_flags} ${fpu_flags}")
set(CMAKE_C_FLAGS_DEBUG_INIT          "-Og -g3")
set(CMAKE_C_FLAGS_MINSIZEREL_INIT     "-Os -g")
set(CMAKE_C_FLAGS_RELWITHDEBINFO_INIT "-O3 -g" )
set(CMAKE_C_FLAGS_RELEASE_INIT        "-O3 -DNDEBUG")

set(CMAKE_CXX_FLAGS_INIT "${warning_flags} ${data_flags} ${cpu_flags} ${fpu_flags}")
set(CMAKE_CXX_FLAGS_DEBUG_INIT          "-Og -g3")
set(CMAKE_CXX_FLAGS_MINSIZEREL_INIT     "-Os -g")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT "-O3 -g" )
set(CMAKE_CXX_FLAGS_RELEASE_INIT        "-O3 -DNDEBUG")

set(CMAKE_ASM_FLAGS_INIT "${warning_flags} ${data_flags} ${cpu_flags} ${fpu_flags}")
set(CMAKE_ASM_FLAGS_DEBUG_INIT          "-Og -g3")
set(CMAKE_ASM_FLAGS_MINSIZEREL_INIT     "-Os -g")
set(CMAKE_ASM_FLAGS_RELWITHDEBINFO_INIT "-O3 -g" )
set(CMAKE_ASM_FLAGS_RELEASE_INIT        "-O3 -DNDEBUG")

set(CMAKE_EXE_LINKER_FLAGS_INIT         "${linker_flags} ${cpu_flags} ${fpu_flags}")

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


if (CMAKE_INTERPROCEDURAL_OPTIMIZATION)
    message(WARNING
        "CMAKE_INTERPROCEDURAL_OPTIMIZATION enables -flto with GCC which can lead to unexpected behavior. "
        "One particular problem is that the interrupt vector table can be messed up if the startup file "
        "isn't the first source file of the target. In general weak symbols tend to cause problems.\n"
        "More information https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83967. "
        )
endif (CMAKE_INTERPROCEDURAL_OPTIMIZATION)