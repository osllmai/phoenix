#ifndef COMPANYLIST_H
#define COMPANYLIST_H

#include <QObject>
#include <QQmlEngine>
#include <QtQml>
#include <QAbstractListModel>

#include "company.h"

class CompanyList: public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)

public:
    CompanyList(QObject* parent);

    enum CompanyListRoles {
        IDRole = Qt::UserRole + 1,
        NameRole,
        IconRole,
        BackendRole
    };

    int count() const;
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE Company* at(int index) const;

signals:
    void countChanged();

private:
    QList<Company*> m_companys;
};

#endif // COMPANYLIST_H
