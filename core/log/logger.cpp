#include "Logger.h"
#include <QTextStream>
#include <QDebug>

Logger& Logger::instance() {
    static Logger logger;
    return logger;
}

Logger::Logger() {
    m_logDir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation) + "/logs";
    QDir().mkpath(m_logDir);
    qDebug() << "Log directory is:" << m_logDir;

}

Logger::~Logger() {
    QMutexLocker locker(&m_mutex);
    for (auto file : m_logFiles) {
        if (file->isOpen())
            file->close();
        delete file;
    }
    m_logFiles.clear();
}

void Logger::installMessageHandler() {
    qInstallMessageHandler(Logger::messageHandler);
}

void Logger::setMinLogLevel(QtMsgType level) {
    m_minLogLevel = level;
}

void Logger::messageHandler(QtMsgType type, const QMessageLogContext &context, const QString &msg) {
    Logger& logger = Logger::instance();

    if (type < logger.m_minLogLevel)
        return;

    QString category = QString::fromUtf8(context.category);
    logger.writeLog(category, type, msg, context);

    QString levelStr;
    switch (type) {
        case QtDebugMsg:
            levelStr = "DEBUG";
            break;
        case QtInfoMsg:
            levelStr = "INFO";
            break;
        case QtWarningMsg:
            levelStr = "WARNING";
            break;
        case QtCriticalMsg:
            levelStr = "CRITICAL";
            break;
        case QtFatalMsg:
            levelStr = "FATAL";
            break;
        default:
            levelStr = "UNKNOWN";
            break;
    }

    QString timestamp = QDateTime::currentDateTime().toString(Qt::ISODate);
    QString contextInfo = QString("[%1:%2 %3]").arg(
        QString::fromUtf8(context.file),
        QString::number(context.line),
        QString::fromUtf8(context.function)
        );
    QString logLine = QString("[%1] [%2] %3 %4").arg(timestamp, levelStr, contextInfo, msg);

    if (type == QtFatalMsg) {
        QTextStream ts(stderr);
        ts << logLine << Qt::endl;
    } else {
        QTextStream ts(stdout);
        ts << logLine << Qt::endl;
    }

    if (type == QtFatalMsg)
        abort();
}



QFile* Logger::getLogFile(const QString& category) {
    QMutexLocker locker(&m_mutex);

    if (m_logFiles.contains(category))
        return m_logFiles[category];

    QString filename = QString("%1/%2.log").arg(m_logDir, category);
    QFile* file = new QFile(filename);
    if (!file->open(QIODevice::Append | QIODevice::Text)) {
        qWarning() << "Cannot open log file for category" << category;
        delete file;
        return nullptr;
    }

    m_logFiles.insert(category, file);
    writeSessionHeader(file);
    return file;
}

void Logger::rotateLogIfNeeded(const QString& category) {
    QFile* file = m_logFiles.value(category);
    if (!file || !file->isOpen())
        return;

    if (file->size() > MAX_LOG_FILE_SIZE) {
        QString timestamp = QDateTime::currentDateTime().toString("yyyyMMdd_HHmmss");
        QString newName = QString("%1/%2_%3.log").arg(m_logDir, category, timestamp);
        file->close();
        QFile::rename(file->fileName(), newName);

        delete file;
        m_logFiles.remove(category);
    }
}

void Logger::writeSessionHeader(QFile* file) {
    QTextStream out(file);
    QString timeStamp = QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss");
    out << "\n\n\n---------------- SESSION START ----------------\n";
    out << "Time: " << timeStamp << "\n";
    out << "----------------------------------------------\n";
    out.flush();
}

void Logger::writeLog(const QString& category, QtMsgType type, const QString& message, const QMessageLogContext& context) {

    QString levelStr;
    switch (type) {
    case QtDebugMsg:
        levelStr = "DEBUG";
        break;
    case QtInfoMsg:
        levelStr = "INFO";
        break;
    case QtWarningMsg:
        levelStr = "WARNING";
        break;
    case QtCriticalMsg:
        levelStr = "CRITICAL";
        break;
    case QtFatalMsg:
        levelStr = "FATAL";
        break;
    default:
        levelStr = "UNKNOWN";
        break;
    }

    QString timestamp = QDateTime::currentDateTime().toString(Qt::ISODate);
    QString contextInfo = QString("[%1:%2 %3]").arg(QString::fromUtf8(context.file), QString::number(context.line), QString::fromUtf8(context.function));
    QString logLine = QString("[%1] [%2] %3 %4\n").arg(timestamp, levelStr, contextInfo, message);

    if (QString(context.category) == "phoenix.developer") {
        QMutexLocker locker(&m_mutex_developerList);
        m_developerLogs = m_developerLogs + logLine + "\n";
        emit developerLogsChanged();
    }

    rotateLogIfNeeded(category);
    QFile* file = getLogFile(category);
    if (!file)
        return;

    QMutexLocker locker(&m_mutex);
    QTextStream out(file);
    out << logLine;
    out.flush();

    if (type == QtFatalMsg)
        abort();
}

QString Logger::developerLogs() const {
    QMutexLocker locker(&m_mutex_developerList);
    return m_developerLogs;
}
