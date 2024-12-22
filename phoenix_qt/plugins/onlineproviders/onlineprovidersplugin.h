#pragma once

#include <pluginbase.h>

class OnlineProvidersPlugin
{
    Q_PLUGIN_METADATA(IID "org.phoenix.OnlineProvidersPlugin" FILE "OnlineProvidersPlugin.json")
    Q_INTERFACES(AbstractPlugin)

public:
    OnlineProvidersPlugin();
};
