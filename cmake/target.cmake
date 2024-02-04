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

include("${MDK_DIR_CMAKE}/mdkDependentOptionList.cmake")

set(MDK_SUPPORTED_SOCS 
    nrf51422_xxaa
    nrf51422_xxab
    nrf51422_xxac
    nrf51801_xxab
    nrf51802_xxaa
    nrf51822_xxaa
    nrf51822_xxab
    nrf51822_xxac
    nrf51824_xxaa
    nrf52805_xxaa
    nrf52810_xxaa
    nrf52811_xxaa
    nrf52820_xxaa
    nrf52832_xxaa
    nrf52832_xxab
    nrf52833_xxaa
    nrf52840_xxaa
    nrf5340_xxaa
    nrf54h20_enga_xxaa
    nrf54h20_xxaa
    nrf54l15_enga_xxaa
    nrf9120_xxaa
    nrf9160_xxaa
)

# Set target SOC, can be any of the supported devices
mdk_option_list(MDK_TARGET_SOC "SOC to compile for" "${MDK_SUPPORTED_SOCS}")

# Use target SOC to load the corresponding properties.
if (NOT EXISTS "${MDK_DIR_TARGET}/${MDK_TARGET_SOC}.cmake")
    message(FATAL_ERROR "Device specific file ${MDK_DIR_TARGET}/${MDK_TARGET_SOC}.cmake for ${MDK_TARGET_SOC} not found.")
endif()

# Include the properties file for the SOC
message(STATUS "Loading file '${MDK_DIR_TARGET}/${MDK_TARGET_SOC}.cmake'")
include("${MDK_DIR_TARGET}/${MDK_TARGET_SOC}.cmake")

# Set target Core property if the target SOC has multiple cores
mdk_option_list(MDK_TARGET_CORE "Core in the SOC to compile for" "${MDK_TARGET_CORE_VALUES}")

if (MDK_TARGET_HAS_CORES)
    if ("${MDK_TARGET_CORE}" STREQUAL "")
        set(MDK_TARGET_CORE "application")
    endif()

    set(MDK_TARGET_CORE_CMAKE_FILE "${MDK_DIR_TARGET}/${MDK_TARGET_GENERIC_NAME}_${MDK_TARGET_CORE}.cmake")
    if (NOT EXISTS "${MDK_TARGET_CORE_CMAKE_FILE}")
        message(FATAL_ERROR "Core specific file for ${MDK_TARGET_SOC} ${MDK_TARGET_CORE} not found: '${MDK_TARGET_CORE_CMAKE_FILE}'.")
    endif()

    # Include the properties file for the CORE
    message(STATUS "Loading file '${MDK_TARGET_CORE_CMAKE_FILE}'")
    include("${MDK_TARGET_CORE_CMAKE_FILE}")
endif ()

# Add FPU_ABI selection list.
mdk_dependent_option_list(MDK_TARGET_FPU_ABI "FPU calling convention" "hard;softfp;soft" "${MDK_TARGET_FPU_IMPLEMENTED}" "hard")