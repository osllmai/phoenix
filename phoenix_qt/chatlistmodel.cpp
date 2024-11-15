#include "chatlistmodel.h"

#include <QtSql>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

ChatListModel::ChatListModel(QObject *parent)
    : QAbstractListModel{parent}
{
    addChat();
    qInfo()<<"create chatListModel";
}

//*------------------------------------------------------------------------------****************************-----------------------------------------------------------------------------*//
//*------------------------------------------------------------------------------* QAbstractItemModel interface  *------------------------------------------------------------------------------*//
int ChatListModel::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return chats.size();
}

QVariant ChatListModel::data(const QModelIndex &index, int role = Qt::DisplayRole) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= chats.count())
        return QVariant();

    //The index is valid
    Chat* chat = chats[index.row()];

    switch (role) {
    case IdRole:
        return chat->id();
    case TitleRole:
        return chat->title();
    }

    return QVariant();
}

QHash<int, QByteArray> ChatListModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[TitleRole] = "title";
    return roles;
}

Qt::ItemFlags ChatListModel::flags(const QModelIndex &index) const {
    if (!index.isValid())
        return Qt::NoItemFlags;
    return Qt::ItemIsEditable;
}

bool ChatListModel::setData(const QModelIndex &index, const QVariant &value, int role) {
    Chat* chat = chats[index.row()]; // The person to edit
    bool somethingChanged{false};

    switch (role) {
    case IdRole:
        if( chat->id()!= value.toInt()){
            chat->setId(value.toInt());
            somethingChanged = true;
        }
        break;
    case TitleRole:
        if( chat->title()!= value.toString()){
            chat->setTitle(value.toString());
            somethingChanged = true;
        }
    }
    if(somethingChanged){
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}
//*---------------------------------------------------------------------------* end QAbstractItemModel interface *----------------------------------------------------------------------------*//


//*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
//*----------------------------------------------------------------------------------------* Read Property  *----------------------------------------------------------------------------------------*//
Chat* ChatListModel::currentChat() const{
    return m_currentChat;
}
int ChatListModel::size() const{
    return chats.size();
}
//*--------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//


//*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
//*----------------------------------------------------------------------------------------* Write Property  *----------------------------------------------------------------------------------------*//
void ChatListModel::setCurrentChat(Chat *chat){
    if(m_currentChat != nullptr)
        m_currentChat->unloadModelRequested();
    m_currentChat = chat;
    emit currentChatChanged();
}
//*-------------------------------------------------------------------------------------* end Write Property *--------------------------------------------------------------------------------------*//


void ChatListModel::addChat(){
    const int index = chats.size();
    const QString name = "new chat" +  QString::number(index);

    qInfo()<<"add chat: "<<name;
    Chat *chat = new Chat(index, name , this);
    if(m_currentChat != nullptr){
        qInfo()<<"        disconnect(m_currentChat, &Chat::startChat, this, &ChatListModel::addCurrentChatToChatList);";
        disconnect(m_currentChat, &Chat::startChat, this, &ChatListModel::addCurrentChatToChatList);
    }

    setCurrentChat(chat);
    connect(m_currentChat, &Chat::startChat, this, &ChatListModel::addCurrentChatToChatList, Qt::QueuedConnection);

}

void ChatListModel::addCurrentChatToChatList(){
    qInfo() << "addCurrentChatToChatList()";
    const int index = chats.size();
    beginInsertRows(QModelIndex(), index, index);//Tell the model that you are about to add data
    chats.append(m_currentChat);
    endInsertRows();
    emit sizeChanged();
    qInfo()<<"chats.size()"<<chats.size();
}

Chat* ChatListModel::getChat(int index){
    if (index < 0 || index >= chats.size())
        return nullptr;
    return chats.at(index);
}

void ChatListModel::deleteChat(int index){
    if (index < 0 || index >= chats.size())
        return ;
    Chat* chat = chats.at(index);
    const int newIndex = chats.indexOf(chat);
    beginRemoveRows(QModelIndex(), newIndex, newIndex);
    chats.removeAll(chat);
    endRemoveRows();
    emit sizeChanged();

    if(chat == currentChat())
        if(chats.size() == 0)
            addChat();
        else
            setCurrentChat(chats.first());
}
