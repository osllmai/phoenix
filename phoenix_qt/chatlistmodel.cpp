#include "chatlistmodel.h"

#include <QtSql>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

ChatListModel::ChatListModel(QObject *parent)
    : QAbstractListModel{parent}
{
    //------------------------------------------------------------------------------------------------------------------------------database: load chat
    // Open the database
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("./phoenix.db");  // Replace with the actual path to your DB
    if (!db.open()) {
        qDebug() << "Error: Unable to open database" << db.lastError().text();
        return;
    }

    // Prepare and execute the SQL query
    QSqlQuery query(db);

    // Create table with id and name columns
    query.exec("CREATE TABLE IF NOT EXISTS chat (id INTEGER, name TEXT)");

    // Prepare query to select both id and name
    QString cmd = "SELECT id, name FROM chat";

    // Execute the query
    if (!query.exec(cmd)) {
        qDebug() << "Error: Unable to insert data -" << query.lastError().text();
    } else {
        qDebug() << "Data inserted successfully."<<query.size();
        while(query.next()){
            int id = query.value(0).toInt();
            QString name = query.value(1).toString();

            const int index = chats.size();
            Chat *chat = new Chat(id, name , this);

            beginInsertRows(QModelIndex(), index, index);//Tell the model that you are about to add data
            chats.append(chat);
            setCurrentChat(chat);
            endInsertRows();
        }
    }

    for(int chatIndex=0; chatIndex<chats.size(); chatIndex++){
        Chat *chat = chats[chatIndex];
        qDebug()<< chatIndex <<"for chats";
        //------------------------------------------------------------------------------------------------------------------------------database: load message

        // Create table with id and name columns
        query.exec("CREATE TABLE IF NOT EXISTS message (id INTEGER, chatId INTEGER, beforeMessageId INTEGER, prompt TEXT, response TEXT)");

        // Prepare query to select both id and name
        cmd = "SELECT id, chatId, prompt, response FROM message";

        // Execute the query
        if (!query.exec(cmd)) {
            qDebug() << "Error: Unable to insert data -" << query.lastError().text();
        } else {
            qDebug() << "Data inserted successfully.";
            while(query.next()){
                if(query.value(1).toInt() == chat->id()){
                    chat->addChatItem(query.value(0).toInt(), query.value(2).toString(), query.value(3).toString());
                }
            }
        }
        //------------------------------------------------------------------------------------------------------------------------------end database: load message
    }

    // Close the database
    db.close();
    //------------------------------------------------------------------------------------------------------------------------------end database: load chat

    addChat();
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
    Chat *chat = new Chat(index, name , this);
    beginInsertRows(QModelIndex(), index, index);//Tell the model that you are about to add data
    chats.append(chat);
    setCurrentChat(chat);
    endInsertRows();
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

    if(chat == currentChat())
        if(chats.size() == 0)
            addChat();
        else
            setCurrentChat(chats.first());

    // Open the database
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("./phoenix.db");  // Replace with the actual path to your DB
    if (!db.open()) {
        qDebug() << "Error: Unable to open database" << db.lastError().text();
        return;
    }

    // Prepare and execute the SQL query
    QSqlQuery query(db);

    // Create table with id and name columns
    query.exec("CREATE TABLE IF NOT EXISTS chat (id INTEGER, name TEXT)");

    // Prepare query to insert both id and name
    query.prepare("DELETE FROM chat where id = ?");

    // Bind values
    query.addBindValue(chat->id());

    // Execute the query
    if (!query.exec()) {
        qDebug() << "Error: Unable to insert data -" << query.lastError().text();
    } else {
        qDebug() << "Data inserted successfully.";
    }

    // Prepare query to insert both id and name
    query.prepare("DELETE FROM message where chatId = ?");

    // Bind values
    query.addBindValue(chat->id());

    // Execute the query
    if (!query.exec()) {
        qDebug() << "Error: Unable to insert data -" << query.lastError().text();
    } else {
        qDebug() << "Data inserted successfully.";
    }

    // Close the database
    db.close();

    // const int newIndex = chats.indexOf(chat);
    // beginRemoveRows(QModelIndex(), newIndex, newIndex);
    // chats.remove(chat);
    // chats.removeAt(index);
    // endRemoveRows();
    // chat->unloadAndDeleteLater();
}
