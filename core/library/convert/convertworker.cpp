#include "ConvertWorker.h"
#include <QCoreApplication>
#include <QFileInfo>

ConvertWorker::ConvertWorker(const QString &filePath, QObject *parent)
    : QObject(parent), m_filePath(filePath)
{}

void ConvertWorker::process()
{
    if (m_filePath.isEmpty()) {
        emit error("File path is empty!");
        emit finished("");
        return;
    }

    QProcess process;
    process.setProcessChannelMode(QProcess::MergedChannels);
    process.setReadChannel(QProcess::StandardOutput);

    QString exePath = QCoreApplication::applicationDirPath() + "/markitdown/markitdown.exe";
    QStringList arguments;
    arguments << m_filePath;

    process.start(exePath, arguments);
    if (!process.waitForStarted()) {
        emit error("Failed to start process: " + process.errorString());
        emit finished("");
        return;
    }

    QString collectedOutput;

    while (process.state() == QProcess::Running) {
        if (process.waitForReadyRead(500)) {
            QByteArray output = process.readAllStandardOutput();
            QString outputString = QString::fromUtf8(output);
            qInfo() << outputString;
            collectedOutput += outputString;
        }
    }

    if (process.state() != QProcess::NotRunning) {
        process.terminate();
        if (!process.waitForFinished(1000)) {
            process.kill();
            process.waitForFinished();
        }
    }

    emit finished(collectedOutput.trimmed());
}
