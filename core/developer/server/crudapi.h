#ifndef CRUDAPI_H
#define CRUDAPI_H

#include "type.h"
#include "utils.h"

#include <QtHttpServer/QHttpServer>
#include <QtConcurrent/qtconcurrentrun.h>

#include <optional>

class CrudAPI
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

    QString getScheme() const;

    QString getHostName() const;

    int getPort() const;

private:
    QString scheme;
    QString hostName;
    int port;
};


#endif // CRUDAPI_H
