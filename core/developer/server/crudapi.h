#ifndef CRUDAPI_H
#define CRUDAPI_H

#include "utils.h"

#include <QtHttpServer/QHttpServer>
#include <QtConcurrent/qtconcurrentrun.h>
#include <QtCore/QFile>
#include <QtCore/QJsonArray>
#include <QtCore/QJsonObject>
#include <QtCore/QList>
#include <QtCore/QPair>
#include <QJsonParseError>

#include <QObject>

#include <optional>

class CrudAPI: public QObject
{
public:
    explicit CrudAPI(const QString &scheme, const QString &hostName, int port);

    virtual ~CrudAPI() = default;

    virtual QHttpServerResponse getFullList() const = 0;

    virtual QHttpServerResponse getItem(qint64 itemId) const = 0;

    virtual QHttpServerResponse postItem(const QHttpServerRequest &request) = 0;

    virtual QHttpServerResponse updateItem(qint64 itemId, const QHttpServerRequest &request) = 0;

    virtual QHttpServerResponse updateItemFields(qint64 itemId, const QHttpServerRequest &request) = 0;

    virtual QHttpServerResponse deleteItem(qint64 itemId) = 0;

    std::optional<QJsonObject> byteArrayToJsonObject(const QByteArray &arr);

    QString getScheme() const;

    QString getHostName() const;

    int getPort() const;

private:
    QString scheme;
    QString hostName;
    int port;
};


#endif // CRUDAPI_H
