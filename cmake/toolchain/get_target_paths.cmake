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

# Find source and target paths for create-hex methods
# Arguments:
# target: Cmake target to create hex file for
# Optional arguments:
# hex_name: Override name of output hex file
function (get_target_paths target)

    # Find binary directory
    get_target_property(directory ${target} BINARY_DIR)
    if (${directory} MATCHES ".*NOTFOUND")
        set(directory ${CMAKE_CURRENT_BINARY_DIR})
    endif()

    # Find binary names
    get_target_property(output_name ${target} OUTPUT_NAME)
    if (${output_name} MATCHES ".*NOTFOUND")
        get_target_property(output_name ${target} NAME)
    endif()
    if (${output_name} MATCHES ".*NOTFOUND")
        set(output_name ${target})
    endif()

    set(hex_name ${output_name})
    set(source_name ${output_name})
    
    # Parse optional hex name override
    set (extra_args ${ARGN})
    list(LENGTH extra_args extra_count)
    if (${extra_count} GREATER 0)
        list(GET extra_args 0 hex_name)
    endif ()

    # Find source binary extension
    get_target_property(source_extension ${target} SUFFIX)
    if (${source_extension} MATCHES ".*NOTFOUND")
        set(source_extension ${CMAKE_EXECUTABLE_SUFFIX})
    endif()

    set(source_file ${directory}/${source_name}${source_extension} PARENT_SCOPE)
    set(hex_file ${directory}/${hex_name}.hex PARENT_SCOPE)
endfunction(get_target_paths)