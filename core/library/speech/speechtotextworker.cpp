#include "SpeechToTextWorker.h"
#include <QCoreApplication>
#include <QRegularExpression>
#include <QDebug>
#include <regex>

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

    QString exePath = m_cuda
                          ? QCoreApplication::applicationDirPath() + "/whisper/cuda-device/whisper-cli.exe"
                          : QCoreApplication::applicationDirPath() + "/whisper/cpu-device/whisper-cli.exe";

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
