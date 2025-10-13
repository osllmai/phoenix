#include "offlineworker.h"
#include <QThread>

OfflineWorker::OfflineWorker(std::atomic<bool> *stopFlag, QObject *parent)
    : QObject(parent), m_stopFlag(stopFlag)
{}

void OfflineWorker::runLoadModel(const QString &model, const QString &key){
    QProcess process;
    m_process = new QProcess;
    m_process->setProcessChannelMode(QProcess::MergedChannels);
    m_process->setReadChannel(QProcess::StandardOutput);

    QString exePath = QCoreApplication::applicationDirPath() + "/applocal_provider.exe";
    QStringList arguments{ "--model", key };

    state = Provider::ProviderState::LoadingModel;
    qCInfo(logOfflineProvider) << "Starting process at:" << exePath << "with arguments:" << arguments;

    connect(this, &OfflineWorker::sendPromptToProcess, this, [this](const QString &promptText, const QString &paramBlock) {

        qCInfo(logOfflineProvider) << "Sending prompt to process. State:" << static_cast<int>(state);
        if (state == Provider::ProviderState::WaitingForPrompt || state == Provider::ProviderState::SendingPrompt) {
            m_process->write(paramBlock.toUtf8());
            m_process->waitForBytesWritten();

            m_process->write("__PROMPT__\n");
            m_process->waitForBytesWritten();

            m_process->write((promptText.trimmed() + "\n__END__\n").toUtf8());
            m_process->waitForBytesWritten();

            state = Provider::ProviderState::ReadingResponse;
        } else {
            qCWarning(logOfflineProvider) << "Cannot send prompt. Invalid state:" << static_cast<int>(state);
        }
    });

    m_process->start(exePath, arguments);
    if (!m_process->waitForStarted()) {
        qCCritical(logOfflineProvider) << "Failed to start process:" << m_process->errorString();
        emit finished();
        return;
    }

    qCInfo(logOfflineProvider) << "Process started successfully.";

    while (m_process->state() == QProcess::Running) {
        if (m_process->waitForReadyRead(400)) {
            QByteArray output = m_process->readAllStandardOutput();
            QString outputString = QString::fromUtf8(output);

            if (outputString.trimmed().endsWith("__DONE_PROMPTPROCESS__")) {
                QString cleanedOutput = outputString.trimmed();
                QString beforeDone = cleanedOutput.left(cleanedOutput.lastIndexOf("__DONE_PROMPTPROCESS__"));
                emit tokenReady(beforeDone);

                state = Provider::ProviderState::SendingPrompt;
                emit finished();

                qCInfo(logOfflineProvider) << "Prompt processing done.";
            }

            switch (state) {
            case Provider::ProviderState::LoadingModel: {
                if (outputString.trimmed().endsWith("__LoadingModel__Finished__")) {
                    qCInfo(logOfflineProvider) << "Model loaded successfully.";
                    state = Provider::ProviderState::WaitingForPrompt;

                    if (m_hasPendingPrompt) {
                        qCInfo(logOfflineProvider) << "Sending pending prompt...";
                        QString paramBlock =
                            "__PARAMS_SETTINGS__\n" +
                            QString("stream=%1\n").arg(m_pendingPrompt.stream ? "true" : "false") +
                            QString("prompt_template=%1\n").arg(m_pendingPrompt.promptTemplate) +
                            QString("system_prompt=%1\n").arg(m_pendingPrompt.systemPrompt) +
                            QString("n_predict=%1\n").arg(m_pendingPrompt.maxTokens) +
                            QString("top_k=%1\n").arg(m_pendingPrompt.topK) +
                            QString("top_p=%1\n").arg(m_pendingPrompt.topP) +
                            QString("min_p=%1\n").arg(m_pendingPrompt.minP) +
                            QString("temp=%1\n").arg(m_pendingPrompt.temperature) +
                            QString("n_batch=%1\n").arg(m_pendingPrompt.promptBatchSize) +
                            QString("repeat_penalty=%1\n").arg(m_pendingPrompt.repeatPenalty) +
                            QString("repeat_last_n=%1\n").arg(m_pendingPrompt.repeatPenaltyTokens) +
                            QString("ctx_size=%1\n").arg(m_pendingPrompt.contextLength) +
                            QString("n_gpu_layers=%1\n").arg(m_pendingPrompt.numberOfGPULayers) +
                            "__END_PARAMS_SETTINGS__\n";

                        emit sendPromptToProcess(m_pendingPrompt.input, paramBlock);
                        m_hasPendingPrompt = false;
                    }
                }
                break;
            }

            case Provider::ProviderState::SendingPrompt:
                qCInfo(logOfflineProvider) << "Prompt sent. Returning to WaitingForPrompt.";
                state = Provider::ProviderState::WaitingForPrompt;
                break;

            case Provider::ProviderState::ReadingResponse:
                if (m_stopFlag) {
                    m_process->write("__STOP__\n");
                    m_process->waitForBytesWritten();
                    qCInfo(logOfflineProvider) << "Stop flag detected. Sent __STOP__.";
                    state = Provider::ProviderState::SendingPrompt;
                }

                emit tokenReady(outputString);
                break;

            default:
                qCWarning(logOfflineProvider) << "Unhandled state:" << static_cast<int>(state);
                break;
            }
        }
    }

    m_process->waitForFinished(50);
    emit finished();
}
void OfflineWorker::prompt(const QString &input, const bool &stream, const QString &promptTemplate,
            const QString &systemPrompt, const double &temperature, const int &topK,
            const double &topP, const double &minP, const double &repeatPenalty,
            const int &promptBatchSize, const int &maxTokens,
            const int &repeatPenaltyTokens, const int &contextLength,
            const int &numberOfGPULayers)
{
    qCInfo(logOfflineProvider) << "Prompt called with input:" << input.left(30) << "...";

    Provider::PromptRequest request = {
        input, stream, promptTemplate, systemPrompt, temperature, topK,
        topP, minP, repeatPenalty, promptBatchSize, maxTokens,
        repeatPenaltyTokens, contextLength, numberOfGPULayers
    };

    QString paramBlock =
        "__PARAMS_SETTINGS__\n" +
        QString("stream=%1\n").arg(request.stream ? "true" : "false") +
        QString("prompt_template=%1\n").arg(request.promptTemplate) +
        QString("system_prompt=%1\n").arg(request.systemPrompt) +
        QString("n_predict=%1\n").arg(request.maxTokens) +
        QString("top_k=%1\n").arg(request.topK) +
        QString("top_p=%1\n").arg(request.topP) +
        QString("min_p=%1\n").arg(request.minP) +
        QString("temp=%1\n").arg(request.temperature) +
        QString("n_batch=%1\n").arg(request.promptBatchSize) +
        QString("repeat_penalty=%1\n").arg(request.repeatPenalty) +
        QString("repeat_last_n=%1\n").arg(request.repeatPenaltyTokens) +
        QString("ctx_size=%1\n").arg(request.contextLength) +
        QString("n_gpu_layers=%1\n").arg(request.numberOfGPULayers) +
        "__END_PARAMS_SETTINGS__\n";

    if (state == Provider::ProviderState::WaitingForPrompt) {
        qCInfo(logOfflineProvider) << "Sending prompt immediately.";
        emit sendPromptToProcess(request.input, paramBlock);
    } else {
        qCInfo(logOfflineProvider) << "System busy. Queuing prompt.";
        m_pendingPrompt = request;
        m_hasPendingPrompt = true;
    }
}

