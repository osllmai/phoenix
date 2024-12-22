
add_library(PluginCore SHARED
    pluginbase.h pluginbase.cpp
    abstractprovider.h abstractprovider.cpp
)

target_link_libraries(PluginCore
    PRIVATE
        Qt6::Core
)

target_include_directories(PluginCore PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
