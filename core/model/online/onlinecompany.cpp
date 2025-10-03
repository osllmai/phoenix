#include "onlinecompany.h"

#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QtConcurrent>
#include <QCoreApplication>
#include <QDateTime>
#include <QDebug>

OnlineCompany::OnlineCompany(const int id, const QString& name, const QString& icon, const bool isLike,
                             const BackendType backend, const QString& filePath, QString key, bool installModel, QObject* parent)
    : Company(id, name, icon, backend, filePath, parent), m_key(key), m_isLike(isLike), m_installModel(installModel)
{
    m_onlineModelList = new OnlineModelList(this);

    qInfo()<<name;

    connect(&m_futureWatcher, &QFutureWatcher<QList<QVariantMap>>::finished,
            this, &OnlineCompany::onModelsLoaded);

    QString companyIcon = icon;

    auto future = QtConcurrent::run([filePath, companyIcon, name]() -> QList<QVariantMap> {
        QList<QVariantMap> models;

        QString fullPath = QCoreApplication::applicationDirPath() + "/models/online_models/online_models.json";
        QFile file(fullPath);
        if (!file.exists()) {
            qWarning() << "No local JSON file found for:" << fullPath;
            return models;
        }

        if (!file.open(QIODevice::ReadOnly)) {
            qWarning() << "Cannot open JSON file:" << fullPath;
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

        QJsonArray companiesArray = document.array();
        for (const QJsonValue &companyVal : companiesArray) {
            if (!companyVal.isObject()) continue;
            QJsonObject companyObj = companyVal.toObject();

            if (companyObj["name"].toString().compare(name, Qt::CaseInsensitive) != 0)
                continue;

            QJsonArray modelArray = companyObj["text_completions"].toArray();
            for (const QJsonValue &modelVal : modelArray) {
                if (!modelVal.isObject()) continue;
                QJsonObject obj = modelVal.toObject();

                QVariantMap m;
                m["id"] = models.size();
                m["name"] = obj["name"].toString();
                m["modelName"] = obj["modelName"].toString();
                m["icon"] = companyIcon;
                m["description"] = obj["description"].toString();
                m["type"] = "Text Generation";
                m["promptTemplate"] = "<s>[INST] %1 [/INST] %2 </s>";
                m["systemPrompt"]   = "";

                QJsonObject meta = obj["metadata"].toObject();
                m["comments"] = meta["comments"].toString();
                m["pricey"]   = obj["pricing"].toObject()["pricey"].toBool();

                m["contextWindows"] = "";

                models.append(m);
            }
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

const bool OnlineCompany::installModel() const{ return m_installModel;}
void OnlineCompany::setInstallModel(const bool newInstallModel){
    if (m_installModel == newInstallModel)
        return;
    m_installModel = newInstallModel;
    emit installModelChanged();
}

void OnlineCompany::onModelsLoaded(){
    QList<QVariantMap> models = m_futureWatcher.result();
    for (const auto &m : models) {
        m_onlineModelList->addModel(m);
    }
    emit onlineModelListChanged();
}

const bool OnlineCompany::isLike() const{return m_isLike;}
void OnlineCompany::setIsLike(const bool isLike){
    if(m_isLike == isLike)
        return;
    m_isLike = isLike;
    emit isLikeChanged();
}
