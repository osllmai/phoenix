#include "chatmodel.h"

#include <QDebug>
#include "database.h"

ChatModel::ChatModel(const int &parentId,Message* rootMessage, QObject *parent)
    :m_parentId(parentId),root(rootMessage), QAbstractListModel{parent}
{
    Message* beforMessage =root;
    int index = 0;
    while(beforMessage !=nullptr && beforMessage->numberOfChildList() > 0){
        ChatItem* chatItem = new ChatItem(index,beforMessage->child(),beforMessage->child()->child(),
                                          beforMessage->numberOfChildList(),beforMessage->numberOfCurrentChild(),
                                          beforMessage->child()->numberOfChildList(),beforMessage->child()->numberOfCurrentChild(),
                                          beforMessage);
        chatItems.append(chatItem);
        beforMessage = beforMessage->child()->child();
        index++;
    }
}

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
    case DateRequestRole:
        return calculationDateRequest(index.row());
    case ExecutionTimeRole:
        return chatItem->response()->executionTime();
    case NumberOfTokenRole:
        return chatItem->response()->numberOfToken();
    case PromptRole:
        return chatItem->prompt()->text();
    case PromptTimeRole:
        return calculationPromptRequest(index.row());
    case NumberPromptRole:
        return chatItem->numberOfPrompt()+1;
    case NumberOfEditPromptRole:
        return chatItem->numberOfEditPrompt();
    case ResponseRole:
        return chatItem->response()->text();
    case ResponseTimeRole:
        return calculationResponseRequest(index.row());
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
    roles[DateRequestRole] = "dateRequest";
    roles[ExecutionTimeRole] = "executionTime";
    roles[NumberOfTokenRole] = "numberOfToken";
    roles[PromptRole] = "prompt";
    roles[PromptTimeRole] = "promptTime";
    roles[NumberPromptRole] = "numberPrompt";
    roles[NumberOfEditPromptRole] = "numberOfEditPrompt";
    roles[ResponseRole] = "response";
    roles[ResponseTimeRole] = "responseTime";
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
bool ChatModel::isStart() const{
    if(size() <= 1)
        return chatItems.first()->numberOfEditPrompt() >1 || chatItems.first()->numberOfRegenerate() >1;
    return true;
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
    item->response()->setNumberOfToken(item->response()->numberOfToken()+1);
    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {ResponseRole, NumberOfTokenRole});
}

int ChatModel::size(){
    qDebug()<<chatItems.size();
    return chatItems.size();
}

bool ChatModel::deleteChatItem(const int index)
{
    beginRemoveRows(QModelIndex(), index, index);
    delete chatItems.takeAt(index);
    endRemoveRows();
    emit sizeChanged();
    return true;
}

QVariant ChatModel::calculationDateRequest(const int currentIndex)const{
    QDateTime date = chatItems[currentIndex]->prompt()->date();
    QDateTime beforDate ;

    if(currentIndex != 0)
        beforDate = chatItems[currentIndex-1]->prompt()->date();
    if(currentIndex != 0 && beforDate.toString("MM/dd/yyyy") == date.toString("MM/dd/yyyy"))
        return "";

    // QDate today = QDate::currentDate();
    QDateTime now = QDateTime::currentDateTime();
    if (date.daysTo(now) < 1 && date.date().day() == now.date().day())
        return "Today";
    if(date.daysTo(now) < 2 && date.toString("dd")==now.addDays(-1).toString("dd"))
        return "Yesterday";
    if(date.daysTo(now) < 7)
        return date.toString("dddd");
    if(date.toString("yyyy") == now.toString("yyyy"))
        return date.toString("dddd, MMMM dd");
    return date.toString("dddd, MM/dd/yyyy");
}

QVariant ChatModel::calculationPromptRequest(const int currentIndex)const{
    QDateTime date = chatItems[currentIndex]->prompt()->date();

    QDateTime now = QDateTime::currentDateTime();
    if(date.daysTo(now) < 1 && date.toString("dd")==now.toString("dd"))
        return date.toString("hh:mm");
    if(date.daysTo(now) < 2 && date.toString("dd")==now.addDays(-1).toString("dd"))
        return date.toString("Yesterday hh:mm");
    if(date.daysTo(now) < 7)
        return date.toString("dddd hh:mm");
    if (date.toString("yyyy") == now.toString("yyyy"))
        return date.toString("MM/dd hh:mm");
    return date.toString("MM/dd/yyyy hh:mm");
}

QVariant ChatModel::calculationResponseRequest(const int currentIndex)const{
    QDateTime date = chatItems[currentIndex]->response()->date();

    QDateTime now = QDateTime::currentDateTime();
    if(date.daysTo(now) < 1 && date.toString("dd")==now.toString("dd"))
        return date.toString("hh:mm");
    if(date.daysTo(now) < 2 && date.toString("dd")==now.addDays(-1).toString("dd"))
        return date.toString("Yesterday hh:mm");
    if(date.daysTo(now) < 7)
        return date.toString("dddd hh:mm");
    if(date.toString("yyyy") == now.toString("yyyy"))
        return date.toString("MM/dd hh:mm");
    return date.toString("MM/dd/yyyy hh:mm");
}

void ChatModel::setExecutionTime(const int executionTime){
    chatItems.last()->response()->setExecutionTime(executionTime);
    emit dataChanged(createIndex(chatItems.size()-1, 0), createIndex(chatItems.size()-1, 0), {ExecutionTimeRole});
}

void ChatModel::finishedResponnse(){
    Message *prompt = chatItems.last()->prompt();
    Message *response = chatItems.last()->response();
    Message *parent ;
    if(chatItems.size() == 1)
        parent = root;
    else
        parent = chatItems[chatItems.size()-2]->response();
    qInfo()<<root;
    if(prompt->numberOfChildList() == 1){
        int promptId = phoenix_databace::insertMessage(prompt->text(), prompt->isPrompt(), prompt->numberOfToken(),
                                prompt->executionTime(), parent ,m_parentId, prompt->date());
        prompt->setId(promptId);
        int responseId = phoenix_databace::insertMessage(response->text(), response->isPrompt(), response->numberOfToken(),
                                response->executionTime(), prompt, m_parentId, response->date());
        response->setId(responseId);
    }else{
        int responseId = phoenix_databace::insertMessage(response->text(), response->isPrompt(), response->numberOfToken(),
                                response->executionTime(), prompt, m_parentId, response->date());
        response->setId(responseId);
    }
}

void ChatModel::setParentId(const int id){
    m_parentId = id;
}
