#include "offlineprovider.h"

OfflineProvider::OfflineProvider(QObject* parent)
    : Provider(parent), _stopFlag(false)
{}

OfflineProvider::OfflineProvider(QObject *parent, const QString &model, const QString &key)
    : Provider(parent), _stopFlag(false), m_model(key)
{
    qCDebug(logOfflineProvider) << "OfflineProvider created with model:" << model << "key:" << key;
}

OfflineProvider::~OfflineProvider()
{
    stop();
    chatLLMThread.quit();
    chatLLMThread.wait();
    qCInfo(logOfflineProvider) << "OfflineProvider destroyed.";
}

void OfflineProvider::stop()
{
    _stopFlag = true;
    emit requestFinishedResponse("Stop requested.");
}

void OfflineProvider::loadModel(const QString &model, const QString &key)
{
    qCInfo(logOfflineProvider) << "Loading model with key:" << key;

    OfflineWorker *worker = new OfflineWorker(key);
    worker->moveToThread(&chatLLMThread);

    connect(&chatLLMThread, &QThread::finished, worker, &QObject::deleteLater);

    connect(worker, &OfflineWorker::tokenResponse, this, &OfflineProvider::requestTokenResponse);
    connect(worker, &OfflineWorker::finishedResponse, this, &OfflineProvider::requestFinishedResponse);
    connect(worker, &OfflineWorker::modelLoaded, this, [this]() {
        state = ProviderState::WaitingForPrompt;
        qCInfo(logOfflineProvider) << "Model loaded (signal received).";
    });
    connect(worker, &OfflineWorker::errorOccurred, this, [this](const QString &msg) {
        emit requestFinishedResponse("Error: " + msg);
    });

    connect(this, &OfflineProvider::sendPromptToProcess, worker, &OfflineWorker::handlePrompt);
    connect(this, &OfflineProvider::destroyed, worker, &OfflineWorker::stopModel);

    chatLLMThread.start();

    QMetaObject::invokeMethod(worker, "startModel", Qt::QueuedConnection);
}

void OfflineProvider::prompt(const QString &input, const bool &stream, const QString &promptTemplate,
                             const QString &systemPrompt, const double &temperature, const int &topK, const double &topP,
                             const double &minP, const double &repeatPenalty, const int &promptBatchSize, const int &maxTokens,
                             const int &repeatPenaltyTokens, const int &contextLength, const int &numberOfGPULayers)
{
    qCInfo(logOfflineProvider) << "Prompt called with input:" << input.left(30) << "...";

    PromptRequest request = {
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

    emit sendPromptToProcess(request.input, paramBlock);
}
