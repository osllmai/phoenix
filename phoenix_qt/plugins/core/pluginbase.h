#pragma once

#include <QObject>

class ModelData {

};

class AbstractPlugin
{
    virtual QList<ModelData> models() const = 0;
};

#define AbstractPlugin_iid "org.Phoenix.PluginInterface"
Q_DECLARE_INTERFACE(AbstractPlugin, AbstractPlugin_iid)

