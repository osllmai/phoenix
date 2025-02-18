#ifndef OFFLINEMODELLIST_H
#define OFFLINEMODELLIST_H

#include <QObject>
#include <QtQml>
#include <QQmlEngine>
#include <QAbstractListModel>

#include <QFutureWatcher>
#include <QtConcurrent>

#include "offlinemodel.h"
#include "../company.h"

class OfflineModelList: public QAbstractListModel
{
    Q_OBJECT
    // QML_ELEMENT
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)

public:
    static OfflineModelList* instance(QObject* parent );
    void loadFromJsonAsync(const QList<Company*> companys);

    enum OfflineModelRoles {
        IdRole = Qt::UserRole + 1,
        NameRole,
        InformationRole,
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

    Q_INVOKABLE OfflineModel* at(int index) const;
    Q_INVOKABLE void likeRequest(const int id, const bool isLike);
    Q_INVOKABLE void downloadRequest(const int id, QString directoryPath);
    Q_INVOKABLE void cancelRequest(const int id);
    Q_INVOKABLE void deleteRequest(const int id);
    Q_INVOKABLE void addRequest(QString directoryPath);

public slots:
    void addModel(const double fileSize, const int ramRamrequired, const QString& fileName, const QString& url,
                  const QString& parameters, const QString& quant, const double downloadPercent,
                  const bool isDownloading, const bool downloadFinished,

                  const int id, const QString& name, const QString& key, QDateTime addModelTime,
                  const bool isLike, Company* company, const BackendType backend,
                  const QString& icon , const QString& information , const QString& promptTemplate ,
                  const QString& systemPrompt, QDateTime expireModelTime);

signals:
    void countChanged();
    void requestUpdateKeyModel(const int id, const QString &key);
    void requestUpdateIsLikeModel(const int id, const bool isLike);

private:
    explicit OfflineModelList(QObject* parent);
    static OfflineModelList* m_instance;

    QList<OfflineModel*> m_models;

    OfflineModel* findModelById(const int id);

};

#endif // OFFLINEMODELLIST_H
