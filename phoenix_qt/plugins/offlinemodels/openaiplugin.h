#pragma once

#include <pluginbase.h>

class OpenAIPlugin : public QObject, public AbstractPlugin
{
    Q_PLUGIN_METADATA(IID "org.phoenix.onlineproviders" FILE "openaiplugin.json")
    Q_INTERFACES(AbstractPlugin)

public:
    OpenAIPlugin();
};
