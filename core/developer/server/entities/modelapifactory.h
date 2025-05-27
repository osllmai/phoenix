#ifndef MODELAPIFACTORY_H
#define MODELAPIFACTORY_H

#include <QtGui/QColor>
#include <QtCore/QDateTime>
#include <QtCore/QJsonArray>
#include <QtCore/QJsonObject>
#include <QtCore/QJsonParseError>
#include <QtCore/QString>
#include <QtCore/qtypes.h>

#include <algorithm>
#include <optional>
#include "../apiserver.h"
#include "./chatapi.h"

struct ModelAPIFactory : public FromJsonFactory<ChatAPI>
{
    ModelAPIFactory(const QString &scheme, const QString &hostName, int port);

    std::optional<ChatAPI> fromJson(const QJsonObject &json) const override;

private:
    QString scheme;
    QString hostName;
    int port;
};

#endif // MODELAPIFACTORY_H
