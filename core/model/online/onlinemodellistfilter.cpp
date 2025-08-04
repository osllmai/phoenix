#include "onlinemodellistfilter.h"
#include "onlinemodellist.h"


OnlineModelListFilter::OnlineModelListFilter(QAbstractItemModel *model, QObject *parent)
    :QSortFilterProxyModel(parent), m_filterType(FilterType::All), m_companyId(-1), m_type("")
{
    QSortFilterProxyModel::setSourceModel(model);

    // setFilterCaseSensitivity(Qt::CaseInsensitive);
    // setFilterRole(OnlineModelList::OnlineModelRoles::NameRole);

    // setSortRole(OnlineModelList::OnlineModelRoles::NameRole);
    // sort(0, Qt::AscendingOrder);

    setFilterCaseSensitivity(Qt::CaseInsensitive);
    setFilterRole(OnlineModelList::OnlineModelRoles::InstallModelRole);

    setSortRole(OnlineModelList::OnlineModelRoles::InstallModelRole);
    sort(0, Qt::DescendingOrder);
}

bool OnlineModelListFilter::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const{

    QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
    if (!index.isValid())
        return false;

    QString name = sourceModel()->data(index, OnlineModelList::OnlineModelRoles::NameRole).toString();
    QString modelName = sourceModel()->data(index, OnlineModelList::OnlineModelRoles::ModeNameRole).toString();
    Company* company = sourceModel()->data(index, OnlineModelList::OnlineModelRoles::CompanyRole).value<Company*>();
    QString companyName = company ? company->name() : QStringLiteral("Unknown");

    QString modelNameOffline = companyName + "/" + sourceModel()->data(index, OnlineModelList::OnlineModelRoles::ModeNameRole).toString();
    bool isLikeModel = sourceModel()->data(index, OnlineModelList::OnlineModelRoles::IsLikeRole).toBool();
    bool installModel = sourceModel()->data(index, OnlineModelList::OnlineModelRoles::InstallModelRole).toBool();

    QVariant modelVariant = sourceModel()->data(index, OnlineModelList::OnlineModelRoles::ModelObjectRole);
    OnlineModel* model = modelVariant.value<OnlineModel*>();

    if (!model) return false;

    QRegularExpression filterExp = filterRegularExpression();
    bool matchesFilter = filterExp.pattern().isEmpty() ||
                                         filterExp.match(name).hasMatch() ||
                                         filterExp.match(modelName).hasMatch() ||
                                         filterExp.match(modelNameOffline).hasMatch();

    switch (m_filterType) {
    case FilterType::All:
        return matchesFilter;
    case FilterType::Company:
        return matchesFilter && (m_companyId != -1) && model->company() && model->company()->id() == m_companyId;
    case FilterType::Type:
        return matchesFilter && (m_type != "") && model->type() == m_type;
    case FilterType::InstallModel:
        return matchesFilter && model->type() == "Text Generation"&& (installModel) ;
    case FilterType::Recommended:
        return matchesFilter && model->type() == "Text Generation" && (!installModel && model->recommended() );
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
    if(filter == "Type")
        setFilterType(FilterType::Type);
    if(filter == "InstallModel")
        setFilterType(FilterType::InstallModel);
    if(filter == "Recommended")
        setFilterType(FilterType::Recommended);
    if(filter == "Favorite")
        setFilterType(FilterType::Favorite);
}

int OnlineModelListFilter::count() const { return rowCount(); }

int OnlineModelListFilter::companyId() const{return m_companyId;}
void OnlineModelListFilter::setCompanyId(int companyId){
    if((companyId == m_companyId) && (m_filterType == FilterType::Company))
        return;
    m_companyId = companyId;
    setFilterType(FilterType::Company);
    emit companyIdChanged();
    emit countChanged();
}

OnlineModelListFilter::FilterType OnlineModelListFilter::filterType() const{return m_filterType;}
void OnlineModelListFilter::setFilterType(FilterType newFilterType){
    if((newFilterType == m_filterType) && (m_filterType != FilterType::Company) && (m_filterType != FilterType::Type))
        return;
    m_filterType = newFilterType;
    invalidateFilter();
    emit filterTypeChanged();
    emit countChanged();
}

QString OnlineModelListFilter::type() const{return m_type;}
void OnlineModelListFilter::setType(const QString &newType){
    if ((m_type == newType) && (m_filterType == FilterType::Type))
        return;
    m_type = newType;
    setFilterType(FilterType::Type);
    emit typeChanged();
    emit countChanged();
}
