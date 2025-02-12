#ifndef OFFLINEMODELLIST_H
#define OFFLINEMODELLIST_H

#include <QObject>
#include <QQmlEngine>
#include <QtQml>
#include <QAbstractListModel>

#include <QFutureWatcher>
#include <QtConcurrent>

#include "offlinemodel.h"
#include "../company.h"

class OfflineModelList: public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)

public:
    static OfflineModelList* instance(QObject* parent = nullptr);
    void loadFromJsonAsync(const QList<Company*> companys);

    enum OfflineModelRoles {
        IdRole = Qt::UserRole + 1,
        NameRole,
        InformationRole,
        IconModelRole,
        IsLikeRole,
        AddModelTimeRole,
        FileSizeRole,
        RamRamrequiredRole,
        ParametersRole,
        QuantRole,
        DownloadFinishedRole,
        IsDownloadingRole
    };

    int count() const;
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;

    Q_INVOKABLE OfflineModel* at(int index) const;

    bool containsId(int id) const;

public slots:
    void setModelList(QList<OfflineModel*> models);

signals:
    void countChanged();

private:
    explicit OfflineModelList(QObject* parent);
    static OfflineModelList* m_instance;

    QList<OfflineModel*> m_models;
};

#endif // OFFLINEMODELLIST_H
