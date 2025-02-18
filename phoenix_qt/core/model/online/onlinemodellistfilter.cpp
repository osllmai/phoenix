#include "onlinemodellistfilter.h"
#include "onlinemodellist.h"


OnlineModelListFilter::OnlineModelListFilter(QAbstractItemModel *model, QObject *parent)
    :m_searchTerm(""), QSortFilterProxyModel(parent)
{
    QSortFilterProxyModel::setSourceModel(model);
}

bool OnlineModelListFilter::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const{

    QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
    QString name = sourceModel()->data(index, OnlineModelList::NameRole).toString();
    bool isLikeModel = sourceModel()->data(index, OnlineModelList::IsLikeRole).toBool();
    bool installModel = sourceModel()->data(index, OnlineModelList::InstallModelRole).toBool();

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
    case FilterType::InstallModel:
        if(!m_searchTerm.isEmpty() && !name.contains(m_searchTerm))
            return false;
        return installModel;
    case FilterType::Favorite:
        if(!m_searchTerm.isEmpty() && !name.contains(m_searchTerm))
            return false;
        return isLikeModel;
    default:
        return true;
    }
}

const QString &OnlineModelListFilter::searchTerm() const{return m_searchTerm;}
void OnlineModelListFilter::setSearchTerm(const QString &newSearchTerm){
    if (m_searchTerm == newSearchTerm)
        return;
    m_searchTerm = newSearchTerm;
    invalidateFilter();
    emit searchTermChanged();
}

Company *OnlineModelListFilter::company() const{return m_company;}
void OnlineModelListFilter::setCompany(Company *newCompany){
    if (m_company == newCompany)
        return;
    m_company = newCompany;
    setFilterType(FilterType::Company);
    emit companyChanged();
}

OnlineModelListFilter::FilterType OnlineModelListFilter::filterType() const{return m_filterType;}
void OnlineModelListFilter::setFilterType(FilterType newFilterType){
    if (m_filterType == newFilterType)
        return;
    m_filterType = newFilterType;
    invalidateFilter();
    emit filterTypeChanged();
}
