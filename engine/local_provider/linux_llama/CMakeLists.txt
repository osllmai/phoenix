cmake_minimum_required(VERSION 3.16)
project(applocal_provider_linux CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(NOT DEFINED LLAMA_CPP_DIR)
  message(FATAL_ERROR "Set -DLLAMA_CPP_DIR to a built llama.cpp checkout (see BUILD.md)")
endif()

add_executable(applocal_provider main.cpp)
target_include_directories(applocal_provider PRIVATE
  ${LLAMA_CPP_DIR}/include ${LLAMA_CPP_DIR}/ggml/include)
target_link_directories(applocal_provider PRIVATE ${LLAMA_CPP_DIR}/build/bin)
target_link_libraries(applocal_provider PRIVATE llama ggml ggml-base ggml-cpu)
set_target_properties(applocal_provider PROPERTIES
  BUILD_RPATH "$ORIGIN" INSTALL_RPATH "$ORIGIN")
