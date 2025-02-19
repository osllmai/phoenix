#ifndef CONVERSATIONLISTFILTER_H
#define CONVERSATIONLISTFILTER_H

#include <QSortFilterProxyModel>
#include <QObject>
#include <QtQml>
#include <QQmlEngine>

class ConversationListFilter: public QSortFilterProxyModel
{
    Q_OBJECT
public:
    explicit ConversationListFilter(QAbstractItemModel *model, QObject *parent);

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;
};

#endif // CONVERSATIONLISTFILTER_H
