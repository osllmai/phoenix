cmake_minimum_required(VERSION 3.16)
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_VERBOSE_MAKEFILE ON)
if (GPT4ALL_AVX_ONLY)
    set(LLAMA_AVX2 OFF CACHE BOOL "llama: enable AVX2" FORCE)
    set(LLAMA_F16C OFF CACHE BOOL "llama: enable F16C" FORCE)
    set(LLAMA_FMA  OFF CACHE BOOL "llama: enable FMA" FORCE)
endif()

#add_subdirectory(llama.cpp)

add_library(llmodel
    gptj.h gptj.cpp
    llamamodel.h llamamodel.cpp
    common.cpp
    llmodel.h llmodel_c.h llmodel_c.cpp
    mpt.h mpt.cpp
    utils.h utils.cpp
)

target_link_libraries(llmodel
    PRIVATE llama)
