#include "offlinemodellistfilter.h"
#include "offlinemodellist.h"
#include <QRegularExpression>

OfflineModelListFilter::OfflineModelListFilter(QObject *parent)
    : QSortFilterProxyModel(parent)
{
    init();
}

OfflineModelListFilter::OfflineModelListFilter(QAbstractItemModel *models, QObject *parent)
    : QSortFilterProxyModel(parent)
{
    init();
    QSortFilterProxyModel::setSourceModel(models);
}

void OfflineModelListFilter::init()
{
    setDynamicSortFilter(true);

    connect(this, &QAbstractItemModel::rowsInserted, this, &OfflineModelListFilter::countChanged);
    connect(this, &QAbstractItemModel::rowsRemoved,  this, &OfflineModelListFilter::countChanged);
    connect(this, &QAbstractItemModel::modelReset,   this, &OfflineModelListFilter::countChanged);
    connect(this, &QAbstractItemModel::layoutChanged,this, &OfflineModelListFilter::countChanged);
}

void OfflineModelListFilter::setSourceModel(QAbstractItemModel *src)
{
    QSortFilterProxyModel::setSourceModel(src);
    invalidateFilter();
    emit countChanged();
}

bool OfflineModelListFilter::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
    if (!index.isValid())
        return false;

    const QString name = sourceModel()->data(index, OfflineModelList::OfflineModelRoles::NameRole).toString();
    const QString modelName = sourceModel()->data(index, OfflineModelList::OfflineModelRoles::ModelNameRole).toString();
    const QString modelNameOffline = "localModel/" + modelName;
    const bool isLikeModel = sourceModel()->data(index, OfflineModelList::OfflineModelRoles::IsLikeRole).toBool();
    const bool isDownloading = sourceModel()->data(index, OfflineModelList::OfflineModelRoles::IsDownloadingRole).toBool();
    const bool downloadFinished = sourceModel()->data(index, OfflineModelList::OfflineModelRoles::DownloadFinishedRole).toBool();

    const QVariant modelVariant = sourceModel()->data(index, OfflineModelList::OfflineModelRoles::ModelObjectRole);
    auto *model = modelVariant.value<OfflineModel*>();
    if (!model) return false;

    const QRegularExpression filterExp = filterRegularExpression();
    const bool matchesFilter = filterExp.pattern().isEmpty()
                               || filterExp.match(name).hasMatch()
                               || filterExp.match(modelName).hasMatch()
                               || filterExp.match(modelNameOffline).hasMatch();

    switch (m_filterType) {
    case FilterType::All:
        return matchesFilter;
    case FilterType::Company:
        return matchesFilter && (m_companyId != -1) && model->company() && model->company()->id() == m_companyId;
    case FilterType::Type:
        return matchesFilter && !m_type.isEmpty() && model->type() == m_type;
    case FilterType::DownloadFinished:
        return matchesFilter && downloadFinished;
    case FilterType::DownloadTextModelFinished:
        return matchesFilter && ((model->type() == "Text Generation") || (model->type() == "text-generation")) && downloadFinished;
    case FilterType::Recommended:
        return matchesFilter && ((model->type() == "Text Generation") || (model->type() == "text-generation")) && (!downloadFinished && model->recommended());
    case FilterType::Favorite:
        return matchesFilter && isLikeModel;
    case FilterType::IsDownloading:
        return matchesFilter && isDownloading;
    default:
        return true;
    }
}

void OfflineModelListFilter::filter(const QString &filterStr)
{
    if(filterStr == "All")
        setFilterType(FilterType::All);
    else if (filterStr == "Company")
        setFilterType(FilterType::Company);
    else if (filterStr == "Type")
        setFilterType(FilterType::Type);
    else if (filterStr == "DownloadFinished")
        setFilterType(FilterType::DownloadFinished);
    else if (filterStr == "DownloadTextModelFinished")
        setFilterType(FilterType::DownloadTextModelFinished);
    else if (filterStr == "Recommended")
        setFilterType(FilterType::Recommended);
    else if (filterStr == "Favorite")
        setFilterType(FilterType::Favorite);
    else if (filterStr == "IsDownloading")
        setFilterType(FilterType::IsDownloading);
}

QVariantMap OfflineModelListFilter::get(int index) const
{
    QVariantMap map;
    if (index < 0 || index >= rowCount())
        return map;

    const QHash<int, QByteArray> roles = roleNames();
    const QModelIndex modelIndex = this->index(index, 0);
    for (auto it = roles.begin(); it != roles.end(); ++it) {
        map[it.value()] = data(modelIndex, it.key());
    }
    return map;
}

int OfflineModelListFilter::count() const
{
    return rowCount();
}

void OfflineModelListFilter::setCompanyId(int companyId)
{
    if ((companyId == m_companyId) && (m_filterType == FilterType::Company))
        return;
    m_companyId = companyId;
    setFilterType(FilterType::Company);
    emit companyIdChanged();
    emit countChanged();
}

void OfflineModelListFilter::setFilterType(FilterType newFilterType)
{
    if ((newFilterType == m_filterType) &&
        (m_filterType != FilterType::Company) &&
        (m_filterType != FilterType::Type))
        return;

    m_filterType = newFilterType;
    invalidateFilter();
    emit filterTypeChanged();
    emit countChanged();
}

void OfflineModelListFilter::setType(const QString &newType)
{
    if ((m_type == newType) && (m_filterType == FilterType::Type))
        return;

    m_type = newType;
    setFilterType(FilterType::Type);
    emit typeChanged();
    emit countChanged();
}
