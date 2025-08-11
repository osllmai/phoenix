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

    connect(this, &QAbstractItemModel::rowsInserted, this, &OfflineModelListFilter::countChanged);
    connect(this, &QAbstractItemModel::rowsRemoved, this, &OfflineModelListFilter::countChanged);
    connect(this, &QAbstractItemModel::modelReset, this, &OfflineModelListFilter::countChanged);
}

bool OfflineModelListFilter::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const{

    QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
    if (!index.isValid())
        return false;

    QString name = sourceModel()->data(index, OfflineModelList::OfflineModelRoles::NameRole).toString();
    QString modelName = sourceModel()->data(index, OfflineModelList::OfflineModelRoles::ModeNameRole).toString();
    QString modelNameOffline = "localModel/" + sourceModel()->data(index, OfflineModelList::OfflineModelRoles::ModeNameRole).toString();
    bool isLikeModel = sourceModel()->data(index, OfflineModelList::OfflineModelRoles::IsLikeRole).toBool();
    bool isDownloading = sourceModel()->data(index, OfflineModelList::OfflineModelRoles::IsDownloadingRole).toBool();
    bool downloadFinished = sourceModel()->data(index, OfflineModelList::OfflineModelRoles::DownloadFinishedRole).toBool();

    QVariant modelVariant = sourceModel()->data(index, OfflineModelList::OfflineModelRoles::ModelObjectRole);
    OfflineModel* model = modelVariant.value<OfflineModel*>();

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
    case FilterType::DownloadFinished:
        return matchesFilter && (downloadFinished);
    case FilterType::DownloadTextModelFinished:
        return matchesFilter && model->type() == "Text Generation" && (downloadFinished);
    case FilterType::Recommended:
        return matchesFilter && model->type() == "Text Generation" && (!downloadFinished && model->recommended());
    case FilterType::Favorite:
        return matchesFilter && isLikeModel;
    case FilterType::IsDownloading:
        return matchesFilter && isDownloading;
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
    if(filter == "DownloadTextModelFinished")
        setFilterType(FilterType::DownloadTextModelFinished);
    if(filter == "Recommended")
        setFilterType(FilterType::Recommended);
    if(filter == "Favorite")
        setFilterType(FilterType::Favorite);
    if(filter == "IsDownloading")
        setFilterType(FilterType::IsDownloading);
}

QVariantMap OfflineModelListFilter::get(int index) const {
    QVariantMap map;
    if (index < 0 || index >= rowCount())
        return map;

    QHash<int, QByteArray> roles = roleNames();
    QModelIndex modelIndex = this->index(index, 0);
    for (auto it = roles.begin(); it != roles.end(); ++it) {
        map[it.value()] = data(modelIndex, it.key());
    }
    return map;
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
