# Cmake package for MDK

## Requirements:
- Cmake v3.6 or newer
- Ninja build system
- Keil, GCC, or Clang
- CMSIS header files

## Tested toolchains
- ARMClang - Arm compiler v6
- ARMCC    - Arm compiler v5
- RISCV64-none-elf-gcc - GCC compiler toolchain for 32 and 64bit RISC-V targets
    - Tested with "GNU Embedded Toolchain — v2019.08.0" precompiled toolchain downloaded from  https://www.sifive.com/boards
- ARM-None-eabi-gcc - GCC compiler for Arm targets
- Clang/LLVM with GCC supporting libraries
    - Requires the correct GCC flavor (Arm-none-eabi or riscv-none-elf) to be installed and detectable as well
    - Requires Clang v9 or newer

## Contents
- cmake/toolchain.cmake : Selects and initializes the compiler and linker toolchains.
- cmake/target.cmake : Selects and initializes the target properties. 
- cmake/example : An example cmake list that describes a simple example using a main.c file and the MDK.
- cmake/mdkDependentOptionList.cmake : A utility class implementing a one-liner for multiple-choice cmake options.

## To prepare your project folder:
We'll call your project folder `root_dir`.
1. Place the MDK source files in your project directory under the folder `root_dir/mdk/`.
2. Copy the example files from `root_dir/mdk/example` to `root_dir/`.
3. Either copy the Include folder of a CMSIS install into `root_dir/cmsis/Include`,
    or modify the variable `MDK_CMSIS_INCLUDE_DIR` to point to your CMSIS include directory.

## To build your project:
1. Generate Ninja build scripts using `cmake . -G Ninja -DMDK_TARGET_SOC=nrf5340_xxaa -DMDK_TARGET_CORE=NETWORK`
    - The most important variables:
        - `MDK_TARGET_SOC`        : The SOC to build for, e.g. `nrf5340_xxaa` or `nrf52832_xxaa`
        - `MDK_TARGET_CORE`       : Used if the SOC is a multi-core device, the core to build for. 
                                        Defaults to `application`, see the related device file under `mdk/cmake/device/<device>.cmake` for possible values.
        - `MDK_TOOLCHAIN`         : The toolchain to build with. Defaults to `gcc`; `armcc`, `gcc`, and `clang` are supported.
        - `MDK_CMSIS_INCLUDE_DIR` : Folder that includes common header files for ARM processors.
        - For more variables see ccmake or cmake-gui.
2. Build the executable using `cmake --build . --config Debug`