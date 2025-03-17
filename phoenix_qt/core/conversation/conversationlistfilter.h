#ifndef CONVERSATIONLISTFILTER_H
#define CONVERSATIONLISTFILTER_H

#include <QSortFilterProxyModel>

class ConversationListFilter: public QSortFilterProxyModel
{
    Q_OBJECT
public:
    explicit ConversationListFilter(QAbstractItemModel *model, QObject *parent = nullptr);

public slots:
    void updateFilterList();

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;
    bool lessThan(const QModelIndex &left, const QModelIndex &right) const override;
};

#endif // CONVERSATIONLISTFILTER_H
