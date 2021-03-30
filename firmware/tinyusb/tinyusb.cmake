# This Cmake will be injected into the root folder of FetchContent for https://packs.download.microchip.com/Microchip.SAMD51_DFP.3.4.91.atpack
cmake_minimum_required (VERSION 3.18)

project( tinyusb LANGUAGES  C ASM)

add_library(tinyusb)
set_target_properties( tinyusb PROPERTIES
    C_STANDARD 11
)

# @todo TinyUSB is using some older defined names for USB interupts?
target_compile_definitions(tinyusb
    PUBLIC
        USB_0_IRQn=USB_OTHER_IRQn
        USB_1_IRQn=USB_SOF_HSOF_IRQn
        USB_2_IRQn=USB_TRCPT0_IRQn
        USB_3_IRQn=USB_TRCPT1_IRQn
)

target_include_directories( tinyusb
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/src
        ${CMAKE_CURRENT_LIST_DIR}
)

if( NOT ${CMAKE_CXX_COMPILER_ID} STREQUAL "GNU" )
    message( WARNING "NOT GNU Compiler ${CMAKE_CXX_COMPILER_ID}")
endif()


# TODO: POrtabilityy!
target_sources( tinyusb 
    PUBLIC
        "src/class/dfu/dfu_rt_device.c"
       # "src/class/cdc/cdc_device.c"
        "src/common/tusb_fifo.c"
        "src/device/usbd.c"
        "src/device/usbd_control.c"
        "src/portable/microchip/samd/dcd_samd.c"
        "src/tusb.c"
)

target_link_libraries( tinyusb
    PUBLIC
        samd51::csp
        arm::cmsis_5
)