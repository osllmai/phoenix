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
    Q_PROPERTY(int companyId READ companyId WRITE setCompanyId NOTIFY companyIdChanged FINAL)
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

    int companyId() const;
    void setCompanyId(const int newCompany);

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;

signals:
    void filterTypeChanged();
    void companyIdChanged();

private:
    FilterType m_filterType;
    int m_companyId;
};

#endif // OFFLINEMODELLISTFILTER_H
