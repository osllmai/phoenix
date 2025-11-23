#ifndef MODELMANAGER_H
#define MODELMANAGER_H

#include <QObject>
#include <QQmlEngine>
#include <QDateTime>
#include <QSqlError>
#include <QSqlQuery>
#include <QThread>
#include <QStandardPaths>
#include <QFile>
#include <QJsonParseError>
#include <QFileInfo>
#include <QDir>
#include <QJsonArray>
#include <QJsonObject>

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QEventLoop>

#include "./model/offline/offlinemodel.h"
#include "./model/online/onlinemodel.h"
#include "./model/BackendType.h"
#include "./model/company.h"
#include "config.h"

class ModelManager : public QObject
{
    Q_OBJECT
    QML_SINGLETON
public:
    explicit ModelManager(QSqlDatabase db, QObject* parent = nullptr);
    virtual ~ModelManager();

    void readModel(const QList<Company*> companys);
    void deleteModel(const int id);
    void updateKeyModel(const int id, const QString &key);
    void updateIsLikeModel(const int id, const bool isLike);
    void addModel(const QString &name, const QString &key);
    void addHuggingfaceModel(const QString &name, const QString &url, const QString& type,
                             const QString &companyName, const QString &companyIcon, const QString &currentFolder);

signals:
    void addOnlineProvider(const int id, const QString& name, const QString& icon, const bool isLike,
                           const BackendType backend, const QString& filePath, QString key);

    void addOfflineModel(Company* company, const double fileSize, const int ramRamrequired, const QString& fileName, const QString& url,
                         const QString& parameters, const QString& quant, const double downloadPercent,
                         const bool isDownloading, const bool downloadFinished,

                         const int id, const QString& modelName, const QString& name, const QString& key, QDateTime addModelTime,
                         const bool isLike, const QString& type, const BackendType backend,
                         const QString& icon , const QString& information , const QString& promptTemplate ,
                         const QString& systemPrompt, QDateTime expireModelTime, const bool recommended, const QString &currentFolder);

    void finishedReadOnlineModel();
    void finishedReadOfflineModel();
    void finishedAddModel(const QString &fileName);

private:
    QSqlDatabase m_db;

    static const QString MODEL_SQL;
    static const QString INSERT_MODEL_SQL;
    static const QString READALL_MODEL_SQL;
    static const QString READ_MODEL_SQL;
    static const QString READ_MODEL_ID_SQL;
    static const QString UPDATE_KEYMODEL_SQL;
    static const QString UPDATE_ISLIKE_SQL;
    static const QString DELETE_MODEL_SQL;

    int insertModel(const QString &name, const QString &key);
    QList<int> readOnlineCompany();
};

#endif // MODELMANAGER_H
