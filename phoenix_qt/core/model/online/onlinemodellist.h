#ifndef ONLINEMODELLIST_H
#define ONLINEMODELLIST_H

#include <QObject>
#include <QQmlEngine>
#include <QtQml>
#include <QAbstractListModel>

#include "onlinemodel.h"

class OnlineModelList: public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)

public:
    explicit OnlineModelList(QObject* parent);

    enum OnlineModelRoles {
        IdRole = Qt::UserRole + 1,
        NameRole,
        InformationRole,
        IconModelRole,
        IsLikeRole,
        AddModelTimeRole,
        TypeRole,
        ContextWindowsRole,
        OutputRole,
        CommercialRole,
        InstallModelRole
    };

    int count() const;
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;

    Q_INVOKABLE OnlineModel* at(int index) const;

signals:
    void countChanged();

private:
    QList<OnlineModel*> models;
};

#endif // ONLINEMODELLIST_H
