cmake_minimum_required(VERSION 3.16)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

if(APPLE)
  option(BUILD_UNIVERSAL "Build a Universal binary on macOS" OFF)
  if(BUILD_UNIVERSAL)
    set(CMAKE_OSX_ARCHITECTURES "arm64;x86_64" CACHE STRING "" FORCE)
  else()
    set(CMAKE_OSX_ARCHITECTURES "${CMAKE_HOST_SYSTEM_PROCESSOR}" CACHE STRING "" FORCE)
  endif()
endif()

set(PROJECTNAME local_provider)
project(${PROJECTNAME} VERSION 0.1 LANGUAGES CXX)

# Add llama_cpp library
add_subdirectory(./llama_cpp/ llmodel)

# Define source files
set(SOURCES
  main.cpp
  llm_params.h
)

# Create executable
add_executable(app${PROJECTNAME}
  ${SOURCES}
)

# Include directories
target_include_directories(app${PROJECTNAME}
  PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/llama_cpp/include
    ${CMAKE_CURRENT_SOURCE_DIR}
)

# Link libraries
target_link_libraries(app${PROJECTNAME}
  PRIVATE llmodel
)
