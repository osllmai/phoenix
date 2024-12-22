#pragma once

#include <QList>

class PluginLoader
{
public:
    PluginLoader();

    int loadPlugins();
    static PluginLoader *instance();

    QList<QObject *> plugins() const;

private:
    QList<QObject*>_plugins;
};
