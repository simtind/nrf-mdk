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

set(MDK_TARGET_CORE_VALUES )
set(MDK_TARGET_HAS_CORES NO)

set(MDK_TARGET_MACROS NRF52833_XXAA)
set(MDK_TARGET_GENERIC_NAME nrf52833)

set(MDK_TARGET_DSP_IMPLEMENTED "YES" CACHE INTERNAL "")
set(MDK_TARGET_FPU_IMPLEMENTED "YES" CACHE INTERNAL "")
set(MDK_TARGET_TRACE_IMPLEMENTED "YES" CACHE INTERNAL "")
set(MDK_TARGET_SWO_IMPLEMENTED "YES" CACHE INTERNAL "")
set(MDK_TARGET_TRUSTZONE_IMPLEMENTED "NO" CACHE INTERNAL "")

set(CMAKE_SYSTEM_PROCESSOR "arm" CACHE INTERNAL "")
set(MDK_TARGET_PROCESSOR "cortex-m4" CACHE INTERNAL "")

set(MDK_HEAP_SIZE 8192 CACHE INTERNAL "")
set(MDK_STACK_SIZE 8192 CACHE INTERNAL "")


set(MDK_TARGET_SOURCE_SYSTEM system_nrf52.c)
set(MDK_TARGET_SOURCE_STARTUP startup_nrf_common.c)

set(MDK_TARGET_SOURCE_LINKER_SCRIPT nrf52833_xxaa.ld)
set(MDK_TARGET_SOURCE_SCATTER_FILE nrf52833_xxaa.sct)

