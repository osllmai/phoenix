#ifndef OFFLINEMODELLIST_H
#define OFFLINEMODELLIST_H

#include <QObject>
#include <QQmlEngine>
#include <QtQml>
#include <QAbstractListModel>

#include "offlinemodel.h"

class OfflineModelList: public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)

public:
    explicit OfflineModelList(QObject* parent);

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

signals:
    void countChanged();

private:
    QList<OfflineModel*> models;
};

#endif // OFFLINEMODELLIST_H
