#ifndef ONLINECOMPANYLISTFILTER_H
#define ONLINECOMPANYLISTFILTER_H

#include <QObject>
#include <QtQml>
#include <QQmlEngine>
#include <QSortFilterProxyModel>
#include "onlinecompanylist.h"

class OnlineCompanyListFilter: public QSortFilterProxyModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)

public:
    explicit OnlineCompanyListFilter(QObject* parent = nullptr) : QSortFilterProxyModel(parent) {}
    explicit OnlineCompanyListFilter(QAbstractItemModel *model, QObject *parent);


    int count() const;

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;

signals:
    void countChanged();
    void filterTypeChanged();
    void companyIdChanged();
    void typeChanged();

private:
};

#endif // ONLINECOMPANYLISTFILTER_H
