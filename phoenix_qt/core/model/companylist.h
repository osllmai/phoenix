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
    static CompanyList* instance(QObject* parent = nullptr);

    enum CompanyRoles {
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

    explicit CompanyList(QObject* parent);
    static CompanyList* m_instance;
};

#endif // COMPANYLIST_H
