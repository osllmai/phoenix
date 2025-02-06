#include "companylistfilter.h"
#include "companylist.h"

CompanyListFilter::CompanyListFilter(BackendType backendType, QObject *parent)
    : QSortFilterProxyModel(parent), m_backendType(backendType) {}

const BackendType CompanyListFilter::backendType() const{return m_backendType;}
void CompanyListFilter::setBackendType(const BackendType backendType){
    if (m_backendType != backendType) {
        m_backendType = backendType;
        invalidateFilter();
        emit backendTypeChanged();
    }
}

bool CompanyListFilter::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const{

    QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
    BackendType companyBackend = static_cast<BackendType>(sourceModel()->data(index, CompanyList::BackendRole).toInt());

    return companyBackend == m_backendType;
}
