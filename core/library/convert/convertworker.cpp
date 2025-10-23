#include "convertworker.h"
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

    // --- Cross-platform executable path ---
    QString exeName;
#if defined(Q_OS_WIN)
    exeName = "convert_pdf.exe";
#elif defined(Q_OS_MAC)
    exeName = "convert_pdf";
#elif defined(Q_OS_LINUX)
    exeName = "convert_pdf";
#else
    emit error("Unsupported platform");
    emit finished("");
    return;
#endif

    QString exePath = QString::fromUtf8(APP_PATH) + "/markitdown/" + exeName;
    QFileInfo exeInfo(exePath);
    if (!exeInfo.exists() || !exeInfo.isExecutable()) {
        emit error("Executable not found or not executable: " + exePath);
        emit finished("");
        return;
    }

    QStringList arguments;
    arguments << m_filePath;

    process.start(exePath, arguments);
    if (!process.waitForStarted(3000)) {
        emit error("Failed to start process: " + process.errorString());
        emit finished("");
        return;
    }

    QString collectedOutput;
    while (process.state() == QProcess::Running) {
        if (process.waitForReadyRead(500)) {
            QString outputString = QString::fromUtf8(process.readAllStandardOutput());
            qInfo() << outputString;
            collectedOutput += outputString;
        }
    }

    process.waitForFinished();

    if (process.exitStatus() != QProcess::NormalExit) {
        emit error("Process crashed or did not exit normally.");
    }

    emit finished(collectedOutput.trimmed());
}
