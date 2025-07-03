#ifndef OFFLINEMODELLIST_H
#define OFFLINEMODELLIST_H

#include <QObject>
#include <QQmlEngine>
#include <QAbstractListModel>
#include <algorithm>
#include <QFileInfo>

#include <QFutureWatcher>

#include "offlinemodel.h"
#include "../company.h"
#include "./download.h"

class OfflineModelList: public QAbstractListModel
{
    Q_OBJECT
    QML_SINGLETON
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)
    Q_PROPERTY(double downloadProgress READ downloadProgress NOTIFY downloadProgressChanged FINAL)

public:
    static OfflineModelList* instance(QObject* parent );
    OfflineModel* findModelById(const int id);
    OfflineModel* findModelByModelName(const QString modelName);
    void loadFromJsonAsync(const QList<Company*> companys);

    enum OfflineModelRoles {
        IdRole = Qt::UserRole + 1,
        NameRole,
        ModeNameRole,
        KeyRole,
        InformationRole,
        TypeRole,
        IconRole,
        CompanyRole,
        IsLikeRole,
        AddModelTimeRole,
        FileSizeRole,
        RamRamrequiredRole,
        ParametersRole,
        QuantRole,
        DownloadFinishedRole,
        IsDownloadingRole,
        DownloadPercentRole,
        ModelObjectRole
    };

    int count() const;
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;

    Q_INVOKABLE void likeRequest(const int id, const bool isLike);
    Q_INVOKABLE void downloadRequest(const int id, QString directoryPath);
    Q_INVOKABLE void cancelRequest(const int id);
    Q_INVOKABLE void deleteRequest(const int id);
    Q_INVOKABLE void addRequest(QString directoryPath);

    double downloadProgress() const;


public slots:
    void addModel(const double fileSize, const int ramRamrequired, const QString& fileName, const QString& url,
                  const QString& parameters, const QString& quant, const double downloadPercent,
                  const bool isDownloading, const bool downloadFinished,

                  const int id, const QString& modelName, const QString& name, const QString& key, QDateTime addModelTime,
                  const bool isLike, Company* company, const QString& type, const BackendType backend,
                  const QString& icon , const QString& information , const QString& promptTemplate ,
                  const QString& systemPrompt, QDateTime expireModelTime, const bool recommended);

    void handleDownloadProgress(const int id, const qint64 bytesReceived, const qint64 bytesTotal);
    void handleDownloadFinished(const int id);
    void handleDownloadFailed(const int id, const QString &error);

signals:
    void countChanged();
    void downloadProgressChanged();
    void downloadingChanged();
    void requestAddModel(const QString &name, const QString &key);
    void requestDeleteModel(const int id);
    void requestUpdateKeyModel(const int id, const QString &key);
    void requestUpdateIsLikeModel(const int id, const bool isLike);

private:
    explicit OfflineModelList(QObject* parent);
    static OfflineModelList* m_instance;

    QList<OfflineModel*> m_models;
    QList<Download*>downloads;
    double m_downloadProgress;

    OfflineModel* at(int index) const;
    void updateDownloadProgress();
    void deleteDownloadModel(const int id);

};

#endif // OFFLINEMODELLIST_H
