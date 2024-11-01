#ifndef CHATMODEL_H
#define CHATMODEL_H

#include <QObject>
#include <QtQml>
#include <QQmlEngine>
#include <QAbstractListModel>
#include "chatitem.h"

class ChatModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    enum ChatItemRoles {
        IdRole = Qt::UserRole + 1,
        PromptRole,
        ResponseRole
    };
public:
    explicit ChatModel(QObject *parent = nullptr);
    void saveChatItem(int parentId);
    void addChatItem(int id, QString prompt, QString response);
    int size();

    //*-------------------------------------------------------------------------------****************************------------------------------------------------------------------------------*//
    //*-------------------------------------------------------------------------------* QAbstractItemModel interface  *------------------------------------------------------------------------------*//
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
    //*-----------------------------------------------------------------------------* end QAbstractItemModel interface *----------------------------------------------------------------------------*//

    Q_INVOKABLE void prompt(const QString &prompt);
    void updateResponse(const QString &response);

signals:
    void startPrompt(const QString &prompt);

public slots:

private:
    QList<ChatItem*> chatItems;
};

#endif // CHATMODEL_H
