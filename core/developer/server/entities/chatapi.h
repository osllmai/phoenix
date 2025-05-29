#ifndef CHATAPI_H
#define CHATAPI_H

#include <QtGui/QColor>
#include <QtCore/QDateTime>
#include <QtCore/QJsonArray>
#include <QtCore/QJsonObject>
#include <QtCore/QJsonParseError>
#include <QtCore/QString>
#include <QtCore/qtypes.h>
#include <QList>

#include <algorithm>
#include <optional>
#include "../crudapi.h"

#include "onlinemodel.h"
#include "offlinemodel.h"
#include "onlinemodellist.h"
#include "offlinemodellist.h"
#include "offlinemodellistfilter.h"
#include "onlinemodellistfilter.h"

struct ChatAPI : public CrudAPI
{
    ChatAPI(const QString &scheme, const QString &hostName, int port);

    QHttpServerResponse getFullList() const override;

    QHttpServerResponse getItem(qint64 itemId) const override;

    QHttpServerResponse postItem(const QHttpServerRequest &request) override ;

    QHttpServerResponse updateItem(qint64 itemId, const QHttpServerRequest &request) override;

    QHttpServerResponse updateItemFields(qint64 itemId, const QHttpServerRequest &request) override;

    QHttpServerResponse deleteItem(qint64 itemId) override;

private:
    QJsonArray extractModelsAsJsonArray(QSortFilterProxyModel* proxyModel) const;
};

#endif // CHATAPI_H
