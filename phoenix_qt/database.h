#ifndef DATABASE_H
#define DATABASE_H

#include <QDateTime>
#include <QSqlError>
#include <QSqlQuery>
#include "modellist.h"
#include "chatmodel.h"
#include "chatlistmodel.h"

const auto FOREIGN_KEYS_SQL = QLatin1String(R"(
    PRAGMA foreign_keys = ON;
    )");

//------------------------------------**************-------------------------------//
//------------------------------------**Model Query**-------------------------------//
const auto MODEL_SQL = QLatin1String(R"(
    CREATE TABLE model(
            id INTEGER NOT NULL UNIQUE,
            name TEXT NOT NULL,
            path TEXT NOT NULL,
            PRIMARY KEY(id AUTOINCREMENT))
    )");

const auto INSERT_MODEL_SQL = QLatin1String(R"(
    INSERT INTO model(name, path) VALUES (?, ?)
    )");

const auto READ_MODEL_SQL = QLatin1String(R"(
    SELECT id, name, path FROM model
    )");

const auto DELETE_MODEL_SQL = QLatin1String(R"(
    DELETE FROM model where id = ?
    )");
//---------------------------------**End Model Query**----------------------------//


//--------------------------------*******************---------------------------//
//--------------------------------**Conversation Query**--------------------------//
const auto CONVERSATION_SQL = QLatin1String(R"(
    CREATE TABLE conversation(
            id INTEGER NOT NULL UNIQUE,
            title TEXT NOT NULL,
            date DATE NOT NULL,
            PRIMARY KEY(id AUTOINCREMENT))
    )");

const auto INSERT_CONVERSATION_SQL = QLatin1String(R"(
    INSERT INTO conversation(title, date) VALUES (?, ?)
    )");

const auto READ_CONVERSATION_SQL = QLatin1String(R"(
    SELECT id, title, date FROM conversation
    )");

const auto UPDATE_DATE_CONVERSATION_SQL = QLatin1String(R"(
    UPDATE conversation SET date=? Where id=?
    )");

const auto UPDATE_TITLE_CONVERSATION_SQL = QLatin1String(R"(
    UPDATE conversation SET title=? Where id=?
    )");

const auto DELETE_CONVERSATION_SQL = QLatin1String(R"(
    DELETE FROM conversation where id = ?
    )");
//-----------------------------**End Conversation Query**-----------------------//


//----------------------------------****************------------------------------//
//----------------------------------**Message Query**------------------------------//
const auto MESSAGE_SQL = QLatin1String(R"(
    CREATE TABLE message(
            id INTEGER NOT NULL UNIQUE,
            text TEXT NOT NULL,
            is_prompt BOOL NOT NULL,
            number_of_token INTEGER,
            execution_time INTEGER,
            parent_id INTEGER,
            conversation_id INTEGER NOT NULL,
            date DATE NOT NULL,
            PRIMARY KEY(id AUTOINCREMENT),
            foreign key(parent_id) REFERENCES message(id) ON DELETE CASCADE,
            foreign key(conversation_id) REFERENCES conversation(id) ON DELETE CASCADE)
    )");

const auto INSERT_MESSAGE_SQL = QLatin1String(R"(
    INSERT INTO message (text, is_prompt, number_of_token, execution_time, parent_id, conversation_id, date) VALUES (?, ?, ?, ?, ?, ?, ?)
    )");

const auto READ_MESSAGE_SQL = QLatin1String(R"(
    SELECT id, text, is_prompt, number_of_token, execution_time, parent_id, conversation_id, date FROM message
    )");

const auto FIND_ROOT_MESSAGE_SQL = QLatin1String(R"(
    SELECT id FROM message WHERE parent_id = null AND conversation_id =?
    )");

const auto FIND_CHILD_MESSAGE_SQL = QLatin1String(R"(
    SELECT id FROM message WHERE parent_id = ? AND conversation_id =?
    )");

const auto DELETE_MESSAGE_SQL = QLatin1String(R"(
    DELETE FROM message where id = ?
    )");
//-------------------------------**End Message Query**----------------------------//


//----------------------------------****************------------------------------//
//----------------------------------**Function Query**------------------------------//
QSqlError initDb();

QSqlError insertModel(ModelList &modelList, const QString &name, const QString &path);

QSqlError insertConversation(const QString &name, const QDateTime date);

QSqlError insertMessage(const QString &text, const bool isPrompt, const int numberOfTokens,
                        const int executionTime, const QVariant &parentId, const QVariant &conversationId,const QDateTime date);

QSqlError deleteModel(const int &id);

QSqlError deleteConversation(const int &id);

QSqlError deleteMessage(const int &id);

QSqlError readModel(ModelList &modelList);

QSqlError readChat(ChatListModel &chatListModel);
//-------------------------------**End Function Query**---------------------------//

#endif // DATABASE_H
