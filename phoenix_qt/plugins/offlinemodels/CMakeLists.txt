
add_library(OfflineModelsPlugin SHARED
    openaiprovider.h openaiprovider.cpp
    openaiplugin.h openaiplugin.cpp
    offlinemodelsplugin.h offlinemodelsplugin.cpp
)

target_link_libraries(OfflineModelsPlugin
    PRIVATE
        Qt6::Core
        PluginCore
        ${CUDA_LIBRARIES}
)

target_include_directories(OfflineModelsPlugin
    PRIVATE
        ${CUDA_INCLUDE_DIRS}
)
