#include "offlineprovider.h"

#include <QCoreApplication>

OfflineProvider::OfflineProvider(QObject* parent)
    : Provider(parent), _stopFlag(false)
{}

OfflineProvider::OfflineProvider(QObject *parent, const QString &model, const QString &key)
    : Provider(parent), _stopFlag(false), m_model(key)
{
    qCDebug(logOfflineProvider) << "OfflineProvider created with model:" << model << "key:" << key;
}

OfflineProvider::~OfflineProvider() {
    _stopFlag = true;
    if (m_process) {
        m_process->kill();
        m_process->deleteLater();
    }
    qCInfo(logOfflineProvider) << "delete Offline provider";
}

void OfflineProvider::stop() {
    _stopFlag = true;
}

void OfflineProvider::loadModel(const QString &model, const QString &key) {
    qCInfo(logOfflineProvider) << "Loading model with key:" << key;

    OfflineWorker *worker = new OfflineWorker;
    QThread *thread = new QThread;
    worker->moveToThread(thread);

    connect(thread, &QThread::started, worker, [worker, model, key]() {
        worker->doLoadModel(model, key);
    });
    connect(this, &OfflineProvider::sendPromptToProcess, worker, &OfflineWorker::sendPromptToProcess);
    connect(worker, &OfflineWorker::requestTokenResponse, this, &OfflineProvider::requestTokenResponse);
    connect(worker, &OfflineWorker::requestFinishedResponse, this, &OfflineProvider::requestFinishedResponse);

    connect(this, &OfflineProvider::destroyed, worker, &OfflineWorker::deleteLater);
    connect(thread, &QThread::finished, thread, &QThread::deleteLater);

    thread->start();
}

// void OfflineProvider::unLoadModel() {
//     _stopFlag = true;
//     if (m_process) {
//         m_process->kill();
//         m_process->deleteLater();
//     }
// }

void OfflineProvider::prompt(const QString &input, const bool &stream, const QString &promptTemplate,
                             const QString &systemPrompt, const double &temperature, const int &topK, const double &topP,
                             const double &minP, const double &repeatPenalty, const int &promptBatchSize, const int &maxTokens,
                             const int &repeatPenaltyTokens, const int &contextLength, const int &numberOfGPULayers)
{
    emit sendPrompt(input, stream, promptTemplate, systemPrompt, temperature, topK, topP,
                    minP, repeatPenalty, promptBatchSize, maxTokens, repeatPenaltyTokens,
                    contextLength, numberOfGPULayers);
}
