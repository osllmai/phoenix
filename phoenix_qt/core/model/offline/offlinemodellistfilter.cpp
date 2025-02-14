#include "offlinemodellistfilter.h"
#include "offlinemodellist.h"

OfflineModelListFilter::OfflineModelListFilter(QObject *parent)
    :m_searchTerm(""), QSortFilterProxyModel(parent)
{}

bool OfflineModelListFilter::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const{

    QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
    QString name = sourceModel()->data(index, OfflineModelList::NameRole).toString();
    bool isLikeModel = sourceModel()->data(index, OfflineModelList::IsLikeRole).toBool();
    bool isDownloading = sourceModel()->data(index, OfflineModelList::IsDownloadingRole).toBool();
    bool downloadFinished = sourceModel()->data(index, OfflineModelList::DownloadFinishedRole).toBool();

    // auto company = sourceModel()->at(index);

    switch (m_filterType) {
    case FilterType::All:
        if(!m_searchTerm.isEmpty() && !name.contains(m_searchTerm))
            return false;
        return true;
    case FilterType::Company:
        if(!m_searchTerm.isEmpty() && !name.contains(m_searchTerm))
            return false;
        // return company->id() == m_company->id();
        return true;
    case FilterType::DownloadFinished:
        if(!m_searchTerm.isEmpty() && !name.contains(m_searchTerm))
            return false;
        return downloadFinished;
    case FilterType::Favorite:
        if(!m_searchTerm.isEmpty() && !name.contains(m_searchTerm))
            return false;
        return isLikeModel;
    case FilterType::IsDownloading:
        return isDownloading;
    default:
        return true;
    }
}

OfflineModel* OfflineModelListFilter::at(int index){
    if (index < 0 || index >= rowCount())
        return nullptr;

    QModelIndex modelIndex = this->index(index, 0);
    QModelIndex sourceIndex = mapToSource(modelIndex);
    return sourceModel()->data(sourceIndex, OfflineModelList::OfflineModelRoles::ModelObjectRole).value<OfflineModel*>();
}

const QString &OfflineModelListFilter::searchTerm() const{return m_searchTerm;}
void OfflineModelListFilter::setSearchTerm(const QString &newSearchTerm){
    if (m_searchTerm == newSearchTerm)
        return;
    m_searchTerm = newSearchTerm;
    invalidateFilter();
    emit searchTermChanged();
}

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
