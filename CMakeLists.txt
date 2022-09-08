cmake_minimum_required(VERSION 3.18) #FetchContent

# Only supported for target cross-compiled build
if ( NOT CMAKE_CROSSCOMPILING )
    return()
endif()

# --------
# Options
# --------
# Note: 0.9.0 doens't work with the current TinyUSB due to define of USB_0_IRQn changed?
set( TinyUsbVersion "0.13.0" CACHE STRING "TinyUSB library version")

set_property(CACHE TinyUsbVersion PROPERTY STRINGS 
    0.10.1
    0.10.0
    0.9.0
    0.8.0
)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/CMake")
include(CPM)

CPMAddPackage(
    NAME tinyusb_fetchcontent
    GIT_REPOSITORY https://github.com/hathach/tinyusb.git
    GIT_TAG ${TinyUsbVersion}
    GIT_SHALLOW TRUE 
    GIT_PROGRESS TRUE
    GIT_SUBMODULES  "hw/mcu/microchip"
    DOWNLOAD_ONLY YES
)

if(tinyusb_fetchcontent_ADDED)
    # Inject and use tinyusb.cmake 
    write_file( ${tinyusb_fetchcontent_SOURCE_DIR}/CMakeLists.txt "include(${CMAKE_CURRENT_LIST_DIR}/tinyusb.cmake)" )
    file( APPEND ${tinyusb_fetchcontent_SOURCE_DIR}/.git/info/exclude "/CMakeLists.txt")

    add_subdirectory(${tinyusb_fetchcontent_SOURCE_DIR} ${tinyusb_fetchcontent_BINARY_DIR})
endif()
    