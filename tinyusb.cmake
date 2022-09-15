# This Cmake will be injected into the root folder of FetchContent for https://packs.download.microchip.com/Microchip.SAMD51_DFP.3.4.91.atpack
cmake_minimum_required(VERSION 3.18)

project( tinyusb LANGUAGES  C ASM)

add_library(tinyusb)
add_library(tinyusb::tinyusb ALIAS tinyusb)

set_target_properties( tinyusb PROPERTIES
    C_STANDARD 11
)
# @todo TinyUSB is using some older defined names for USB interupts?
target_compile_definitions(tinyusb
    PUBLIC
        # CFG_TUSB_DEBUG=3 #< 3= info, 2 = warning
        # LOGGER=swo
        USB_0_IRQn=USB_OTHER_IRQn
        USB_1_IRQn=USB_SOF_HSOF_IRQn
        USB_2_IRQn=USB_TRCPT0_IRQn
        USB_3_IRQn=USB_TRCPT1_IRQn
        CFG_TUSB_MCU=OPT_MCU_SAMD51 # TODO: Make this configurable from teh MCU selection of linked in Chip-Support-Package 9csp) ?
)

target_compile_options(tinyusb
    PRIVATE 
        # TODO: Not sure why this was left here, disabled for now!
        #$<$<CXX_COMPILER_ID:GNU>:-O0>
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
    PRIVATE
        "${CMAKE_CURRENT_LIST_DIR}/tusb_config.h"
        
	    "src/tusb.c"
	    "src/common/tusb_fifo.c"
	    "src/device/usbd.c"
	    "src/device/usbd_control.c"
	    "src/class/audio/audio_device.c"
	    "src/class/cdc/cdc_device.c"
	    "src/class/dfu/dfu_device.c"
	    "src/class/dfu/dfu_rt_device.c"
	    "src/class/hid/hid_device.c"
	    "src/class/midi/midi_device.c"
	    "src/class/msc/msc_device.c"
	    "src/class/net/ncm_device.c"
	    "src/class/usbtmc/usbtmc_device.c"
	    "src/class/vendor/vendor_device.c"

        # Device specific
        # TODO: Portability!
        "src/portable/microchip/samd/dcd_samd.c"
)

target_link_libraries( tinyusb
    PUBLIC
        microchip::samd51::csp
        arm::cmsis_5
)