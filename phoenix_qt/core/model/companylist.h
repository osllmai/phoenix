#ifndef COMPANYLIST_H
#define COMPANYLIST_H

#include <QObject>
#include <QQmlEngine>
#include <QtQml>
#include <QAbstractListModel>

#include <QFutureWatcher>
#include <QtConcurrent>

#include "company.h"

class CompanyList: public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged CONSTANT FINAL)

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
    void requestReadModel(const QList<Company*> companys);

private:
    explicit CompanyList(QObject* parent);
    static CompanyList* m_instance;

    QList<Company*> m_companys;
    QFutureWatcher<QList<Company*>> futureWatcher;

    static QList<Company*> parseJson(const QString &filePath);
};

#endif // COMPANYLIST_H
