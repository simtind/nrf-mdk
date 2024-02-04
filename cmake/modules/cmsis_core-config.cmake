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
INCLUDE(FindPackageHandleStandardArgs)

if (NOT DEFINED CMSIS_DIR)
  if (NOT DEFINED CMSIS_VERSION)
    set(CMSIS_VERSION 5.9.0)
  endif()
  
  message(STATUS "No CMSIS_DIR was provided, downloading CMSIS v${CMSIS_VERSION} from github")
  message(STATUS "Set CMSIS_VERSION to select a different version of the CMSIS package")
    
  include(FetchContent)

  # declare Catch2
  FetchContent_Declare(cmsis
    GIT_REPOSITORY https://github.com/ARM-software/CMSIS_5.git
    GIT_TAG        ${CMSIS_VERSION}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
  )

  # make available
  FetchContent_MakeAvailable(cmsis)
  
  set(CMSIS_DIR ${cmsis_SOURCE_DIR})
endif()

find_path(CMSIS_CORE_INCLUDE_DIR core_cm0.h core_cm4.h core_cm33.h HINTS ${CMSIS_DIR}/CMSIS/Core/Include ${CMSIS_DIR}/Core/Include ${CMSIS_DIR}/Include)

find_package_handle_standard_args(CMSIS_CORE DEFAULT_MSG CMSIS_CORE_INCLUDE_DIR)

if(CMSIS_CORE_FOUND)
  set(CMSIS_CORE_INCLUDE_DIRS ${CMSIS_CORE_INCLUDE_DIR})

  mark_as_advanced(
    CMSIS_CORE_INCLUDE_DIR
    CMSIS_DIR
  )
else()
  message(FATAL_ERROR "Could not find CMSIS header files. Try populating the CMSIS_DIR variable")
endif()