cmake_minimum_required(VERSION 3.6)

find_package(MDK REQUIRED HINTS cmake/modules)

if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
    set(CMAKE_TOOLCHAIN_FILE ${MDK_TOOLCHAIN_FILE})
endif()

project(nrf-mdk C CXX ASM)

add_library(nrf-mdk-definitions INTERFACE)
target_include_directories(nrf-mdk-definitions INTERFACE ${MDK_DIR_INCLUDES})
target_compile_definitions(nrf-mdk-definitions INTERFACE ${MDK_DEFINITIONS})

add_library(nrf-mdk::startup ALIAS nRFMDK)
add_library(nrf-mdk::definitions ALIAS nrf-mdk-definitions)