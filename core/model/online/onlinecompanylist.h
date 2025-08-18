#ifndef ONLINECOMPANYLIST_H
#define ONLINECOMPANYLIST_H

#include <QObject>
#include <QAbstractListModel>
#include <QFutureWatcher>
#include <QtConcurrent>

#include "onlinecompany.h"

class OnlineCompanyList: public QAbstractListModel
{
    Q_OBJECT
    QML_SINGLETON
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)

public:
    static OnlineCompanyList* instance(QObject* parent );

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
    void sortingFinished();

public slots:
    void finalizeSetup();
    void addProvider(const int id, const QString& name, const QString& icon,
                     const BackendType backend, const QString& filePath, QString key);

private slots:
    void handleSortingFinished();

private:
    explicit OnlineCompanyList(QObject* parent);
    static OnlineCompanyList* m_instance;

    QList<OnlineCompany*> m_companys;
    QFutureWatcher<QList<OnlineCompany*>> m_sortWatcher;
};

#endif // ONLINECOMPANYLIST_H
