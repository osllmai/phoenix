#ifndef OFFLINEMODELLISTFILTER_H
#define OFFLINEMODELLISTFILTER_H

#include <QSortFilterProxyModel>
#include "../company.h"
#include "../companylist.h"
#include "./offlinemodel.h"
#include "./offlinemodellist.h"

class OfflineModelListFilter: public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(FilterType filterType READ filterType WRITE setFilterType NOTIFY filterTypeChanged FINAL)
    Q_PROPERTY(Company *company READ company WRITE setCompany NOTIFY companyChanged FINAL)
public:
    explicit OfflineModelListFilter(QAbstractItemModel *model, QObject *parent);

    enum class FilterType {
        IsDownloading,
        DownloadFinished,
        Company,
        Favorite,
        All
    };
    Q_ENUM(FilterType)

    FilterType filterType() const;
    void setFilterType(FilterType newFilterType);

    Company *company() const;
    void setCompany(Company *newCompany);

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;

signals:
    void filterTypeChanged();
    void companyChanged();

private:
    FilterType m_filterType;
    Company *m_company;
};

#endif // OFFLINEMODELLISTFILTER_H
