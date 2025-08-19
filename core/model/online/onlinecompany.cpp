#include "onlinecompany.h"

#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QtConcurrent>
#include <QCoreApplication>
#include <QDateTime>
#include <QDebug>

OnlineCompany::OnlineCompany(const int id, const QString& name, const QString& icon,
                             const BackendType backend, const QString& filePath, QString key, QObject* parent)
    : Company(id, name, icon, backend, filePath, parent), m_key(key)
{
    m_onlineModelList = new OnlineModelList(this);

    connect(&m_futureWatcher, &QFutureWatcher<QList<QVariantMap>>::finished,
            this, &OnlineCompany::onModelsLoaded);

    auto future = QtConcurrent::run([filePath]() -> QList<QVariantMap> {
        QList<QVariantMap> models;

        QFile file(QCoreApplication::applicationDirPath() + "/models/" + filePath);
        if (!file.open(QIODevice::ReadOnly)) {
            qWarning() << "Cannot open JSON file:" << filePath;
            return models;
        }

        QByteArray jsonData = file.readAll();
        file.close();

        QJsonParseError err;
        QJsonDocument document = QJsonDocument::fromJson(jsonData, &err);
        if (err.error != QJsonParseError::NoError) {
            qWarning() << "ERROR parsing JSON:" << err.errorString();
            return models;
        }

        QJsonArray jsonArray = document.array();
        for (const QJsonValue &value : jsonArray) {
            if (!value.isObject()) continue;
            QJsonObject obj = value.toObject();

            QVariantMap m;
            m["id"] = -1;
            m["name"] = obj["name"].toString();
            m["modelName"] = obj["modelName"].toString();
            m["icon"] = "icon()";
            m["description"] = obj["description"].toString();
            m["type"] = obj["type"].toString();
            m["promptTemplate"] = obj["promptTemplate"].toString();
            m["systemPrompt"] = obj["systemPrompt"].toString();
            m["recommended"] = obj["recommended"].toBool();
            m["inputPricePer1KTokens"] = obj["inputPricePer1KTokens"].toDouble();
            m["outputPricePer1KTokens"] = obj["outputPricePer1KTokens"].toDouble();
            m["contextWindows"] = obj["contextWindows"].toString();
            m["commercial"] = obj["commercial"].toBool();
            m["pricey"] = obj["pricey"].toBool();
            m["output"] = obj["output"].toString();
            m["comments"] = obj["comments"].toString();

            models.append(m);
        }
        return models;
    });

    m_futureWatcher.setFuture(future);
}

OnlineModelList *OnlineCompany::onlineModelList() const { return m_onlineModelList; }

OnlineCompany::~OnlineCompany() {}

QString OnlineCompany::key() const { return m_key; }
void OnlineCompany::setKey(const QString &newKey) {
    if (m_key == newKey)
        return;
    m_key = newKey;
    emit keyChanged();
}

void OnlineCompany::onModelsLoaded(){
    QList<QVariantMap> models = m_futureWatcher.result();
    for (const auto &m : models) {
        m_onlineModelList->addModel(m);
    }

    emit onlineModelListChanged();
}

