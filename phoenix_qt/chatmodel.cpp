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
            return chatItem->prompt()->text();
        case NumberPromptRole:
            return chatItem->numberOfPrompt()+1;
        case NumberOfEditPromptRole:
            return chatItem->numberOfEditPrompt();
        case ResponseRole:
            return chatItem->response()->text();
        case NumberResponseRole:
            return chatItem->numberOfResponse()+1;
        case NumberOfRegenerateRole:
            return chatItem->numberOfRegenerate();
    }

    return QVariant();
}

QHash<int, QByteArray> ChatModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[PromptRole] = "prompt";
    roles[NumberPromptRole] = "numberPrompt";
    roles[NumberOfEditPromptRole] = "numberOfEditPrompt";
    roles[ResponseRole] = "response";
    roles[NumberResponseRole] = "numberResponse";
    roles[NumberOfRegenerateRole] = "numberOfRegenerate";
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
            if( chatItem->prompt()->text()!= value.toString()){
                chatItem->prompt()->setText(value.toString());
                somethingChanged = true;
            }
            break;
        case ResponseRole:
            if( chatItem->response()->text()!= value.toString()){
                chatItem->response()->setText(value.toString());
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
int ChatModel::size() const{
    return chatItems.size();
}
//*--------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//


void ChatModel::prompt(const QString &promptText){
    emit startPrompt(promptText);
    const int index = chatItems.size();
    ChatItem *chatItem;
    if(index == 0){
        //when start the chat, we need connect prompt to the root
        Message *prompt = new Message(index,promptText, true, root);
        root->addChild(prompt);
        Message *response = new Message(index,"", false, prompt);
        prompt->addChild(response);
        chatItem = new ChatItem(index,prompt,response,root->numberOfCurrentChild(),root->numberOfChildList(),prompt->numberOfCurrentChild(),prompt->numberOfChildList(),this);
    }else{
        Message *prompt = new Message(index,promptText, true, chatItems.last()->response());
        chatItems.last()->response()->addChild(prompt);
        Message *response = new Message(index,"", false, prompt);
        prompt->addChild(response);
        chatItem = new ChatItem(index, prompt, response, chatItems.last()->response()->numberOfCurrentChild(), chatItems.last()->response()->numberOfChildList(),prompt->numberOfCurrentChild(),prompt->numberOfChildList(), this);
    }

    beginInsertRows(QModelIndex(), index, index);//Tell the model that you are about to add data
    chatItems.append(chatItem);
    endInsertRows();
    emit sizeChanged();
}

/// numberOfNext betwean [0,numberOfChildList]
void ChatModel::nextPrompt(const int index, const int numberOfNext){

    qInfo()<<index<<"   "<<  numberOfNext;
    if(index == 0 && numberOfNext>=0 && numberOfNext < root->numberOfChildList()){
        //set next 'numberOfNext' for current child parent because I need see this child
        root->nextChild(numberOfNext);

        nextResponse(index, root->child()->numberOfCurrentChild());

    }else if(numberOfNext>=0 && numberOfNext< chatItems[index-1]->response()->numberOfChildList()){
        //set next 'numberOfNext' for current child parent because I need see this child
        chatItems[index-1]->response()->nextChild(numberOfNext);

        nextResponse(index,chatItems[index-1]->response()->child()->numberOfCurrentChild());

    }
}

void ChatModel::editPrompt(const int index,const QString &promptText){

    //delete next chatItem because one see branch is change
    while(index<chatItems.size()){
        deleteChatItem(index);
    }

    prompt(promptText);
}

void ChatModel::nextResponse(const int index, const int numberOfNext){
    //set next response
    chatItems[index]->prompt()->nextChild(numberOfNext);

    //delete next chatItem because one see branch is change
    while(index<chatItems.size()){
        deleteChatItem(index);
    }

    Message *parentPrompt;
    if(index == 0)
        parentPrompt = root;
    else
        parentPrompt = chatItems.last()->response();

    if(numberOfNext >= 0 && numberOfNext < parentPrompt->numberOfChildList()){

        //update next prompt and response for this branch
        while(parentPrompt->child() != nullptr){
            Message *prompt = parentPrompt->child();
            Message *response = prompt->child();

            ChatItem *chatItem = new ChatItem(chatItems.size(), prompt, response,
                                    parentPrompt->numberOfCurrentChild(), parentPrompt->numberOfChildList(),
                                    prompt->numberOfCurrentChild(), prompt->numberOfChildList(), this);
            beginInsertRows(QModelIndex(), chatItems.size(), chatItems.size());//Tell the model that you are about to add data
            chatItems.append(chatItem);
            endInsertRows();

            parentPrompt = chatItems.last()->response();
        }
    }
    emit sizeChanged();
}

void ChatModel::regenerateResponse(const int index){

    //delete next chatItem because one see branch is change
    while(index<chatItems.size()){
        deleteChatItem(index);
    }

    ChatItem *chatItem;
    if(index == 0){
        //when start the chat, we need connect prompt to the root
        Message *response = new Message(index,"", false, root->child());
        root->child()->addChild(response);
        chatItem = new ChatItem(index, root->child(), response,
                                root->numberOfCurrentChild(), root->numberOfChildList(),
                                root->child()->numberOfCurrentChild(), root->child()->numberOfChildList(),this);
    }else{
        Message *prompt = chatItems.last()->response()->child();
        Message *response = new Message(index,"", false, prompt);
        prompt->addChild(response);
        chatItem = new ChatItem(index, prompt, response,
                                chatItems.last()->response()->numberOfCurrentChild(), chatItems.last()->response()->numberOfChildList(),
                                prompt->numberOfCurrentChild(), prompt->numberOfChildList(), this);
    }

    beginInsertRows(QModelIndex(), index, index);//Tell the model that you are about to add data
    chatItems.append(chatItem);
    endInsertRows();
    emit sizeChanged();

    emit startPrompt("regenerate: "+chatItems[index]->response()->text());
}


 void ChatModel::updateResponse(const QString &response){
    const int index = chatItems.size() - 1;
    if (index < 0 || index >= chatItems.size()) return;

    ChatItem *item = chatItems[index];
    item->response()->setText(item->response()->text() + response);
    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {ResponseRole});
}

 // void ChatModel::saveChatItem(int parentId){
 //     // const int index = chatItems.size() - 1;
 //     // ChatItem *item = chatItems[index];

 //     // // Open the database
 //     // QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
 //     // db.setDatabaseName("./phoenix.db");  // Replace with the actual path to your DB
 //     // if (!db.open()) {
 //     //     qDebug() << "Error: Unable to open database" << db.lastError().text();
 //     //     return;
 //     // }

 //     // // Prepare and execute the SQL query
 //     // QSqlQuery query(db);

 //     // // Create table with id and name columns
 //     // query.exec("CREATE TABLE IF NOT EXISTS message (id INTEGER, chatId INTEGER, beforeMessageId INTEGER, prompt TEXT, response TEXT)");

 //     // // Prepare query to insert both id and name
 //     // query.prepare("INSERT INTO message (id, chatId, beforeMessageId, prompt, response) VALUES (?, ?, ?, ?, ?)");

 //     // // Bind values
 //     // query.addBindValue(item->id());   //  id value
 //     // query.addBindValue(parentId); // The name provided by the function parameter
 //     // if(index == 0)
 //     //     query.addBindValue(-1);
 //     // else
 //     //    query.addBindValue(chatItems[index-1]->id()); // The name provided by the function parameter
 //     // query.addBindValue(item->prompt()); // The name provided by the function parameter
 //     // query.addBindValue(item->response()); // The name provided by the function parameter

 //     // // Execute the query
 //     // if (!query.exec()) {
 //     //     qDebug() << "****Error: Unable to insert data -" << query.lastError().text();
 //     // } else {
 //     //     qDebug() << "****Data inserted successfully.";
 //     // }

 //     // // Close the database
 //     // db.close();
 // }

 // void ChatModel::addChatItem(int id, QString prompt, QString response){
 //     // const int index = chatItems.size();
 //     // ChatItem *chatItem = new ChatItem(id, prompt, this);
 //     // chatItem->setResponse(response);
 //     // beginInsertRows(QModelIndex(), index, index);//Tell the model that you are about to add data
 //     // chatItems.append(chatItem);
 //     // endInsertRows();
 // }

 int ChatModel::size(){
     qDebug()<<chatItems.size();
     return chatItems.size();
 }

 bool ChatModel::deleteChatItem(const int index){
     ChatItem* chatItem = chatItems.at(index);
     const int nextIndex = chatItems.indexOf(chatItem);
     beginRemoveRows(QModelIndex(), nextIndex, nextIndex);
     chatItems.removeAll(chatItem);
     endRemoveRows();
     emit sizeChanged();
     return true;
 }
