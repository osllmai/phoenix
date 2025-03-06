#ifndef COMPANYLISTFILTER_H
#define COMPANYLISTFILTER_H

#include <QSortFilterProxyModel>
#include <QObject>
#include <QtQml>
#include <QQmlEngine>

#include "BackendType.h"
#include "./companylist.h"
#include "./company.h"

class CompanyListFilter: public QSortFilterProxyModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(BackendType backendType READ backendType WRITE setBackendType NOTIFY backendTypeChanged)

public:
    explicit CompanyListFilter(QAbstractItemModel *model, BackendType backendType, QObject *parent);

    const BackendType backendType() const;
    void setBackendType(const BackendType type);

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;

signals:
    void backendTypeChanged();

private:
    BackendType m_backendType;
};

#endif // COMPANYLISTFILTER_H
