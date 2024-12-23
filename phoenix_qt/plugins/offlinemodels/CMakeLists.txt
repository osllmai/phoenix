add_subdirectory(../../../phoenix/ llmodel)

set (SOURCES
    offlinemodelsplugin.h offlinemodelsplugin.cpp
    offlinemodel.h offlinemodel.cpp
)
add_library(OfflineModelsPlugin SHARED
    ${SOURCES}
)

target_link_libraries(OfflineModelsPlugin
    PRIVATE
        Qt6::Core
        PluginCore
        ${CUDA_LIBRARIES}
        llmodel
)

target_include_directories(OfflineModelsPlugin
    PRIVATE
        ${CUDA_INCLUDE_DIRS}
)
target_include_directories(OfflineModelsPlugin PRIVATE ${CUDA_INCLUDE_DIRS})
target_link_libraries(OfflineModelsPlugin PRIVATE ${CUDA_LIBRARIES})

set(CMAKE_CUDA_ARCHITECTURES 60 75 86)

if (DEFINED CMAKE_CUDA_ARCHITECTURES)
    set(GGML_CUDA_ARCHITECTURES "${CMAKE_CUDA_ARCHITECTURES}")
endif()

if (LLMODEL_VULKAN)
    add_library(OfflineModelsPluginWithVulkan
        SHARED
            ${SOURCES}
    )
endif()

if (LLMODEL_CUDA)
    set(CUDA_SEPARABLE_COMPILATION ON)
    set(CUDA_PROPAGATE_HOST_FLAGS OFF)
    add_definitions(-DGGML_USE_CUDA)

    if (DEFINED CMAKE_CUDA_ARCHITECTURES)
        set(GGML_CUDA_ARCHITECTURES "${CMAKE_CUDA_ARCHITECTURES}")
    endif()

    include(CheckLanguage)
    check_language(CUDA)
    if (NOT CMAKE_CUDA_COMPILER)
        message(WARNING "CUDA Toolkit not found. To build without CUDA, use -DLLMODEL_CUDA=OFF.")
    endif()
    enable_language(CUDA)
    list(APPEND BUILD_VARIANTS cuda cuda-avxonly)

    add_library(OfflineModelsPluginWithCuda
        SHARED
            ${SOURCES}
    )

    target_link_libraries(OfflineModelsPluginWithCuda
       PRIVATE
            Qt6::Core
            PluginCore
            CUDA::cudart
            llmodel
    )
    target_include_directories(OfflineModelsPluginWithCuda
        PRIVATE
            ${CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES}
    )
else()
    message(Cuda not found)
endif()
