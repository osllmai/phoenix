#ifndef ONLINECOMPANY_H
#define ONLINECOMPANY_H

#include <QObject>
#include <QQmlEngine>

#include "company.h"
#include "onlinemodellist.h"

class OnlineCompany: public Company
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(OnlineModelList *onlineModelList READ onlineModelList NOTIFY onlineModelListChanged FINAL)

public:
    explicit OnlineCompany(QObject* parent = nullptr) : Company(parent) {}

    explicit OnlineCompany(const int id, const QString& name, const QString& icon,
                           const BackendType backend, const QString& filePath, QObject* parent);

    virtual ~OnlineCompany();

    OnlineModelList *onlineModelList() const;

signals:
    void onlineModelListChanged();

private:
    OnlineModelList *m_onlineModelList;
};

#endif // ONLINECOMPANY_H
