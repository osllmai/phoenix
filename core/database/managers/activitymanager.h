#ifndef ACTIVITYMANAGER_H
#define ACTIVITYMANAGER_H

#include <QObject>
#include <QObject>
#include <QQmlEngine>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QString>

#include "config.h"

class ActivityManager : public QObject
{
    Q_OBJECT
    QML_SINGLETON
public:
    explicit ActivityManager(QSqlDatabase db, QObject* parent = nullptr);
    virtual ~ActivityManager();

    void read(const int idConversation, const int idMessage);
    void insert(const int idConversation,
                const int idMessage,
                const QString &text,
                const QString &icon);

signals:
    void add(const int id,
             const int idConversation,
             const int idMessage,
             const QString &text,
             const QString &icon);

private:
    QSqlDatabase m_db;

    static const QString ACTIVITY_SQL;
    static const QString INSERT_ACTIVITY_SQL;
    static const QString READ_CONVERSATION_MESSAGE_ID_SQL;
};

#endif // ACTIVITYMANAGER_H
