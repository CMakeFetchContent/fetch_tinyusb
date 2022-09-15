cmake_minimum_required(VERSION 3.18) #FetchContent

# Only supported for target cross-compiled build
if ( NOT CMAKE_CROSSCOMPILING )
    return()
endif()

# --------
# Options
# --------
# Note: 0.9.0 doens't work with the current TinyUSB due to define of USB_0_IRQn changed?
set( TinyUsbVersion "0.14.0" CACHE STRING "TinyUSB library version")

set_property(CACHE TinyUsbVersion PROPERTY STRINGS 
    0.14.0
    0.13.0
    0.12.0
    0.10.1
    0.10.0
    0.9.0
    0.8.0
)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/CMake")
include(CPM)

CPMAddPackage(
    NAME tinyusb
    GIT_REPOSITORY https://github.com/hathach/tinyusb.git
    GIT_TAG ${TinyUsbVersion}
    GIT_SHALLOW TRUE 
    GIT_PROGRESS TRUE
    GIT_SUBMODULES  "hw/mcu/microchip"
    DOWNLOAD_ONLY YES
)

if(tinyusb_ADDED)
    # Inject and use tinyusb.cmake 
    write_file( ${tinyusb_SOURCE_DIR}/CMakeLists.txt "include(${CMAKE_CURRENT_LIST_DIR}/tinyusb.cmake)" )
        
    file(STRINGS ${tinyusb_SOURCE_DIR}/.git/info/exclude excludes)
    if (NOT "/CMakeLists.txt" IN_LIST excludes) # Add git local exclusion for the generated file
        file( APPEND ${tinyusb_SOURCE_DIR}/.git/info/exclude "/CMakeLists.txt\n")
    endif()

    add_subdirectory(${tinyusb_SOURCE_DIR} ${tinyusb_BINARY_DIR})
endif()
    