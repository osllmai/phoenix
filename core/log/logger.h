#ifndef LOGGER_H
#define LOGGER_H

#include <QFile>
#include <QHash>
#include <QMutex>
#include <QString>
#include <QLoggingCategory>
#include <QDateTime>
#include <QDir>
#include <QStandardPaths>

class Logger
{
public:
    static Logger& instance();

    void installMessageHandler();
    void setMinLogLevel(QtMsgType level);

private:
    Logger();
    ~Logger();

    static void messageHandler(QtMsgType type, const QMessageLogContext &context, const QString &msg);
    void writeLog(const QString& category, QtMsgType type, const QString& message, const QMessageLogContext& context);
    QFile* getLogFile(const QString& category);
    void rotateLogIfNeeded(const QString& category);
    void writeSessionHeader(QFile* file);

    QHash<QString, QFile*> m_logFiles;
    QMutex m_mutex;
    QString m_logDir;
    QtMsgType m_minLogLevel = QtDebugMsg;
    const qint64 MAX_LOG_FILE_SIZE = 5 * 1024 * 1024; // 5 MB

    Logger(const Logger&) = delete;
    Logger& operator=(const Logger&) = delete;
};

#endif // LOGGER_H
