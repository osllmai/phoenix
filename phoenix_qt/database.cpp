#include "database.h"

//----------------------------------****************------------------------------//
//----------------------------------**Function Query**------------------------------//
QSqlError phoenix_databace::initDb(){
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("./phoenix.db");
    if (!db.open())
        return db.lastError();

    QSqlQuery query(db);
    if (!query.exec(FOREIGN_KEYS_SQL))
        return query.lastError();

    QStringList tables = db.tables();
    if (tables.contains("model", Qt::CaseInsensitive) && tables.contains("conversation", Qt::CaseInsensitive) && tables.contains("message", Qt::CaseInsensitive))
        return QSqlError();

    if (!query.exec(MODEL_SQL))
        return query.lastError();

    if (!query.exec(CONVERSATION_SQL))
        return query.lastError();

    if (!query.exec(MESSAGE_SQL))
        return query.lastError();

    db.close();
    return QSqlError();
}

Model* phoenix_databace::insertModel(const QString &name, const QString &path){
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    Model *model = nullptr;

    db.setDatabaseName("./phoenix.db");
    if (!db.open())
        return model;

    QSqlQuery query(db);

    if (!query.prepare(INSERT_MODEL_SQL))
        return model;
    query.addBindValue(name);
    query.addBindValue(path);
    query.exec();

    model = new Model(query.lastInsertId().toInt() ,0 ,0 ,name ,"","","",path ,"","","","","","./images/Phoenix.svg" ,0,false ,false );

    db.close();
    return model;
}

// int phoenix_databace::insertConversation(const QString &title, const QDateTime date){
int phoenix_databace::insertConversation(const QString &title, const QDateTime date, const bool &stream,
                           const QString &promptTemplate, const QString &systemPrompt, const double &temperature,
                           const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                           const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                           const int &contextLength, const int &numberOfGPULayers){
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");

    db.setDatabaseName("./phoenix.db");
    if (!db.open())
        return -1;

    QSqlQuery query(db);

    if (!query.prepare(INSERT_CONVERSATION_SQL))
        return -1;
    query.addBindValue(title);
    query.addBindValue(date);
    query.addBindValue(stream);
    query.addBindValue(promptTemplate);
    query.addBindValue(systemPrompt);
    query.addBindValue(temperature);
    query.addBindValue(topK);
    query.addBindValue(topP);
    query.addBindValue(minP);
    query.addBindValue(repeatPenalty);
    query.addBindValue(promptBatchSize);
    query.addBindValue(maxTokens);
    query.addBindValue(repeatPenaltyTokens);
    query.addBindValue(contextLength);
    query.addBindValue(numberOfGPULayers);
    query.exec();

    int id = query.lastInsertId().toInt();

    db.close();
    return id;
}

int phoenix_databace::insertMessage(const QString &text, const bool isPrompt, const int numberOfTokens,
                                    const int executionTime, const Message *parent, const int &conversation_id,const QDateTime date){
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");

    db.setDatabaseName("./phoenix.db");
    if (!db.open())
        return -1;

    QSqlQuery query(db);

    if (!query.prepare(INSERT_MESSAGE_SQL))
        return -1;
    query.addBindValue(text);

    query.addBindValue(isPrompt);
    query.addBindValue(numberOfTokens);
    query.addBindValue(executionTime);

    if(parent->id() == -1)
        query.addBindValue(0);
    else
        query.addBindValue(parent->id());
    query.addBindValue(conversation_id);
    query.addBindValue(date);
    query.exec();

    int id = query.lastInsertId().toInt();
    qInfo()<<"insert message"<<id<<"  "<<conversation_id;

    db.close();
    return id;
}

QSqlError phoenix_databace::deleteModel(const int &id){
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("./phoenix.db");
    if (!db.open())
        return db.lastError();

    QSqlQuery query(db);

    if (!query.prepare(DELETE_MODEL_SQL))
        return query.lastError();
    query.addBindValue(id);
    query.exec();

    db.close();
    return QSqlError();
}

QSqlError phoenix_databace::deleteConversation(const int &id){
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("./phoenix.db");
    if (!db.open())
        return db.lastError();

    QSqlQuery query(db);

    if (!query.prepare(DELETE_CONVERSATION_SQL))
        return query.lastError();
    query.addBindValue(id);
    query.exec();

    if (!query.prepare(DELETE_MESSAGE_SQL))
        return query.lastError();
    query.addBindValue(id);
    query.exec();

    db.close();
    return QSqlError();
}

