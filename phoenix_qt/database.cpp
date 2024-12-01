#include "database.h"

//----------------------------------****************------------------------------//
//----------------------------------**Function Query**------------------------------//
QSqlError initDb(){
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("./phoenix.db");
    if (!db.open())
        return db.lastError();

    QStringList tables = db.tables();
    if (tables.contains("model", Qt::CaseInsensitive) && tables.contains("conversation", Qt::CaseInsensitive) && tables.contains("message", Qt::CaseInsensitive))
        return QSqlError();

    QSqlQuery query(db);
    if (!query.exec(FOREIGN_KEYS_SQL))
        return query.lastError();

    if (!query.exec(MODEL_SQL))
        return query.lastError();

    if (!query.exec(CONVERSATION_SQL))
        return query.lastError();

    if (!query.exec(MESSAGE_SQL))
        return query.lastError();

    db.close();
    return QSqlError();
}

Model* insertModel(const QString &name, const QString &path){
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    Model *model ;

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

QSqlError insertConversation(const QString &name, const QDateTime date){
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("./phoenix.db");
    if (!db.open())
        return db.lastError();

    QSqlQuery query(db);

    if (!query.prepare(INSERT_CONVERSATION_SQL))
        return query.lastError();
    query.addBindValue(name);
    query.addBindValue(date);
    query.exec();

    db.close();
    return QSqlError();
}

QSqlError insertMessage(const QString &text, const bool isPrompt, const int numberOfTokens,
                        const int executionTime, const QVariant &parentId, const QVariant &conversationId,const QDateTime date){
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("./phoenix.db");
    if (!db.open())
        return db.lastError();

    QSqlQuery query(db);

    if (!query.prepare(INSERT_MESSAGE_SQL))
        return query.lastError();
    query.addBindValue(text);
    query.addBindValue(isPrompt);
    query.addBindValue(numberOfTokens);
    query.addBindValue(executionTime);
    query.addBindValue(parentId);
    query.addBindValue(conversationId);
    query.addBindValue(date);
    query.exec();

    db.close();
    return QSqlError();
}

QSqlError deleteModel(const int &id){
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

QSqlError deleteConversation(const int &id){
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("./phoenix.db");
    if (!db.open())
        return db.lastError();

    QSqlQuery query(db);

    if (!query.prepare(DELETE_CONVERSATION_SQL))
        return query.lastError();
    query.addBindValue(id);
    query.exec();

    db.close();
    return QSqlError();
}

QSqlError deleteMessage(const int &id){
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("./phoenix.db");
    if (!db.open())
        return db.lastError();

    QSqlQuery query(db);

    if (!query.prepare(DELETE_MESSAGE_SQL))
        return query.lastError();
    query.addBindValue(id);
    query.exec();

    db.close();
    return QSqlError();
}

QList<Model*> readModel(){
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    QList<Model*> models ;
    db.setDatabaseName("./phoenix.db");
    if (!db.open())
        return models;

    QSqlQuery query(db);

    if (!query.exec(READ_MODEL_SQL))
        return models;
    while(query.next()){
        int id = query.value(0).toInt();
        QString name = query.value(1).toString();
        QString path = query.value(2).toString();
        bool fileExist = false;
        QFile file(path);
        if (file.exists()){
            fileExist = true;
        }
        models.append(new Model(id,0,0,name,"","","",path,"","","","","","./images/Phoenix.svg",0,false,fileExist));
    }

    db.close();
    return models;
}

QSqlError readChat(ChatListModel &chatListModel){
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("./phoenix.db");
    if (!db.open())
        return db.lastError();

    QSqlQuery query(db);

    // if (!query.prepare(DELETE_CONVERSATION_SQL))
    //     return query.lastError();
    // query.addBindValue(id);
    // query.exec();

    db.close();
    return QSqlError();
}
//-------------------------------**End Function Query**---------------------------//
