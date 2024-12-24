#include "pluginloader.h"

#include <QDir>
#include <QGuiApplication>
#include <QPluginLoader>

#include <QDebug>

PluginLoader::PluginLoader() {}

int PluginLoader::loadPlugins()
{
    int count{};
    // QDir d{qApp->applicationDirPath()};

    // auto pluginFiles = d.entryList("*plugin.dll", QDir::Files);

    // if (_plugins.size()) {
    //     qDeleteAll(_plugins);
    //     _plugins.clear();
    // }

    // for (auto &file : pluginFiles) {
    //     QPluginLoader loader{file};
    //     if (loader.load()) {
    //         _plugins << loader.instance();
    //         count++;
    //     } else {
    //         qDebug().noquote().nospace()
    //             << "Error loading plugin: " << file << ". Message=" << loader.errorString();
    //     }
    // }
    return count;
}

PluginLoader *PluginLoader::instance()
{
    static PluginLoader instance;
    return &instance;
}

QList<QObject *> PluginLoader::plugins() const
{
    return _plugins;
}
