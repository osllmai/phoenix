#ifndef CHATAPIFACTORY_H
#define CHATAPIFACTORY_H

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

struct ChatAPIFactory : public FromJsonFactory<ChatAPI>
{
    ChatAPIFactory(const QString &scheme, const QString &hostName, int port);

    std::optional<ChatAPI> fromJson(const QJsonObject &json) const override;

private:
    QString scheme;
    QString hostName;
    int port;
};

#endif // CHATAPIFACTORY_H
