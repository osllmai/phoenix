#include "huggingfacemodellistfilter.h"
#include <QRegularExpression>

HuggingfaceModelListFilter::HuggingfaceModelListFilter(QObject *parent)
    : QSortFilterProxyModel(parent), m_pipelineTag("text-to-image")
{
    init();
}

HuggingfaceModelListFilter::HuggingfaceModelListFilter(QAbstractItemModel *model, QObject *parent)
    : QSortFilterProxyModel(parent)
{
    init();
    QSortFilterProxyModel::setSourceModel(model);
}

void HuggingfaceModelListFilter::init()
{
    setDynamicSortFilter(true);

    connect(this, &QAbstractItemModel::rowsInserted, this, &HuggingfaceModelListFilter::countChanged);
    connect(this, &QAbstractItemModel::rowsRemoved,  this, &HuggingfaceModelListFilter::countChanged);
    connect(this, &QAbstractItemModel::modelReset,   this, &HuggingfaceModelListFilter::countChanged);
    connect(this, &QAbstractItemModel::layoutChanged,this, &HuggingfaceModelListFilter::countChanged);
}

void HuggingfaceModelListFilter::setSourceModel(QAbstractItemModel *src)
{
    QSortFilterProxyModel::setSourceModel(src);
    invalidateFilter();
    emit countChanged();
}

bool HuggingfaceModelListFilter::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
    if (!index.isValid())
        return false;

    const QString name = sourceModel()->data(index, HuggingfaceModelList::NameRole).toString();
    const int likes = sourceModel()->data(index, HuggingfaceModelList::LikesRole).toInt();
    const int downloads = sourceModel()->data(index, HuggingfaceModelList::DownloadsRole).toInt();
    const QString tag = sourceModel()->data(index, HuggingfaceModelList::PiplineTagRole).toString();

    QRegularExpression filterExp(filterRegularExpression().pattern(), QRegularExpression::CaseInsensitiveOption);
    const bool matchesFilter = filterExp.pattern().isEmpty() || filterExp.match(name).hasMatch();

    switch (m_filterType) {
    case FilterType::All:
        return matchesFilter;
    case FilterType::MostLiked:
        return matchesFilter && likes > 100;
    case FilterType::MostDownloaded:
        return matchesFilter && downloads > 2000;
    case FilterType::PipelineTag:
        return matchesFilter && tag.contains(m_pipelineTag, Qt::CaseInsensitive);
    default:
        return true;
    }
}

int HuggingfaceModelListFilter::count() const
{
    return rowCount();
}

void HuggingfaceModelListFilter::filter(const QString &filterStr)
{
    qInfo()<<filterStr;
    if(filterStr == "All")
        setFilterType(FilterType::All);
    else if (filterStr == "MostDownloaded")
        setFilterType(FilterType::MostDownloaded);
    else if (filterStr == "MostLiked")
        setFilterType(FilterType::MostLiked);
    else if (filterStr == "PipelineTag")
        setFilterType(FilterType::PipelineTag);
}

QVariantMap HuggingfaceModelListFilter::get(int index) const
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

void HuggingfaceModelListFilter::setFilterType(FilterType newFilterType)
{
    if (newFilterType == m_filterType)
        return;

    m_filterType = newFilterType;
    invalidateFilter();
    emit filterTypeChanged();
    emit countChanged();
}

void HuggingfaceModelListFilter::setPipelineTag(const QString &newTag)
{
    if (m_pipelineTag == newTag && m_filterType == FilterType::PipelineTag)
        return;

    m_pipelineTag = newTag;
    setFilterType(FilterType::PipelineTag);
    emit pipelineTagChanged();
    emit countChanged();
}
