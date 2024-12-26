#include "currentmodellistfilter.h"

CurrentModelListFilter::CurrentModelListFilter(QObject *parent)
    : QSortFilterProxyModel{parent}
{}

bool CurrentModelListFilter::filterAcceptsRow(int source_row, const QModelIndex &source_parent) const
{
    Q_UNUSED(source_parent)
    auto model = m_currentModelList->at(source_row);

    if (!model)
        return false;

    if (m_backendType != BackendType::All
        && m_backendType != static_cast<BackendType>(model->backendType()))
        return false;

    if (!m_searchTerm.isEmpty() && !model->name().contains(m_searchTerm))
        return false;

    return true;
}

CurrentModelListFilter::BackendType CurrentModelListFilter::backendType() const
{
    return m_backendType;
}

void CurrentModelListFilter::setBackendType(BackendType newBackendType)
{
    if (m_backendType == newBackendType)
        return;
    m_backendType = newBackendType;
    invalidateFilter();
    emit backendTypeChanged();
}

QString CurrentModelListFilter::searchTerm() const
{
    return m_searchTerm;
}

void CurrentModelListFilter::setSearchTerm(const QString &newSearchTerm)
{
    if (m_searchTerm == newSearchTerm)
        return;
    m_searchTerm = newSearchTerm;
    invalidateFilter();
    emit searchTermChanged();
}

CurrentModelList *CurrentModelListFilter::currentModelList() const
{
    return m_currentModelList;
}

void CurrentModelListFilter::setCurrentModelList(CurrentModelList *newCurrentModelList)
{
    if (m_currentModelList == newCurrentModelList)
        return;
    m_currentModelList = newCurrentModelList;
    setSourceModel(newCurrentModelList);
    invalidate();
    emit currentModelListChanged();
}
