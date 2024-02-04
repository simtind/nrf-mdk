
cmake_minimum_required(VERSION 3.6)

project(nrfx C CXX ASM)

find_package(MDK REQUIRED HINTS cmake/modules)

add_library(nrf-mdk-definitions INTERFACE)
target_include_directories(nrf-mdk-definitions INTERFACE ${MDK_DIR_INCLUDES})
target_compile_definitions(nrf-mdk-definitions INTERFACE ${MDK_DEFINITIONS})

add_library(nrf-mdk::startup ALIAS nRFMDK)
add_library(nrf-mdk::definitions ALIAS nrf-mdk-definitions)