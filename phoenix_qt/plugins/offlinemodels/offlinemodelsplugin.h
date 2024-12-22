#pragma once

#include <pluginbase.h>

class OfflineModelsPlugin
{
    Q_PLUGIN_METADATA(IID "org.phoenix.OfflineModelsPlugin" FILE "OfflineModelsPlugin.json")
    Q_INTERFACES(AbstractPlugin)

public:
    OfflineModelsPlugin();
};
