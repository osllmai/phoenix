#include "offlinemodellistfilter.h"
#include "offlinemodellist.h"

OfflineModelListFilter::OfflineModelListFilter(QAbstractItemModel *models, QObject *parent): QSortFilterProxyModel(parent), m_filterType(FilterType::All){
    QSortFilterProxyModel::setSourceModel(models);

    setFilterCaseSensitivity(Qt::CaseInsensitive);
    setFilterRole(OfflineModelList::OfflineModelRoles::NameRole);

    setSortRole(OfflineModelList::OfflineModelRoles::NameRole);
    sort(0, Qt::AscendingOrder);
}


bool OfflineModelListFilter::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const{

    QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
    if (!index.isValid())
        return false;

    QString name = sourceModel()->data(index, OfflineModelList::OfflineModelRoles::NameRole).toString();
    bool isLikeModel = sourceModel()->data(index, OfflineModelList::OfflineModelRoles::IsLikeRole).toBool();
    bool isDownloading = sourceModel()->data(index, OfflineModelList::OfflineModelRoles::IsDownloadingRole).toBool();
    bool downloadFinished = sourceModel()->data(index, OfflineModelList::OfflineModelRoles::DownloadFinishedRole).toBool();

    QVariant modelVariant = sourceModel()->data(index, OfflineModelList::OfflineModelRoles::ModelObjectRole);
    OfflineModel* model = modelVariant.value<OfflineModel*>();

    if (!model) return false;

    QRegularExpression filterExp = filterRegularExpression();
    bool matchesFilter = filterExp.pattern().isEmpty() || filterExp.match(name).hasMatch();

    switch (m_filterType) {
    case FilterType::All:
        return matchesFilter;
    case FilterType::Company:
        return matchesFilter && m_company && model->company() && model->company()->id() == m_company->id();;
    case FilterType::DownloadFinished:
        return matchesFilter && downloadFinished;
    case FilterType::Favorite:
        return matchesFilter && isLikeModel;
    case FilterType::IsDownloading:
        return matchesFilter && isDownloading;
    default:
        return true;
    }
}

// const QString &OfflineModelListFilter::searchTerm() const{return m_searchTerm;}
// void OfflineModelListFilter::setSearchTerm(const QString &newSearchTerm){
//     if (m_searchTerm == newSearchTerm)
//         return;
//     m_searchTerm = newSearchTerm;
//     invalidateFilter();
//     emit searchTermChanged();
// }

Company *OfflineModelListFilter::company() const{return m_company;}
void OfflineModelListFilter::setCompany(Company *newCompany){
    if (m_company == newCompany)
        return;
    m_company = newCompany;
    setFilterType(FilterType::Company);
    emit companyChanged();
}

OfflineModelListFilter::FilterType OfflineModelListFilter::filterType() const{return m_filterType;}
void OfflineModelListFilter::setFilterType(FilterType newFilterType){
    if (m_filterType == newFilterType)
        return;
    m_filterType = newFilterType;
    invalidateFilter();
    emit filterTypeChanged();
}
