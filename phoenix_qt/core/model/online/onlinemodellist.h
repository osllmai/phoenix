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
    // QML_ELEMENT
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)

public:
    static OnlineModelList* instance(QObject* parent );

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
    void addModel(const int id, const QString& name, const QString& key, QDateTime addModelTime,
                  const bool isLike, Company* company, const BackendType backend,
                  const QString& icon , const QString& information , const QString& promptTemplate ,
                  const QString& systemPrompt, QDateTime expireModelTime,

                  const QString& type, const double inputPricePer1KTokens, const double outputPricePer1KTokens,
                  const QString& contextWindows, const bool recommended, const bool commercial, const bool pricey,
                  const QString& output, const QString& comments, const bool installModel);

signals:
    void countChanged();
    void requestUpdateKeyModel(const int id, const QString &key);
    void requestUpdateIsLikeModel(const int id, const bool isLike);

private:
    QList<OnlineModel*> m_models;

    explicit OnlineModelList(QObject* parent);
    static OnlineModelList* m_instance;
};

#endif // ONLINEMODELLIST_H
