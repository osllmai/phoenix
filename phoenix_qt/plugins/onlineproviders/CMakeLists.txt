
add_library(OnlineProvidersPlugin SHARED
    openaiprovider.h openaiprovider.cpp

    onlineprovidersplugin.h onlineprovidersplugin.cpp
)

target_link_libraries(OnlineProvidersPlugin
    PRIVATE
        Qt6::Core
        PluginCore
)
