#include "onlinemodellistfilter.h"
#include "onlinemodellist.h"


OnlineModelListFilter::OnlineModelListFilter(QAbstractItemModel *model, QObject *parent)
    :QSortFilterProxyModel(parent), m_filterType(FilterType::All), m_companyId(-1)
{
    QSortFilterProxyModel::setSourceModel(model);

    setFilterCaseSensitivity(Qt::CaseInsensitive);
    setFilterRole(OnlineModelList::OnlineModelRoles::NameRole);

    setSortRole(OnlineModelList::OnlineModelRoles::NameRole);
    sort(0, Qt::AscendingOrder);
}

bool OnlineModelListFilter::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const{

    QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
    if (!index.isValid())
        return false;

    QString name = sourceModel()->data(index, OnlineModelList::NameRole).toString();
    bool isLikeModel = sourceModel()->data(index, OnlineModelList::IsLikeRole).toBool();
    bool installModel = sourceModel()->data(index, OnlineModelList::InstallModelRole).toBool();

    QVariant modelVariant = sourceModel()->data(index, OnlineModelList::OnlineModelRoles::ModelObjectRole);
    OnlineModel* model = modelVariant.value<OnlineModel*>();

    if (!model) return false;

    QRegularExpression filterExp = filterRegularExpression();
    bool matchesFilter = filterExp.pattern().isEmpty() || filterExp.match(name).hasMatch();

    switch (m_filterType) {
    case FilterType::All:
        return matchesFilter;
    case FilterType::Company:
        return matchesFilter && (m_companyId != -1) && model->company() && model->company()->id() == m_companyId;
    case FilterType::InstallModel:
        return matchesFilter && installModel;
    case FilterType::Favorite:
        return matchesFilter && isLikeModel;
    default:
        return true;
    }
}

void OnlineModelListFilter::filter(QString filter){
    if(filter == "All")
        setFilterType(FilterType::All);
    if(filter == "Company")
        setFilterType(FilterType::Company);
    if(filter == "InstallModel")
        setFilterType(FilterType::InstallModel);
    if(filter == "Favorite")
        setFilterType(FilterType::Favorite);
}

int OnlineModelListFilter::count() const { return rowCount(); }

int OnlineModelListFilter::companyId() const{return m_companyId;}
void OnlineModelListFilter::setCompanyId(int companyId){
    m_companyId = companyId;
    setFilterType(FilterType::Company);
    emit companyIdChanged();
    emit countChanged();
}

OnlineModelListFilter::FilterType OnlineModelListFilter::filterType() const{return m_filterType;}
void OnlineModelListFilter::setFilterType(FilterType newFilterType){
    m_filterType = newFilterType;
    invalidateFilter();
    emit filterTypeChanged();
    emit countChanged();
}
