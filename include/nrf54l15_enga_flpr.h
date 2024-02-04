/*

Copyright (c) 2010 - 2024, Nordic Semiconductor ASA All rights reserved.

SPDX-License-Identifier: BSD-3-Clause

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

3. Neither the name of Nordic Semiconductor ASA nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY, AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL NORDIC SEMICONDUCTOR ASA OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

*/

#ifndef NRF54L15_ENGA_FLPR_H
#define NRF54L15_ENGA_FLPR_H

#ifdef __cplusplus
    extern "C" {
#endif


#ifdef NRF_FLPR                                      /*!< Processor information is domain local.                               */


/* =========================================================================================================================== */
/* ================                                Interrupt Number Definition                                ================ */
/* =========================================================================================================================== */

typedef enum {
/* ===================================================== Core Interrupts ===================================================== */
/* ============================================== Processor Specific Interrupts ============================================== */
  VPRCLIC_0_IRQn                         = 0,        /*!< 0 VPRCLIC_0                                                          */
  VPRCLIC_1_IRQn                         = 1,        /*!< 1 VPRCLIC_1                                                          */
  VPRCLIC_2_IRQn                         = 2,        /*!< 2 VPRCLIC_2                                                          */
  VPRCLIC_3_IRQn                         = 3,        /*!< 3 VPRCLIC_3                                                          */
  VPRCLIC_4_IRQn                         = 4,        /*!< 4 VPRCLIC_4                                                          */
  VPRCLIC_5_IRQn                         = 5,        /*!< 5 VPRCLIC_5                                                          */
  VPRCLIC_6_IRQn                         = 6,        /*!< 6 VPRCLIC_6                                                          */
  VPRCLIC_7_IRQn                         = 7,        /*!< 7 VPRCLIC_7                                                          */
  VPRCLIC_8_IRQn                         = 8,        /*!< 8 VPRCLIC_8                                                          */
  VPRCLIC_9_IRQn                         = 9,        /*!< 9 VPRCLIC_9                                                          */
  VPRCLIC_10_IRQn                        = 10,       /*!< 10 VPRCLIC_10                                                        */
  VPRCLIC_11_IRQn                        = 11,       /*!< 11 VPRCLIC_11                                                        */
  VPRCLIC_12_IRQn                        = 12,       /*!< 12 VPRCLIC_12                                                        */
  VPRCLIC_13_IRQn                        = 13,       /*!< 13 VPRCLIC_13                                                        */
  VPRCLIC_14_IRQn                        = 14,       /*!< 14 VPRCLIC_14                                                        */
  VPRCLIC_15_IRQn                        = 15,       /*!< 15 VPRCLIC_15                                                        */
  VPRCLIC_16_IRQn                        = 16,       /*!< 16 VPRCLIC_16                                                        */
  VPRCLIC_17_IRQn                        = 17,       /*!< 17 VPRCLIC_17                                                        */
  VPRCLIC_18_IRQn                        = 18,       /*!< 18 VPRCLIC_18                                                        */
  VPRCLIC_19_IRQn                        = 19,       /*!< 19 VPRCLIC_19                                                        */
  VPRCLIC_20_IRQn                        = 20,       /*!< 20 VPRCLIC_20                                                        */
  VPRCLIC_21_IRQn                        = 21,       /*!< 21 VPRCLIC_21                                                        */
  VPRCLIC_22_IRQn                        = 22,       /*!< 22 VPRCLIC_22                                                        */
  VPRCLIC_23_IRQn                        = 23,       /*!< 23 VPRCLIC_23                                                        */
  VPRCLIC_24_IRQn                        = 24,       /*!< 24 VPRCLIC_24                                                        */
  VPRCLIC_25_IRQn                        = 25,       /*!< 25 VPRCLIC_25                                                        */
  VPRCLIC_26_IRQn                        = 26,       /*!< 26 VPRCLIC_26                                                        */
  VPRCLIC_27_IRQn                        = 27,       /*!< 27 VPRCLIC_27                                                        */
  VPRCLIC_28_IRQn                        = 28,       /*!< 28 VPRCLIC_28                                                        */
  VPRCLIC_29_IRQn                        = 29,       /*!< 29 VPRCLIC_29                                                        */
  VPRCLIC_30_IRQn                        = 30,       /*!< 30 VPRCLIC_30                                                        */
  VPRCLIC_31_IRQn                        = 31,       /*!< 31 VPRCLIC_31                                                        */
  SPU00_IRQn                             = 64,       /*!< 64 SPU00                                                             */
  MPC00_IRQn                             = 65,       /*!< 65 MPC00                                                             */
  AAR00_CCM00_IRQn                       = 70,       /*!< 70 AAR00_CCM00                                                       */
  ECB00_IRQn                             = 71,       /*!< 71 ECB00                                                             */
  CRACEN_IRQn                            = 72,       /*!< 72 CRACEN                                                            */
  SERIAL00_IRQn                          = 74,       /*!< 74 SERIAL00                                                          */
  RRAMC_IRQn                             = 75,       /*!< 75 RRAMC                                                             */
  VPR00_IRQn                             = 76,       /*!< 76 VPR00                                                             */
  CTRLAP_IRQn                            = 82,       /*!< 82 CTRLAP                                                            */
  TIMER00_IRQn                           = 85,       /*!< 85 TIMER00                                                           */
  SPU10_IRQn                             = 128,      /*!< 128 SPU10                                                            */
  TIMER10_IRQn                           = 133,      /*!< 133 TIMER10                                                          */
  RTC10_IRQn                             = 134,      /*!< 134 RTC10                                                            */
  EGU10_IRQn                             = 135,      /*!< 135 EGU10                                                            */
  RADIO_0_IRQn                           = 138,      /*!< 138 RADIO_0                                                          */
  RADIO_1_IRQn                           = 139,      /*!< 139 RADIO_1                                                          */
  SPU20_IRQn                             = 192,      /*!< 192 SPU20                                                            */
  SERIAL20_IRQn                          = 198,      /*!< 198 SERIAL20                                                         */
  SERIAL21_IRQn                          = 199,      /*!< 199 SERIAL21                                                         */
  SERIAL22_IRQn                          = 200,      /*!< 200 SERIAL22                                                         */
  EGU20_IRQn                             = 201,      /*!< 201 EGU20                                                            */
  TIMER20_IRQn                           = 202,      /*!< 202 TIMER20                                                          */
  TIMER21_IRQn                           = 203,      /*!< 203 TIMER21                                                          */
  TIMER22_IRQn                           = 204,      /*!< 204 TIMER22                                                          */
  TIMER23_IRQn                           = 205,      /*!< 205 TIMER23                                                          */
  TIMER24_IRQn                           = 206,      /*!< 206 TIMER24                                                          */
  PWM20_IRQn                             = 210,      /*!< 210 PWM20                                                            */
  PWM21_IRQn                             = 211,      /*!< 211 PWM21                                                            */
  PWM22_IRQn                             = 212,      /*!< 212 PWM22                                                            */
  SAADC_IRQn                             = 213,      /*!< 213 SAADC                                                            */
  NFCT_IRQn                              = 214,      /*!< 214 NFCT                                                             */
  TEMP_IRQn                              = 215,      /*!< 215 TEMP                                                             */
  GPIOTE20_0_IRQn                        = 218,      /*!< 218 GPIOTE20_0                                                       */
  GPIOTE20_1_IRQn                        = 219,      /*!< 219 GPIOTE20_1                                                       */
  TAMPC_IRQn                             = 220,      /*!< 220 TAMPC                                                            */
  I2S20_IRQn                             = 221,      /*!< 221 I2S20                                                            */
  QDEC20_IRQn                            = 224,      /*!< 224 QDEC20                                                           */
  QDEC21_IRQn                            = 225,      /*!< 225 QDEC21                                                           */
  GRTC_0_IRQn                            = 226,      /*!< 226 GRTC_0                                                           */
  GRTC_1_IRQn                            = 227,      /*!< 227 GRTC_1                                                           */
  GRTC_2_IRQn                            = 228,      /*!< 228 GRTC_2                                                           */
  GRTC_3_IRQn                            = 229,      /*!< 229 GRTC_3                                                           */
  SPU30_IRQn                             = 256,      /*!< 256 SPU30                                                            */
  SERIAL30_IRQn                          = 260,      /*!< 260 SERIAL30                                                         */
  RTC30_IRQn                             = 261,      /*!< 261 RTC30                                                            */
  COMP_LPCOMP_IRQn                       = 262,      /*!< 262 COMP_LPCOMP                                                      */
  WDT30_IRQn                             = 264,      /*!< 264 WDT30                                                            */
  WDT31_IRQn                             = 265,      /*!< 265 WDT31                                                            */
  GPIOTE30_0_IRQn                        = 268,      /*!< 268 GPIOTE30_0                                                       */
  GPIOTE30_1_IRQn                        = 269,      /*!< 269 GPIOTE30_1                                                       */
  CLOCK_POWER_IRQn                       = 270,      /*!< 270 CLOCK_POWER                                                      */
} IRQn_Type;


/* =========================================================================================================================== */
/* ================                           Processor and Core Peripheral Section                           ================ */
/* =========================================================================================================================== */

/* ====================== Configuration of the Nordic Semiconductor VPR Processor and Core Peripherals ======================= */
#define __VPR_REV                  1.3.1             /*!< VPR Core Revision                                                    */
#define __DSP_PRESENT                  0             /*!< DSP present or not                                                   */
#define __CLIC_PRIO_BITS               3             /*!< Number of Bits used for Priority Levels                              */
#define __MTVT_PRESENT                 1             /*!< CPU supports alternate Vector Table address                          */
#define __MPU_PRESENT                  1             /*!< MPU present                                                          */
#define __FPU_PRESENT                  0             /*!< FPU present                                                          */
#define __FPU_DP                       0             /*!< Double Precision FPU                                                 */
#define __INTERRUPTS_MAX             176             /*!< Size of interrupt vector table                                       */

#include "core_vpr.h"                                /*!< Nordic Semiconductor VPR processor and core peripherals              */
#include "system_nrf.h"                              /*!< nrf54l15_enga_flpr System Library                                    */

#endif                                               /*!< NRF_FLPR                                                             */


/* ========================================= Start of section using anonymous unions ========================================= */

#include "compiler_abstraction.h"

#if defined (__CC_ARM)
  #pragma push
  #pragma anon_unions
#elif defined (__ICCARM__)
  #pragma language=extended
#elif defined(__ARMCC_VERSION) && (__ARMCC_VERSION >= 6010050)
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wc11-extensions"
  #pragma clang diagnostic ignored "-Wreserved-id-macro"
  #pragma clang diagnostic ignored "-Wgnu-anonymous-struct"
  #pragma clang diagnostic ignored "-Wnested-anon-types"
#elif defined (__GNUC__)
  /* anonymous unions are enabled by default */
#elif defined (__TMS470__)
  /* anonymous unions are enabled by default */
#elif defined (__TASKING__)
  #pragma warning 586
#elif defined (__CSMC__)
  /* anonymous unions are enabled by default */
#else
  #warning Unsupported compiler type
#endif

/* =========================================================================================================================== */
/* ================                                  Peripheral Address Map                                  ================ */
/* =========================================================================================================================== */

#define NRF_FLPR_VPRCLIC_NS_BASE          0xF0000000UL

/* =========================================================================================================================== */
/* ================                                  Peripheral Declaration                                  ================ */
/* =========================================================================================================================== */

#define NRF_FLPR_VPRCLIC_NS               ((NRF_CLIC_Type*)                     NRF_FLPR_VPRCLIC_NS_BASE)

/* =========================================================================================================================== */
/* ================                                    TrustZone Remapping                                    ================ */
/* =========================================================================================================================== */

#ifdef NRF_TRUSTZONE_NONSECURE                       /*!< Remap NRF_X_NS instances to NRF_X symbol for ease of use.            */
  #define NRF_FLPR_VPRCLIC                        NRF_FLPR_VPRCLIC_NS
#else                                                /*!< Remap NRF_X_S instances to NRF_X symbol for ease of use.             */
  #define NRF_FLPR_VPRCLIC                        NRF_FLPR_VPRCLIC_NS
#endif                                               /*!<  NRF_TRUSTZONE_NONSECURE                                             */

/* =========================================================================================================================== */
/* ================                                  Local Domain Remapping                                  ================ */
/* =========================================================================================================================== */

#ifdef NRF_FLPR                                      /*!< Remap NRF_DOMAIN instances to NRF_X symbol for ease of use.          */
  #define NRF_VPRCLIC                             NRF_FLPR_VPRCLIC
#endif                                               /*!< NRF_FLPR                                                             */

/* ========================================== End of section using anonymous unions ========================================== */

#if defined (__CC_ARM)
  #pragma pop
#elif defined (__ICCARM__)
  /* leave anonymous unions enabled */
#elif defined(__ARMCC_VERSION) && (__ARMCC_VERSION >= 6010050)
  #pragma clang diagnostic pop
#elif defined (__GNUC__)
  /* anonymous unions are enabled by default */
#elif defined (__TMS470__)
  /* anonymous unions are enabled by default */
#elif defined (__TASKING__)
  #pragma warning restore
#elif defined (__CSMC__)
  /* anonymous unions are enabled by default */
#endif


#ifdef __cplusplus
}
#endif
#endif /* NRF54L15_ENGA_FLPR_H */

