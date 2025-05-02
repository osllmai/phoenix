#include "offlinemodellistfilter.h"
#include "offlinemodellist.h"

OfflineModelListFilter::OfflineModelListFilter(QAbstractItemModel *models, QObject *parent):
    QSortFilterProxyModel(parent), m_filterType(FilterType::All), m_companyId(-1), m_type("")
{
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
    double downloadPercent = sourceModel()->data(index, OfflineModelList::OfflineModelRoles::DownloadPercentRole).toDouble();
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
        return matchesFilter && (m_companyId != -1) && model->company() && model->company()->id() == m_companyId;
    case FilterType::Type:
        return matchesFilter && (m_type != "") && model->type() == m_type;
    case FilterType::DownloadFinished:
        return matchesFilter && model->type() == "Text Generation" && (downloadFinished || model->recommended() == true);
    case FilterType::Favorite:
        return matchesFilter && isLikeModel;
    case FilterType::IsDownloading:
        return matchesFilter && isDownloading && (downloadPercent>=0.0001);
    default:
        return true;
    }
}

void OfflineModelListFilter::filter(QString filter){
    if(filter == "All")
        setFilterType(FilterType::All);
    if(filter == "Company")
        setFilterType(FilterType::Company);
    if(filter == "Type")
        setFilterType(FilterType::Type);
    if(filter == "DownloadFinished")
        setFilterType(FilterType::DownloadFinished);
    if(filter == "Favorite")
        setFilterType(FilterType::Favorite);
    if(filter == "IsDownloading")
        setFilterType(FilterType::IsDownloading);
}

int OfflineModelListFilter::count() const { return rowCount(); }

int OfflineModelListFilter::companyId() const{return m_companyId;}
void OfflineModelListFilter::setCompanyId(int companyId){
    if((companyId == m_companyId) && (m_filterType == FilterType::Company))
        return;
    m_companyId = companyId;
    setFilterType(FilterType::Company);
    emit companyIdChanged();
    emit countChanged();
}

OfflineModelListFilter::FilterType OfflineModelListFilter::filterType() const{return m_filterType;}
void OfflineModelListFilter::setFilterType(FilterType newFilterType){
    if((newFilterType == m_filterType) && (m_filterType != FilterType::Company) && (m_filterType != FilterType::Type))
        return;
    m_filterType = newFilterType;
    invalidateFilter();
    emit filterTypeChanged();
    emit countChanged();
}

QString OfflineModelListFilter::type() const{return m_type;}
void OfflineModelListFilter::setType(const QString &newType){
    if ((m_type == newType) && (m_filterType == FilterType::Type))
        return;
    m_type = newType;
    setFilterType(FilterType::Type);
    emit typeChanged();
    emit countChanged();
}
