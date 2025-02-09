#ifndef OFFLINEMODELLISTFILTER_H
#define OFFLINEMODELLISTFILTER_H

#include <QSortFilterProxyModel>
#include "../company.h"
#include "../companylist.h"

class OfflineModelListFilter: public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(QString searchTerm READ searchTerm WRITE setSearchTerm NOTIFY searchTermChanged FINAL)
    Q_PROPERTY(FilterType filterType READ filterType WRITE setFilterType NOTIFY filterTypeChanged FINAL)
    Q_PROPERTY(Company *company READ company WRITE setCompany NOTIFY companyChanged FINAL)
public:
    explicit OfflineModelListFilter(QObject *parent);

    enum class FilterType {
        IsDownloading,
        DownloadFinished,
        Company,
        Favorite,
        All
    };
    Q_ENUM(FilterType)

    const QString &searchTerm() const;
    void setSearchTerm(const QString &newSearchTerm);

    FilterType filterType() const;
    void setFilterType(FilterType newFilterType);

    Company *company() const;
    void setCompany(Company *newCompany);

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;

signals:
    void searchTermChanged();
    void filterTypeChanged();
    void companyChanged();

private:
    QString m_searchTerm;
    FilterType m_filterType{FilterType::All};
    Company *m_company;
};

#endif // OFFLINEMODELLISTFILTER_H
