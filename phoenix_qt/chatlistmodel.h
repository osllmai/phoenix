#ifndef CHATLISTMODEL_H
#define CHATLISTMODEL_H

#include <QObject>
#include <QQmlEngine>
#include <QtQml>
#include <QTimer>
#include <QAbstractListModel>
#include "chat.h"

class ChatListModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(Chat *currentChat READ currentChat WRITE setCurrentChat NOTIFY currentChatChanged)
    Q_PROPERTY(int size READ size NOTIFY sizeChanged)

    enum ChatlRoles {
        IdRole = Qt::UserRole + 1,
        TitleRole,
        DateRole
    };
public:
    explicit ChatListModel(QObject *parent );

    //*-------------------------------------------------------------------------------*************************------------------------------------------------------------------------------*//
    //*-------------------------------------------------------------------------------* QAbstractItemModel interface*------------------------------------------------------------------------------*//
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
    //*---------------------------------------------------------------------------* end QAbstractItemModel interface *----------------------------------------------------------------------------*//


    //*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
    //*----------------------------------------------------------------------------------------* Read Property  *----------------------------------------------------------------------------------------*//
    Chat *currentChat() const;
    int size() const;
    //*--------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//


    //*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
    //*----------------------------------------------------------------------------------------* Write Property  *----------------------------------------------------------------------------------------*//
    void setCurrentChat(Chat *chat);
    //*-------------------------------------------------------------------------------------* end Write Property *--------------------------------------------------------------------------------------*//

    Q_INVOKABLE void addChat();
    Q_INVOKABLE Chat* getChat(int index);
    Q_INVOKABLE void deleteChat(int index);

signals:
    void currentChatChanged();
    void sizeChanged();

public slots:
    void addCurrentChatToChatList();

private:
    Chat* m_currentChat = nullptr;
    QList<Chat*> chats;

    QVariant dateRequest(const int currentIndex)const;
};

#endif // CHATLISTMODEL_H
