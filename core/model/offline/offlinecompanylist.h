#ifndef OFFLINECOMPANYLIST_H
#define OFFLINECOMPANYLIST_H

#include <QObject>
#include <QAbstractListModel>
#include <QFutureWatcher>
#include <QtConcurrent>

#include "company.h"

class OfflineCompanyList: public QAbstractListModel
{
    Q_OBJECT
    QML_SINGLETON
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)

public:
    static OfflineCompanyList* instance(QObject* parent );
    void readDB();

    Q_INVOKABLE void sortAsync(int role, Qt::SortOrder order = Qt::AscendingOrder);

    enum CompanyRoles {
        IDRole = Qt::UserRole + 1,
        NameRole,
        IconRole,
        BackendRole,
        CompanyObjectRole
    };

    int count() const;
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

signals:
    void countChanged();
    void requestReadModel(const QList<Company*> companys);
    void sortingFinished();

public slots:
    void finalizeSetup();

private slots:
    void handleSortingFinished();

private:
    explicit OfflineCompanyList(QObject* parent);
    static OfflineCompanyList* m_instance;

    QList<Company*> m_companys;
    QFutureWatcher<QList<Company*>> futureWatcher;
    QFutureWatcher<QList<Company*>> m_sortWatcher;

    static QList<Company*> parseJson(const QString &filePath);
};

#endif // OFFLINECOMPANYLIST_H
