#ifndef MODELAPI_H
#define MODELAPI_H

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

struct ModelAPI : public Jsonable, public Updatable
{
    qint64 id;
    QString email;
    QString firstName;
    QString lastName;
    QUrl avatarUrl;
    QDateTime createdAt;
    QDateTime updatedAt;

    explicit ModelAPI(const QString &email, const QString &firstName, const QString &lastName,
                   const QUrl &avatarUrl,
                   const QDateTime &createdAt = QDateTime::currentDateTimeUtc(),
                   const QDateTime &updatedAt = QDateTime::currentDateTimeUtc());

    bool update(const QJsonObject &json) override;

    void updateFields(const QJsonObject &json) override;

    QJsonObject toJson() const override;

private:
    void updateTimestamp();

    static qint64 nextId()
    {
        static qint64 lastId = 1;
        return lastId++;
    }
};

#endif // MODELAPI_H
