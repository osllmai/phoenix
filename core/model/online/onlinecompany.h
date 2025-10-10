#ifndef ONLINECOMPANY_H
#define ONLINECOMPANY_H

#include <QObject>
#include <QQmlEngine>
#include <QtConcurrent/QtConcurrent>
#include <QFutureWatcher>

#include "company.h"
#include "onlinemodellist.h"

class OnlineCompany: public Company
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(OnlineModelList *onlineModelList READ onlineModelList NOTIFY onlineModelListChanged FINAL)
    Q_PROPERTY(QString key READ key WRITE setKey NOTIFY keyChanged FINAL)
    Q_PROPERTY(bool installModel READ installModel WRITE setInstallModel NOTIFY installModelChanged FINAL)
    Q_PROPERTY(bool isLike READ isLike WRITE setIsLike NOTIFY isLikeChanged FINAL)

public:
    explicit OnlineCompany(QObject* parent = nullptr) : Company(parent) {}

    explicit OnlineCompany(const int id, const QString& name, const QString& icon, const bool isLike,
                           const BackendType backend, const QString& filePath, QString key, bool installModel,  QObject* parent);

    virtual ~OnlineCompany();

    OnlineModelList *onlineModelList() const;

    QString key() const;
    void setKey(const QString &newKey);

    const bool isLike() const;
    void setIsLike(const bool isLike);

    const bool installModel() const;
    void setInstallModel(const bool newInstallModel);

signals:
    void onlineModelListChanged();
    void isLikeChanged();
    void keyChanged();
    void installModelChanged();

private slots:
    void onModelsLoaded();

private:
    OnlineModelList *m_onlineModelList = nullptr;
    QString m_key;
    bool m_installModel;
    bool m_isLike;

    QFutureWatcher<QList<QVariantMap>> m_futureWatcher;
};

#endif // ONLINECOMPANY_H
