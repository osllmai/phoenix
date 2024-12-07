#include "database.h"

//----------------------------------****************------------------------------//
//----------------------------------**Function Query**------------------------------//
QSqlError phoenix_databace::initDb(){
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

int phoenix_databace::insertConversation(const QString &title, const QDateTime date){
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");

    db.setDatabaseName("./phoenix.db");
    if (!db.open())
        return -1;

    QSqlQuery query(db);

    if (!query.prepare(INSERT_CONVERSATION_SQL))
        return -1;
    query.addBindValue(title);
    query.addBindValue(date);
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
        query.addBindValue("null");
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
    while(query.next()){
        int id = query.value(0).toInt();
        QString name = query.value(1).toString();
        QString path = query.value(2).toString();
        bool fileExist = false;
        path.remove("file:///");
        QFile file(path);
        if (file.exists()){
            fileExist = true;
        }
        models.append(new Model(id,0,0,name,"","","",path,"","","","","","./images/Phoenix.svg",0,false,fileExist));
    }

    db.close();
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
        qInfo()<< id<<"  "<<title<<"  "<<date.toString("yyyy");
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
    qInfo()<<"---------------------------------------------------------Hii 213";
    while(leaf.size() > 0){
        qInfo()<<"---------------------------------------------------------Hii 215";
        id = leaf.first()->id();
        qInfo()<<"---------------------------------------------------------Hii 217";
        if (!query.prepare(FIND_CHILD_MESSAGE_SQL))
            return query.lastError();
        qInfo()<<"---------------------------------------------------------Hii 220";
        query.addBindValue(id);
        qInfo()<<"---------------------------------------------------------Hii 222";
        query.addBindValue(conversation_id);
        qInfo()<<"---------------------------------------------------------Hii 224";
        if (!query.exec())
            return query.lastError();
        qInfo()<<"---------------------------------------------------------Hii 227";
        while(query.next()){
            qInfo()<<"---------------------------------------------------------Hii 229";
            int id = query.value(0).toInt();
            qInfo()<<"---------------------------------------------------------Hii 231";
            QString text = query.value(1).toString();
            qInfo()<<"---------------------------------------------------------Hii 233";
            bool isPrompt = query.value(2).toBool();
            qInfo()<<"---------------------------------------------------------Hii 235";
            int number_of_token = query.value(3).toInt();
            qInfo()<<"---------------------------------------------------------Hii 237";
            int execution_time = query.value(4).toInt();
            qInfo()<<"---------------------------------------------------------Hii 239";
            QDateTime date = query.value(5).toDateTime();
            qInfo()<<"Hi---------------------------------------------------------"<<id<<date;

            qInfo()<<"----------------------Message->id()"<<id;
            qInfo()<<"----------------------Message->text()"<<text;
            qInfo()<<"----------------------Message->date()"<<number_of_token;
            qInfo()<<"----------------------Message->number_of_token()"<<date;

            Message *message = new Message(id, text, isPrompt, date, number_of_token, execution_time, leaf.first());
            qInfo()<<"----------------------Message->id()"<<message->id();
            qInfo()<<"----------------------Message->text()"<<message->text();
            qInfo()<<"----------------------Message->date()"<<message->date();
            qInfo()<<"----------------------Message->number_of_token()"<<message->numberOfToken();
            qInfo()<<"---------------------------------------------------------Hii 244";
            leaf.first()->addChild(message);
            qInfo()<<"---------------------------------------------------------Hii 246";
            leaf.append(message);
            qInfo()<<"---------------------------------------------------------Hii 248";
        }
        qInfo()<<"---------------------------------------------------------Hii 250";
        leaf.removeFirst();
        qInfo()<<"---------------------------------------------------------Hii 252";
    }
    qInfo()<<"---------------------------------------------------------Hii 254";
    db.close();
    return QSqlError();
}
//-------------------------------**End Function Query**---------------------------//
