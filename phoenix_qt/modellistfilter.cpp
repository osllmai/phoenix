#include "modellistfilter.h"

ModelListFilter::ModelListFilter(QObject *parent)
    : QSortFilterProxyModel{parent}
{}

bool ModelListFilter::filterAcceptsRow(int source_row, const QModelIndex &source_parent) const
{
    Q_UNUSED(source_parent)
    auto model = m_modelList->at(source_row);

    if (!model)
        return false;

    if (m_backendType != BackendType::All
        && m_backendType != static_cast<BackendType>(model->backendType()))
        return false;

    if (!m_searchTerm.isEmpty() && !model->name().contains(m_searchTerm, Qt::CaseInsensitive))
        return false;

    return true;
}

ModelListFilter::BackendType ModelListFilter::backendType() const
{
    return m_backendType;
}

void ModelListFilter::setBackendType(BackendType newBackendType)
{
    if (m_backendType == newBackendType)
        return;
    m_backendType = newBackendType;
    invalidateFilter();
    emit backendTypeChanged();
}

QString ModelListFilter::searchTerm() const
{
    return m_searchTerm;
}

void ModelListFilter::setSearchTerm(const QString &newSearchTerm)
{
    if (m_searchTerm == newSearchTerm)
        return;
    m_searchTerm = newSearchTerm;
    invalidateFilter();
    emit searchTermChanged();
}

ModelList *ModelListFilter::modelList() const
{
    return m_modelList;
}

void ModelListFilter::setModelList(ModelList *newModelList)
{
    if (m_modelList == newModelList)
        return;
    m_modelList = newModelList;
    setSourceModel(newModelList);
    invalidate();
    emit modelListChanged();
}
