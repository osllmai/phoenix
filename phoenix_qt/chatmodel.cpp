#include "chatmodel.h"

#include <QtSql>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

ChatModel::ChatModel(QObject *parent)
    : QAbstractListModel{parent}{}

//*------------------------------------------------------------------------------****************************-----------------------------------------------------------------------------*//
//*------------------------------------------------------------------------------* QAbstractItemModel interface  *------------------------------------------------------------------------------*//
int ChatModel::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return chatItems.size();
}

QVariant ChatModel::data(const QModelIndex &index, int role = Qt::DisplayRole) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= chatItems.count())
        return QVariant();

    //The index is valid
    ChatItem* chatItem = chatItems[index.row()];

    switch (role) {
        case IdRole:
            return chatItem->id();
        case PromptRole:
            return chatItem->prompt();
        case ResponseRole:
            return chatItem->response();
    }

    return QVariant();
}

QHash<int, QByteArray> ChatModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[PromptRole] = "prompt";
    roles[ResponseRole] = "response";
    return roles;
}

Qt::ItemFlags ChatModel::flags(const QModelIndex &index) const {
    if (!index.isValid())
        return Qt::NoItemFlags;
    return Qt::ItemIsEditable;
}

bool ChatModel::setData(const QModelIndex &index, const QVariant &value, int role) {
    ChatItem* chatItem = chatItems[index.row()]; // The person to edit
    bool somethingChanged{false};

    switch (role) {
        case IdRole:
            if( chatItem->id()!= value.toInt()){
                chatItem->setId(value.toInt());
                somethingChanged = true;
            }
            break;
        case PromptRole:
            if( chatItem->prompt()!= value.toString()){
                chatItem->setPrompt(value.toString());
                somethingChanged = true;
            }
            break;
        case ResponseRole:
            if( chatItem->response()!= value.toString()){
                chatItem->setResponse(value.toString());
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


void ChatModel::prompt(const QString &prompt){
    emit startPrompt(prompt);
    const int index = chatItems.size();
    ChatItem *chatItem = new ChatItem(index, prompt, this);
    beginInsertRows(QModelIndex(), index, index);//Tell the model that you are about to add data
    chatItems.append(chatItem);
    endInsertRows();
}

 void ChatModel::updateResponse(const QString &response){
    const int index = chatItems.size() - 1;
    if (index < 0 || index >= chatItems.size()) return;

    ChatItem *item = chatItems[index];
    item->setResponse(item->response() + response);
    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {ResponseRole});

}

 void ChatModel::saveChatItem(int parentId){
     const int index = chatItems.size() - 1;
     ChatItem *item = chatItems[index];

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
     query.exec("CREATE TABLE IF NOT EXISTS message (id INTEGER, chatId INTEGER, beforeMessageId INTEGER, prompt TEXT, response TEXT)");

     // Prepare query to insert both id and name
     query.prepare("INSERT INTO message (id, chatId, beforeMessageId, prompt, response) VALUES (?, ?, ?, ?, ?)");

     // Bind values
     query.addBindValue(item->id());   //  id value
     query.addBindValue(parentId); // The name provided by the function parameter
     if(index == 0)
         query.addBindValue(-1);
     else
        query.addBindValue(chatItems[index-1]->id()); // The name provided by the function parameter
     query.addBindValue(item->prompt()); // The name provided by the function parameter
     query.addBindValue(item->response()); // The name provided by the function parameter

     // Execute the query
     if (!query.exec()) {
         qDebug() << "****Error: Unable to insert data -" << query.lastError().text();
     } else {
         qDebug() << "****Data inserted successfully.";
     }

     // Close the database
     db.close();
 }

 void ChatModel::addChatItem(int id, QString prompt, QString response){
     const int index = chatItems.size();
     ChatItem *chatItem = new ChatItem(id, prompt, this);
     chatItem->setResponse(response);
     beginInsertRows(QModelIndex(), index, index);//Tell the model that you are about to add data
     chatItems.append(chatItem);
     endInsertRows();
 }

 int ChatModel::size(){
     qDebug()<<chatItems.size();
     return chatItems.size();
 }
