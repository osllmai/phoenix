#include "chatlistmodel.h"

#include <QDebug>

ChatListModel::ChatListModel(QObject *parent)
    : QAbstractListModel{parent}
{
    // read chat from database

    QList<Chat*> chatDB = phoenix_databace::readConversation();
    for(int i=chatDB.size()-1 ; i>=0 ; i--){

        //find message for this chat
        Message* root = new Message(-1,"root",true , this);
        phoenix_databace::readMessage(root, chatDB.first()->id());

        //add chat to list chats
        Chat *chat = new Chat(chatDB.first()->id(), chatDB.first()->title(), chatDB.first()->date(),root, this);
        setCurrentChat(chat);

        beginInsertRows(QModelIndex(), 0, 0);
        chats.prepend(m_currentChat);
        endInsertRows();
        if(chats.size() >1)
            emit dataChanged(createIndex(1, 0), createIndex(1, 0), {DateRole});

        Chat *chatOld = chatDB.first();
        chatDB.removeFirst();
        delete chatOld;
    }
    connect(m_currentChat, &Chat::startChat, this, &ChatListModel::addCurrentChatToChatList, Qt::QueuedConnection);
    addChat();

}

//*------------------------------------------------------------------------------**************************-----------------------------------------------------------------------------*//
//*------------------------------------------------------------------------------* QAbstractItemModel interface  *-----------------------------------------------------------------------------*//
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
    case DateRole:
        return dateRequest(index.row());
    }

    return QVariant();
}

QHash<int, QByteArray> ChatListModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[TitleRole] = "title";
    roles[DateRole] = "date";
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
    const QString name = "new chat";

    Message *root = new Message(-1,"root",true , this);
    Chat *chat = new Chat(index, name, QDateTime::currentDateTime(),root, this);

    if(m_currentChat != nullptr)
        disconnect(m_currentChat, &Chat::startChat, this, &ChatListModel::addCurrentChatToChatList);

    setCurrentChat(chat);
    connect(m_currentChat, &Chat::startChat, this, &ChatListModel::addCurrentChatToChatList, Qt::QueuedConnection);
}

void ChatListModel::addCurrentChatToChatList(){
    int id = phoenix_databace::insertConversation(m_currentChat->title(), m_currentChat->date());
    m_currentChat->setId(id);

    beginInsertRows(QModelIndex(), 0, 0);
    chats.prepend(m_currentChat);
    endInsertRows();
    emit sizeChanged();
    if(chats.size() >1)
        emit dataChanged(createIndex(1, 0), createIndex(1, 0), {IdRole, DateRole});
}

Chat* ChatListModel::getChat(int index){
    if (index < 0 || index >= chats.size()){
        return nullptr;
    }
    return chats.at(index);
}

void ChatListModel::deleteChat(int index){
    if (index < 0 || index >= chats.size())
        return ;
    Chat* chat = chats.at(index);
    if(chat == m_currentChat)
        addChat();
    // const int newIndex = chats.indexOf(chat);
    beginRemoveRows(QModelIndex(), index, index);
    chats.removeAll(chat);
    endRemoveRows();

    phoenix_databace::deleteConversation(chat->id());
    delete chat;

    if(index < chats.size()){
        emit dataChanged(createIndex(index, 0), createIndex(index, 0), { DateRole});
    }

    emit sizeChanged();
}

void ChatListModel::editChatName(const int index, const QString title){
    chats[index]->setTitle(title);
    phoenix_databace::updateConversationName(chats[index]->id(),chats[index]->title());
}

QVariant ChatListModel::dateRequest(const int currentIndex)const{
    QDateTime date = chats[currentIndex]->date();
    QDateTime beforDate ;
    if(currentIndex != 0)
        beforDate = chats[currentIndex-1]->date();
    if(currentIndex != 0 && beforDate.toString("MM/dd/yyyy") == date.toString("MM/dd/yyyy"))
        return "";

    QDateTime now = QDateTime::currentDateTime();
    if(date.daysTo(now) < 1 && date.toString("dd")==now.toString("dd"))
        return "Today";
    if(date.daysTo(now) < 2 && date.toString("dd")==now.addDays(-1).toString("dd"))
        return "Yesterday";
    if(date.daysTo(now) < 7)
        if(currentIndex != 0 && beforDate.daysTo(now)<7 && beforDate.daysTo(now)>2)
            return "";
        else
            return "Previous 7 days";
    if(date.daysTo(now) < 30)
        if(currentIndex != 0 && beforDate.daysTo(now)<30 && beforDate.daysTo(now)>7)
            return "";
        else
            return "Previous 30 days";
    if(date.toString("yyyy") == now.toString("yyyy"))
        if(currentIndex != 0 && date.toString("MMMM")==beforDate.toString("MMMM"))
            return "";
        else
            return date.toString("MMMM");
    if(currentIndex != 0 && date.toString("yyyy")==beforDate.toString("yyyy"))
        return "";
    else
        return date.toString("yyyy");
}
