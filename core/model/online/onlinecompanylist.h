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
    // void addModel(const int id, const QString& modelName, const QString& name, const QString& key,
    //               QDateTime addModelTime, const bool isLike, const QString& type, const BackendType backend,
    //               const QString& icon , const QString& information , const QString& promptTemplate ,
    //               const QString& systemPrompt, QDateTime expireModelTime, const bool recommended,

    //               const double inputPricePer1KTokens, const double outputPricePer1KTokens,
    //               const QString& contextWindows, const bool commercial, const bool pricey,
    //               const QString& output, const QString& comments, const bool installModel);

private slots:
    void handleSortingFinished();

private:
    explicit OnlineCompanyList(QObject* parent);
    static OnlineCompanyList* m_instance;

    QList<OnlineCompany*> m_companys;
    QFutureWatcher<QList<OnlineCompany*>> m_sortWatcher;
};

#endif // ONLINECOMPANYLIST_H
