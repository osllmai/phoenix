#include "conversationlistfilter.h"
#include "conversationlist.h"


ConversationListFilter::ConversationListFilter(QAbstractItemModel *model, QObject *parent)
    : QSortFilterProxyModel(parent) {
    setSourceModel(model);
    setSortRole(ConversationList::ConversationRoles::DateRole);
    sort(0, Qt::DescendingOrder);
}

bool ConversationListFilter::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const {

    QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
    if (!index.isValid())
        return false;

    QString name = sourceModel()->data(index, ConversationList::ConversationRoles::TitleRole).toString();
    QString description = sourceModel()->data(index, ConversationList::ConversationRoles::DescriptionRole).toString();

    QRegularExpression filterExp = filterRegularExpression();
    bool matchesFilter = filterExp.pattern().isEmpty() || filterExp.match(name).hasMatch() || filterExp.match(description).hasMatch();

    return matchesFilter;
}

bool ConversationListFilter::lessThan(const QModelIndex &left, const QModelIndex &right) const {
    bool leftPinned = sourceModel()->data(left, ConversationList::ConversationRoles::PinnedRole).toBool();
    bool rightPinned = sourceModel()->data(right, ConversationList::ConversationRoles::PinnedRole).toBool();

    if (leftPinned != rightPinned)
        return leftPinned < rightPinned;

    QDateTime leftDate = sourceModel()->data(left, ConversationList::ConversationRoles::DateRole).toDateTime();
    QDateTime rightDate = sourceModel()->data(right, ConversationList::ConversationRoles::DateRole).toDateTime();
    return leftDate < rightDate;
}

void ConversationListFilter::updateFilterList(){
    invalidateFilter();
}
