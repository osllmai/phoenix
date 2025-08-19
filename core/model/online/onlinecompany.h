#ifndef ONLINECOMPANY_H
#define ONLINECOMPANY_H

#include <QObject>
#include <QQmlEngine>
#include <QFutureWatcher>

#include "company.h"
#include "onlinemodellist.h"

class OnlineCompany: public Company
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(OnlineModelList *onlineModelList READ onlineModelList NOTIFY onlineModelListChanged FINAL)
    Q_PROPERTY(QString key READ key WRITE setKey NOTIFY keyChanged FINAL)

public:
    explicit OnlineCompany(QObject* parent = nullptr) : Company(parent) {}

    explicit OnlineCompany(const int id, const QString& name, const QString& icon,
                           const BackendType backend, const QString& filePath, QString key, QObject* parent);

    virtual ~OnlineCompany();

    OnlineModelList *onlineModelList() const;

    QString key() const;
    void setKey(const QString &newKey);

signals:
    void onlineModelListChanged();
    void keyChanged();

private slots:
    void onModelsLoaded();

private:
    OnlineModelList *m_onlineModelList = nullptr;
    QString m_key;

    QFutureWatcher<QList<QVariantMap>> m_futureWatcher;
};

#endif // ONLINECOMPANY_H
