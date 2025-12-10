#ifndef SOURCESMANAGER_H
#define SOURCESMANAGER_H

#include <QObject>
#include <QQmlEngine>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QString>

#include "config.h"

class SourcesManager : public QObject
{
    Q_OBJECT
    QML_SINGLETON
public:
    explicit SourcesManager(QSqlDatabase db, QObject* parent = nullptr);
    virtual ~SourcesManager();

    void read(const int idConversation, const int idMessage);
    void insert(const int idConversation,
                const int idMessage,
                const QString &titel,
                const QString &text,
                const QString &icon);

signals:
    void add(const int id,
             const int idConversation,
             const int idMessage,
             const QString &titel,
             const QString &text,
             const QString &icon);

private:
    QSqlDatabase m_db;

    static const QString SOURCES_SQL;
    static const QString INSERT_SOURCES_SQL;
    static const QString READ_CONVERSATION_MESSAGE_ID_SQL;
};

#endif // SOURCESMANAGER_H
