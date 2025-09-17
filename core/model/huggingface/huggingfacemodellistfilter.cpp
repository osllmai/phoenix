#include "huggingfacemodellistfilter.h"
#include <QRegularExpression>

HuggingfaceModelListFilter::HuggingfaceModelListFilter(QObject *parent)
    : QSortFilterProxyModel(parent)
{
    init();
}

HuggingfaceModelListFilter::HuggingfaceModelListFilter(QAbstractItemModel *model, QObject *parent)
    : QSortFilterProxyModel(parent)
{
    init();
    QSortFilterProxyModel::setSourceModel(model);
}

void HuggingfaceModelListFilter::init(){
    setDynamicSortFilter(true);

    connect(this, &QAbstractItemModel::rowsInserted, this, &HuggingfaceModelListFilter::countChanged);
    connect(this, &QAbstractItemModel::rowsRemoved,  this, &HuggingfaceModelListFilter::countChanged);
    connect(this, &QAbstractItemModel::modelReset,   this, &HuggingfaceModelListFilter::countChanged);
    connect(this, &QAbstractItemModel::layoutChanged,this, &HuggingfaceModelListFilter::countChanged);
}

void HuggingfaceModelListFilter::setSourceModel(QAbstractItemModel *src){
    QSortFilterProxyModel::setSourceModel(src);
    invalidateFilter();
    emit countChanged();
}

bool HuggingfaceModelListFilter::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const {
    QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
    if (!index.isValid())
        return false;

    const QString name = sourceModel()->data(index, HuggingfaceModelList::NameRole).toString();
    const int likes = sourceModel()->data(index, HuggingfaceModelList::LikesRole).toInt();
    const int downloads = sourceModel()->data(index, HuggingfaceModelList::DownloadsRole).toInt();
    const QString model_task = sourceModel()->data(index, HuggingfaceModelList::PiplineTagRole).toString();
    const QString model_library = sourceModel()->data(index, HuggingfaceModelList::LibraryNameRole).toString();

    QRegularExpression filterExp(filterRegularExpression().pattern(), QRegularExpression::CaseInsensitiveOption);
    const bool matchesFilter = filterExp.pattern().isEmpty() || filterExp.match(name).hasMatch();

    const bool taskMatch = (m_task.compare("all", Qt::CaseInsensitive) == 0) ||
                           model_task.contains(m_task, Qt::CaseInsensitive);

    const bool libraryMatch = (m_library.compare("all", Qt::CaseInsensitive) == 0) ||
                              model_library.contains(m_library, Qt::CaseInsensitive);

    switch (m_filterType) {
    case FilterType::All:
        return matchesFilter && taskMatch && libraryMatch;
    case FilterType::MostLiked:
        return matchesFilter && likes > 100 && taskMatch && libraryMatch;
    case FilterType::MostDownloaded:
        return matchesFilter && downloads > 10000 && taskMatch && libraryMatch;
    default:
        return true;
    }
}

int HuggingfaceModelListFilter::count() const{return rowCount();}

QVariantMap HuggingfaceModelListFilter::get(int index) const{
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

void HuggingfaceModelListFilter::setFilterType(FilterType newFilterType){
    if (newFilterType == m_filterType)
        return;

    m_filterType = newFilterType;
    invalidateFilter();
    emit filterTypeChanged();
    emit countChanged();
}

QString HuggingfaceModelListFilter::filterStr() const{return m_filterStr;}
void HuggingfaceModelListFilter::setFilterStr(const QString &newFilterStr){
    if (m_filterStr == newFilterStr)
        return;

    m_filterStr = newFilterStr;

    if(m_filterStr == "all")
        setFilterType(FilterType::All);
    else if (m_filterStr == "most-downloaded")
        setFilterType(FilterType::MostDownloaded);
    else if (m_filterStr == "most-liked")
        setFilterType(FilterType::MostLiked);

    emit filterStrChanged();
}

QString HuggingfaceModelListFilter::task() const{return m_task;}
void HuggingfaceModelListFilter::setTask(const QString &newTask){
    if (m_task == newTask)
        return;
    m_task = newTask;
    invalidateFilter();
    emit taskChanged();
}

QString HuggingfaceModelListFilter::library() const{return m_library;}
void HuggingfaceModelListFilter::setLibrary(const QString &newLibrary){
    if (m_library == newLibrary)
        return;
    m_library = newLibrary;
    invalidateFilter();
    emit libraryChanged();
}
