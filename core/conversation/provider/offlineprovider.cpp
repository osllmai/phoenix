#include "offlineprovider.h"

OfflineProvider::OfflineProvider(QObject* parent)
    :Provider(parent), _stopFlag(false)
{}

OfflineProvider::OfflineProvider(QObject *parent, const QString &model, const QString &key)
    :Provider(parent), _stopFlag(false), m_model(key)
{}

OfflineProvider::~OfflineProvider(){
    if (m_process) {
        m_process->kill();
        m_process->deleteLater();
    }
}

void OfflineProvider::stop(){
    _stopFlag = true;
}

void OfflineProvider::loadModel(const QString &model, const QString &key) {
    QThread::create([this, key]() {
        m_process = new QProcess;
        m_process->setProcessChannelMode(QProcess::MergedChannels);
        m_process->setReadChannel(QProcess::StandardOutput);

        QString exePath = "applocal_provider.exe";
        QStringList arguments;
        arguments << "--model" << key;

        state = ProviderState::LoadingModel;

        connect(this, &OfflineProvider::sendPromptToProcess, this, [this](const QString &promptText){
            if (state == ProviderState::WaitingForPrompt || state == ProviderState::SendingPrompt) {
                QString paramBlock =
                    "__PARAMS__\n"
                    "n_predict=200\n"
                    "top_k=40\n"
                    "top_p=0.9\n"
                    "min_p=0.0\n"
                    "temp=0.6\n"
                    "n_batch=9\n"
                    "repeat_penalty=1.10\n"
                    "repeat_last_n=64\n"
                    "__END_PARAMS__\n";

                m_process->write(paramBlock.toUtf8());
                m_process->waitForBytesWritten();

                QString text = "__PROMPT__\n";
                m_process->write(text.toUtf8());
                m_process->waitForBytesWritten();

                QString formattedPrompt = promptText.trimmed() + "\n__END__\n";
                m_process->write(formattedPrompt.toUtf8());
                m_process->waitForBytesWritten();

                state = ProviderState::ReadingResponse;
                qInfo()<< "send prompt finished";
            } else {
                qWarning() << "Not ready for prompt. Current state:" << static_cast<int>(state);
            }
        });

        m_process->start(exePath, arguments);

        if (!m_process->waitForStarted()) {
            qCritical() << "Failed to start process: " << m_process->errorString();
            emit requestFinishedResponse("Failed to start process");
            return;
        }

        QString fullResponse;
        while (m_process->state() == QProcess::Running) {

            if (m_process->waitForReadyRead(50)){

                QByteArray output = m_process->readAllStandardOutput();
                QString outputString = QString::fromUtf8(output);
                qInfo()<<outputString;

                if(outputString.trimmed().endsWith("__DONE_PROMPTPROCESS__")){
                    state = ProviderState::SendingPrompt;
                    emit requestFinishedResponse("");
                }

                if (!outputString.trimmed().isEmpty()){
                    switch (state) {
                        case ProviderState::LoadingModel:{
                            if(outputString.trimmed().endsWith("__LoadingModel__Finished__")){
                                state = ProviderState::WaitingForPrompt;
                                if (m_hasPendingPrompt) {
                                    emit sendPromptToProcess(m_pendingPrompt.input);
                                    m_hasPendingPrompt = false;
                                    qInfo() << "Sent pending prompt after model load.";
                                }
                            }
                            break;
                        }

                        case ProviderState::SendingPrompt: {
                            state = ProviderState::WaitingForPrompt;
                            break;
                        }

                        case ProviderState::ReadingResponse: {
                            QString text = "__STOP__\n";
                            if (_stopFlag) {
                                state = ProviderState::SendingPrompt;
                                qInfo()<<"_stopFlag";
                                qInfo()<<outputString.trimmed();
                                m_process->write(text.toUtf8());
                                m_process->waitForBytesWritten();
                                _stopFlag = false;
                            }

                            if (!outputString.isEmpty()) {
                                emit requestTokenResponse(outputString);
                            }
                            break;
                        }

                        default:
                            break;
                    }
                }
            }
        }

        m_process->waitForFinished(50);
        _stopFlag = false;

        qInfo() << "Process finished.";
        m_process->deleteLater();
        emit requestFinishedResponse(fullResponse);
    })->start();
}

void OfflineProvider::unLoadModel(){
        // delete model;
        // model = nullptr;
}

void OfflineProvider::prompt(const QString &input, const bool &stream, const QString &promptTemplate,
                             const QString &systemPrompt, const double &temperature, const int &topK, const double &topP,
                             const double &minP, const double &repeatPenalty, const int &promptBatchSize, const int &maxTokens,
                             const int &repeatPenaltyTokens, const int &contextLength, const int &numberOfGPULayers){

    PromptRequest request = {
        input, stream, promptTemplate, systemPrompt, temperature, topK,
        topP, minP, repeatPenalty, promptBatchSize, maxTokens,
        repeatPenaltyTokens, contextLength, numberOfGPULayers
    };

    if (state == ProviderState::WaitingForPrompt) {
        emit sendPromptToProcess(request.input);
    } else {
        m_pendingPrompt = request;
        m_hasPendingPrompt = true;
        qInfo() << "Prompt saved to be sent later";
    }
}
