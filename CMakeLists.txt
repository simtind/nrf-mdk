
cmake_minimum_required(VERSION 3.6)

find_package(MDK REQUIRED HINTS cmake/modules)

add_library(nrf-mdk-definitions INTERFACE)
target_include_directories(nrfmdk-definitions INTERFACE ${MDK_DIR_INCLUDES})
target_compile_definitions(nrfmdk-definitions INTERFACE ${MDK_DEFINITIONS})

add_library(nrf-mdk::startup ALIAS nRFMDK)
add_library(nrf-mdk::definitions ALIAS nrfmdk-definitions)