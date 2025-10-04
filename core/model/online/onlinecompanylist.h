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
    static OnlineCompanyList* instance(QObject* parent);
    OnlineCompany* findCompanyById(const int id);
    OnlineCompany* findCompanyByName(const QString name);

    Q_INVOKABLE void sortAsync(int role, Qt::SortOrder order = Qt::AscendingOrder);
    Q_INVOKABLE void likeRequest(const int id, const bool isLike);
    Q_INVOKABLE void saveAPIKey(const int id, QString key);
    Q_INVOKABLE void deleteRequest(const int id);

    enum CompanyRoles {
        IDRole = Qt::UserRole + 1,
        NameRole,
        IconRole,
        IsLikeRole,
        InstallModelRole,
        KeyRole,
        BackendRole,
        CompanyObjectRole,
        OnlineModelListRole
    };

    int count() const;
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override ;

signals:
    void countChanged();
    void sortingFinished();
    void requestUpdateKeyModel(const int id, const QString &key);
    void requestUpdateIsLikeModel(const int id, const bool isLike);

public slots:
    void finalizeSetup();
    void addProvider(const int id, const QString& name, const QString& icon, const bool isLike,
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
