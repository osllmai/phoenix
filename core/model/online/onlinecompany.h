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
    OnlineCompany();
    explicit OnlineCompany(QObject* parent = nullptr) : Company(parent) {}

    // explicit OnlineCompany(Company* company, QObject* parent);

    virtual ~OnlineCompany();

    OnlineModelList *onlineModelList() const;

signals:
    void onlineModelListChanged();

private:
    OnlineModelList *m_onlineModelList;
};

#endif // ONLINECOMPANY_H
