#ifndef DATABASE_H
#define DATABASE_H

#include <QDateTime>
#include <QSqlError>
#include <QSqlQuery>

#include "./model/offline/offlinemodel.h"
#include "./model/online/onlinemodel.h"
#include "./model/BackendType.h"
#include "./model/company.h"

class Database: public QObject
{
public:
    static Database* instance(QObject* parent);

public slots:
    void readModel(const QList<Company*> companys);

    void insertModel(const QString &name, const QString &key, const BackendType backend);

    QSqlError deleteModel(const int id);

    QSqlError updateKeyModel(const int id, const QString &key);
    QSqlError updateIsLikeModel(const int id, const bool isLike);

signals:
    void addOnlineModel();

private:
    static Database* m_instance;
    explicit Database(QObject* parent);
    virtual ~Database();

    QSqlDatabase m_db;
    QThread m_dbThread;

    static const QString MODEL_SQL;
    static const QString FOREIGN_KEYS_SQL;
    static const QString INSERT_MODEL_SQL;
    static const QString READALL_MODEL_SQL;
    static const QString READ_MODEL_SQL;
    static const QString UPDATE_KEYMODEL_SQL;
    static const QString UPDATE_ISLIKE_SQL;
    static const QString DELETE_MODEL_SQL;

    QList<OfflineModel*> parseModelJson(const QList<Company*> companys);
};

#endif // DATABASE_H
