
add_library(PhoenixPluginCore SHARED
    pluginbase.h pluginbase.cpp
    abstractprovider.h abstractprovider.cpp
)

target_link_libraries(PhoenixPluginCore
    PRIVATE
        Qt6::Core
)
