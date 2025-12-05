#include "speechtotextworker.h"
#include <QCoreApplication>
#include <QRegularExpression>
#include <QDebug>
#include <regex>
#include <QFileInfo>

SpeechToTextWorker::SpeechToTextWorker(const QString &modelPath, const QString &audioPath, bool cuda, QObject *parent)
    : QObject(parent), m_modelPath(modelPath), m_audioPath(audioPath), m_cuda(cuda), m_stopFlag(false)
{}

void SpeechToTextWorker::process()
{
    if (m_modelPath.isEmpty() || m_audioPath.isEmpty()) {
        emit errorOccurred("Model path or audio path is empty!");
        emit finished();
        return;
    }

    QProcess process;
    process.setProcessChannelMode(QProcess::MergedChannels);
    process.setReadChannel(QProcess::StandardOutput);

    QString exeFileName;
#if defined(Q_OS_WIN)
    exeFileName = "whisper-cli.exe";
#else
    exeFileName = "whisper-cli";  // macOS و Linux
#endif

    QString deviceFolder;
#if defined(Q_OS_MAC)
    deviceFolder = "whisper/";
#else
    deviceFolder = m_cuda ? "cuda-device/" : "cpu-device/";
#endif

    QString exePath = QString::fromUtf8(APP_PATH)
                      + "/whisper/" + deviceFolder + exeFileName;

    if (!QFileInfo::exists(exePath)) {
        emit errorOccurred("Whisper executable not found: " + exePath);
        emit finished();
        return;
    }

#if defined(Q_OS_LINUX)
    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
    QString currentPath = env.value("LD_LIBRARY_PATH");
    env.insert("LD_LIBRARY_PATH",
               QString::fromUtf8(APP_PATH) +
                   (currentPath.isEmpty() ? "" : ":" + currentPath));
    process.setProcessEnvironment(env);
#endif

    QStringList arguments;
    arguments << "-m" << m_modelPath
              << "-f" << m_audioPath
              << "--print-progress"
              << "--language" << "auto";

    process.start(exePath, arguments);

    if (!process.waitForStarted()) {
        emit errorOccurred("Failed to start process: " + process.errorString());
        emit finished();
        return;
    }

    QString collectedText;
    std::regex timestamp_regex(R"(^\[\d{2}:\d{2}:\d{2}\.\d{3} --> \d{2}:\d{2}:\d{2}\.\d{3}\]\s*(.+)$)");
    std::regex progress_regex(R"(whisper_print_progress_callback:\s*progress\s*=\s*(\d{1,3})%)");

    while (process.state() == QProcess::Running && !m_stopFlag.load()) {
        if (process.waitForReadyRead(300)) {
            QByteArray output = process.readAllStandardOutput();
            QString outputString = QString::fromUtf8(output);

            qInfo() << outputString;

            QStringList lines = outputString.split(QRegularExpression("[\r\n]+"), Qt::SkipEmptyParts);
            for (const QString &line : lines) {
                std::string stdLine = line.toStdString();
                std::smatch match;

                if (std::regex_search(stdLine, match, timestamp_regex)) {
                    QString text = QString::fromStdString(match[1]);
                    collectedText += text;
                    emit textUpdated(collectedText);
                } else if (std::regex_search(stdLine, match, progress_regex)) {
                    int progress = std::stoi(match[1]);
                    emit progressUpdated(progress);
                }
            }
        }
    }

    if (process.state() != QProcess::NotRunning) {
        process.terminate();
        if (!process.waitForFinished(1000)) {
            process.kill();
            process.waitForFinished();
        }
    }

    emit finished();
}
