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
    static OnlineModelList* instance(QObject* parent = nullptr);

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

public slots:
    void setModelList(QList<OnlineModel*> models);

signals:
    void countChanged();

private:
    QList<OnlineModel*> m_models;

    explicit OnlineModelList(QObject* parent);
    static OnlineModelList* m_instance;
};

#endif // ONLINEMODELLIST_H
