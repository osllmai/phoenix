cmake_minimum_required(VERSION 3.16)

# ==========================
# Common settings
# ==========================
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# ==========================
# Detect OS and Architecture
# ==========================
message(STATUS "Operating System: ${CMAKE_SYSTEM_NAME}")
message(STATUS "Architecture: ${CMAKE_SYSTEM_PROCESSOR}")

if(WIN32)
    message(STATUS "Configuring for Windows...")
    add_definitions(-DPLATFORM_WINDOWS)
elseif(APPLE)
    message(STATUS "Configuring for macOS...")
    option(BUILD_UNIVERSAL "Build a Universal binary on macOS" OFF)
    if(BUILD_UNIVERSAL)
        set(CMAKE_OSX_ARCHITECTURES "arm64;x86_64" CACHE STRING "" FORCE)
    else()
        set(CMAKE_OSX_ARCHITECTURES "${CMAKE_HOST_SYSTEM_PROCESSOR}" CACHE STRING "" FORCE)
    endif()
    add_definitions(-DPLATFORM_MACOS)
elseif(UNIX)
    message(STATUS "Configuring for Linux...")
    add_definitions(-DPLATFORM_LINUX)
else()
    message(FATAL_ERROR "Unsupported platform!")
endif()

# ==========================
# Project info
# ==========================
set(PROJECTNAME local_provider)
project(${PROJECTNAME} VERSION 0.1 LANGUAGES CXX)

# ==========================
# Add llama_cpp library
# ==========================
add_subdirectory(./llama_cpp/ llmodel)

# ==========================
# Source files
# ==========================
set(SOURCES
    main.cpp
    llm_params.h
)

# ==========================
# Create executable
# ==========================
add_executable(app${PROJECTNAME}
    ${SOURCES}
)

# ==========================
# Include directories
# ==========================
target_include_directories(app${PROJECTNAME}
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/llama_cpp/include
        ${CMAKE_CURRENT_SOURCE_DIR}
)

# ==========================
# Link libraries
# ==========================
target_link_libraries(app${PROJECTNAME}
    PRIVATE llmodel
)

# ==========================
# Platform-specific linking (optional safety)
# ==========================
if(WIN32)
    target_link_libraries(app${PROJECTNAME} PRIVATE ws2_32)
elseif(APPLE)
    find_library(COCOA_LIB Cocoa)
    if(COCOA_LIB)
        target_link_libraries(app${PROJECTNAME} PRIVATE ${COCOA_LIB})
    endif()
elseif(UNIX)
    target_link_libraries(app${PROJECTNAME} PRIVATE pthread dl)
endif()
