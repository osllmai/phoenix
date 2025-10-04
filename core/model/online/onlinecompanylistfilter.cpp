#include "onlinecompanylistfilter.h"

OnlineCompanyListFilter::OnlineCompanyListFilter(QAbstractItemModel *model, QObject *parent)
    :QSortFilterProxyModel(parent)
{
    QSortFilterProxyModel::setSourceModel(model);

    setDynamicSortFilter(false);
}

bool OnlineCompanyListFilter::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const{

    QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
    if (!index.isValid())
        return false;

    QString name = sourceModel()->data(index, OnlineCompanyList::CompanyRoles::NameRole).toString();

    QRegularExpression filterExp = filterRegularExpression();
    bool matchesFilter = filterExp.pattern().isEmpty() ||
                         filterExp.match(name).hasMatch();

    return matchesFilter && name != "Indox Router";
}


int OnlineCompanyListFilter::count() const { return rowCount(); }
