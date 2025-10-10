#include "offlineworker.h"
#include <QCoreApplication>

OfflineWorker::OfflineWorker(const QString &modelKey, QObject *parent)
    : QObject(parent), m_modelKey(modelKey)
{
}

OfflineWorker::~OfflineWorker()
{
    stopModel();
    if (m_process) {
        m_process->deleteLater();
        m_process = nullptr;
    }
}

void OfflineWorker::startModel()
{
    if (m_process) {
        qCWarning(logOfflineProvider) << "Process already running.";
        return;
    }

    QString exePath = QCoreApplication::applicationDirPath() + "/applocal_provider.exe";
    QStringList arguments{ "--model", m_modelKey };

    m_process = new QProcess(this);
    m_process->setProcessChannelMode(QProcess::MergedChannels);
    m_process->setReadChannel(QProcess::StandardOutput);

    connect(m_process, &QProcess::readyReadStandardOutput, this, [this]() {
        QByteArray output = m_process->readAllStandardOutput();
        QString outputString = QString::fromUtf8(output);

        if (outputString.contains("__LoadingModel__Finished__")) {
            state = ProviderState::WaitingForPrompt;
            qCInfo(logOfflineProvider) << "Model loaded successfully";
            emit modelLoaded();
        }
        else if (outputString.contains("__DONE_PROMPTPROCESS__")) {
            QString cleaned = outputString;
            cleaned.remove("__DONE_PROMPTPROCESS__");
            emit tokenResponse(cleaned);
            emit finishedResponse("");
            state = ProviderState::WaitingForPrompt;
        }
        else {
            emit tokenResponse(outputString);
        }
    });

    connect(m_process, &QProcess::errorOccurred, this, [this](QProcess::ProcessError e) {
        qCCritical(logOfflineProvider) << "Process error:" << e;
        emit errorOccurred(m_process->errorString());
    });

    m_process->start(exePath, arguments);

    if (!m_process->waitForStarted()) {
        qCCritical(logOfflineProvider) << "Failed to start process:" << m_process->errorString();
        emit errorOccurred("Failed to start process");
        return;
    }

    qCInfo(logOfflineProvider) << "Process started successfully.";
}

void OfflineWorker::handlePrompt(const QString &promptText, const QString &paramBlock)
{
    if (!m_process || state != ProviderState::WaitingForPrompt) {
        qCWarning(logOfflineProvider) << "Process not ready to handle prompt.";
        return;
    }

    m_process->write(paramBlock.toUtf8());
    m_process->waitForBytesWritten();

    m_process->write("__PROMPT__\n");
    m_process->waitForBytesWritten();

    m_process->write((promptText.trimmed() + "\n__END__\n").toUtf8());
    m_process->waitForBytesWritten();

    state = ProviderState::ReadingResponse;
}

void OfflineWorker::stopModel()
{
    _stopFlag = true;
    if (m_process && m_process->state() == QProcess::Running) {
        m_process->write("__STOP__\n");
        m_process->waitForBytesWritten();
        m_process->kill();
        m_process->waitForFinished(500);
        qCInfo(logOfflineProvider) << "Worker stopped process.";
    }
    _stopFlag = false;
}
