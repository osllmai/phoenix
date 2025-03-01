#ifndef ONLINEMODELLISTFILTER_H
#define ONLINEMODELLISTFILTER_H

#include <QObject>
#include <QtQml>
#include <QQmlEngine>
#include <QSortFilterProxyModel>
#include "../company.h"
#include "../companylist.h"

class OnlineModelListFilter: public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)
    Q_PROPERTY(FilterType filterType READ filterType WRITE setFilterType NOTIFY filterTypeChanged FINAL)
    Q_PROPERTY(int companyId READ companyId WRITE setCompanyId NOTIFY companyIdChanged FINAL)
public:
    explicit OnlineModelListFilter(QAbstractItemModel *model, QObject *parent);

    Q_INVOKABLE void filter(QString filter);

    enum class FilterType {
        InstallModel,
        Company,
        Favorite,
        All
    };
    Q_ENUM(FilterType)

    int count() const;

    FilterType filterType() const;
    void setFilterType(FilterType newFilterType);

    int companyId() const;
    void setCompanyId(const int newCompany);

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;

signals:
    void countChanged();
    void filterTypeChanged();
    void companyIdChanged();

private:
    FilterType m_filterType;
    int m_companyId;
};


#endif // ONLINEMODELLISTFILTER_H