QList<Model*> phoenix_databace::readModel(){
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    QList<Model*> models ;
    db.setDatabaseName("./phoenix.db");
    if (!db.open())
        return models;

    QSqlQuery query(db);

    if (!query.exec(READ_MODEL_SQL))
        return models;
    QList<Model*> notExistListr;
    while(query.next()){
        int id = query.value(0).toInt();
        QString name = query.value(1).toString();
        QString path = query.value(2).toString();
        bool fileExist = true;
        QFile file(path);
        if (!file.exists())
            fileExist = false;
        Model *model = new Model(id,0,0,name,"","","",path,"","","","","","./images/Phoenix.svg",0,false,fileExist);
        models.append(model);
        if(!fileExist){
            notExistListr.append(model);
        }
    }
    db.close();
    while(notExistListr.size()>0){
        updateModelPath(notExistListr.first()->id(),"");
        notExistListr.removeFirst();
    }
    return models;
}

QList<Chat*> phoenix_databace::readConversation(){
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    QList<Chat*> chats ;
    db.setDatabaseName("./phoenix.db");
    if (!db.open())
        return chats;

    QSqlQuery query(db);

    if (!query.exec(READ_CONVERSATION_SQL))
        return chats;
    while(query.next()){
        int id = query.value(0).toInt();
        QString title = query.value(1).toString();
        QDateTime date = query.value(2).toDateTime();
        Message *root = new Message(-1,"root",true);
        chats.append(new Chat(id, title,date, root));
        chats.last()->modelSettings()->setStream(query.value(3).toBool());
        chats.last()->modelSettings()->setPromptTemplate(query.value(4).toString());
        chats.last()->modelSettings()->setSystemPrompt(query.value(5).toString());
        chats.last()->modelSettings()->setTemperature(query.value(6).toDouble());
        chats.last()->modelSettings()->setTopK(query.value(7).toInt());
        chats.last()->modelSettings()->setTopP(query.value(8).toDouble());
        chats.last()->modelSettings()->setMinP(query.value(9).toDouble());
        chats.last()->modelSettings()->setRepeatPenalty(query.value(10).toDouble());
        chats.last()->modelSettings()->setPromptBatchSize(query.value(11).toInt());
        chats.last()->modelSettings()->setMaxTokens(query.value(12).toInt());
        chats.last()->modelSettings()->setRepeatPenaltyTokens(query.value(13).toInt());
        chats.last()->modelSettings()->setContextLength(query.value(14).toInt());
        chats.last()->modelSettings()->setNumberOfGPULayers(query.value(15).toInt());
    }
    db.close();
    return chats;
}

QSqlError phoenix_databace::readMessage(Message *root, const int &conversation_id){
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("./phoenix.db");
    if (!db.open())
        return db.lastError();

    QSqlQuery query(db);

    if (!query.prepare(FIND_ROOT_MESSAGE_SQL))
        return query.lastError();
    query.addBindValue(conversation_id);
    if (!query.exec())
        return query.lastError();

    query.next();
    int id = query.value(0).toInt();
    root->setId(id);

    QList<Message*> leaf ;
    leaf.append(root);

    while(leaf.size() > 0){
        id = leaf.first()->id();
        if (!query.prepare(FIND_CHILD_MESSAGE_SQL))
            return query.lastError();
        query.addBindValue(id);
        query.addBindValue(conversation_id);
        if (!query.exec())
            return query.lastError();

        while(query.next()){
            int id = query.value(0).toInt();
            QString text = query.value(1).toString();
            bool isPrompt = query.value(2).toBool();
            int number_of_token = query.value(3).toInt();
            int execution_time = query.value(4).toInt();
            QDateTime date = query.value(5).toDateTime();

            Message *message = new Message(id, text, isPrompt, date, number_of_token, execution_time, leaf.first());
            leaf.first()->addChild(message);
            leaf.append(message);
        }
        leaf.removeFirst();
    }
    db.close();
    return QSqlError();
}

QSqlError phoenix_databace::updateModelPath(const int &id, const QString &path){
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("./phoenix.db");
    if (!db.open())
        return db.lastError();

    QSqlQuery query(db);

    if (!query.prepare(UPDATE_PATH_MODEL_SQL))
        return query.lastError();
    query.addBindValue(path);
    query.addBindValue(id);
    query.exec();

    db.close();
    return QSqlError();
}

QSqlError phoenix_databace::updateConversationName(const int &id, const QString &name){
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("./phoenix.db");
    if (!db.open())
        return db.lastError();

    QSqlQuery query(db);

    if (!query.prepare(UPDATE_TITLE_CONVERSATION_SQL))
        return query.lastError();
    query.addBindValue(name);
    query.addBindValue(id);
    query.exec();

    db.close();
    return QSqlError();
}

QSqlError phoenix_databace::updateConversationDate(const int &id, const QDateTime date){
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("./phoenix.db");
    if (!db.open())
        return db.lastError();

    QSqlQuery query(db);

    if (!query.prepare(UPDATE_DATE_CONVERSATION_SQL))
        return query.lastError();
    query.addBindValue(date);
    query.addBindValue(id);
    query.exec();

    db.close();
    return QSqlError();
}
//-------------------------------**End Function Query**---------------------------//
