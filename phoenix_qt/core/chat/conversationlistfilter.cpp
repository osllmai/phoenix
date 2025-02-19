#include "conversationlistfilter.h"

ConversationListFilter::ConversationListFilter(QAbstractItemModel *model, QObject *parent)
    : QSortFilterProxyModel(parent)
{
    QSortFilterProxyModel::setSourceModel(model);
    // setFilterCaseSensitivity(Qt::CaseInsensitive);
    // setFilterRole(OfflineModelList::OfflineModelRoles::NameRole);

    // setSortRole(OfflineModelList::OfflineModelRoles::NameRole);
    // sort(0, Qt::AscendingOrder);
}


bool ConversationListFilter::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const{

    QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);

    return true;
}
