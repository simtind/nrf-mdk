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

# Make a drop-down list named "option", with possible values "values"
function(mdk_option_list option doc values)
    list(LENGTH values length)
    if (length GREATER 0)
        list(GET values 0 default)
        set(${option} "${default}" CACHE STRING "${doc}")
        set_property(CACHE ${option} PROPERTY STRINGS ${values})
    else ()
        set(${option} "" CACHE STRING "${doc}")
        set_property(CACHE ${option} PROPERTY STRINGS ${values})
    endif ()
endfunction()

# Make a drop-down list if "depends" argument evaluates to true. 
# Inspired by cmake_dependent_option function
macro(mdk_dependent_option_list option doc values depends force)
  if(${option}_OLD MATCHES "^${option}_OLD$")
    set(${option}_AVAILABLE 1)
    
    foreach(d ${depends})
      if(NOT ${d})
        set(${option}_AVAILABLE 0)
      endif()
    endforeach()

    if(${option}_AVAILABLE)
        mdk_option_list("${option}" "${doc}" "${values}")
    else()
        mdk_option_list("${option}" "${doc}" "${force}")
    endif()
  else()
    set(${option} "${${option}_OLD}" CACHE)
  endif()
endmacro()
