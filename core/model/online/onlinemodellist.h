#ifndef ONLINEMODELLIST_H
#define ONLINEMODELLIST_H

#include <QObject>
#include <QQmlEngine>
#include <QAbstractListModel>
#include <QFutureWatcher>
#include <QtConcurrent>

#include "onlinemodel.h"

class OnlineModelList: public QAbstractListModel
{
    Q_OBJECT
    QML_SINGLETON
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)

public:
    static OnlineModelList* instance(QObject* parent );
    OnlineModel* findModelById(const int id);
    OnlineModel* findModelByModelName(const QString modelName);

    enum OnlineModelRoles {
        IdRole = Qt::UserRole + 1,
        NameRole,
        ModelNameRole,
        KeyRole,
        InformationRole,
        TypeRole,
        IconModelRole,
        IsLikeRole,
        AddModelTimeRole,
        ContextWindowsRole,
        OutputRole,
        CommercialRole,
        InstallModelRole,
        ModelObjectRole
    };

    int count() const;
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;

    Q_INVOKABLE OnlineModel* at(int index) const;
    Q_INVOKABLE void likeRequest(const int id, const bool isLike);
    Q_INVOKABLE void saveAPIKey(const int id, QString key);
    Q_INVOKABLE void deleteRequest(const int id);
    Q_INVOKABLE void sortAsync(int role, Qt::SortOrder order = Qt::AscendingOrder);

signals:
    void countChanged();
    void requestUpdateKeyModel(const int id, const QString &key);
    void requestUpdateIsLikeModel(const int id, const bool isLike);
    void sortingFinished();

public slots:
    // void addModel(const int id, const QString& modelName, const QString& name, const QString& key,
    //               QDateTime addModelTime, const bool isLike, const QString& type, const BackendType backend,
    //               const QString& icon , const QString& information , const QString& promptTemplate ,
    //               const QString& systemPrompt, QDateTime expireModelTime, const bool recommended,

    //               const double inputPricePer1KTokens, const double outputPricePer1KTokens,
    //               const QString& contextWindows, const bool commercial, const bool pricey,
    //               const QString& output, const QString& comments, const bool installModel);

    void finalizeSetup();

private slots:
    void handleSortingFinished();

private:
    QList<OnlineModel*> m_models;
    QFutureWatcher<QList<OnlineModel*>> m_sortWatcher;

    explicit OnlineModelList(QObject* parent);
    static OnlineModelList* m_instance;
};

#endif // ONLINEMODELLIST_H
