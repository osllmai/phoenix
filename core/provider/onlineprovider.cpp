#include "onlineprovider.h"

OnlineProvider::OnlineProvider(QObject *parent)
    : Provider(parent), m_stopFlag(false)
{}

OnlineProvider::OnlineProvider(QObject *parent, const QString &model, const QString &key)
    : Provider(parent), m_model(model), m_key(key), m_stopFlag(false)
{}

OnlineProvider::~OnlineProvider() {
    stop();
    if (m_thread) {
        m_thread->quit();
        m_thread->wait();
        delete m_thread;
    }
}

void OnlineProvider::stop() {
    m_stopFlag.store(true);
}

void OnlineProvider::loadModel(const QString &model, const QString &key) {
    m_model = model;
    m_key = key;
}

void OnlineProvider::prompt(const QString &input, const bool &stream, const QString &promptTemplate,
                            const QString &systemPrompt, const double &temperature, const int &topK,
                            const double &topP, const double &minP, const double &repeatPenalty,
                            const int &promptBatchSize, const int &maxTokens,
                            const int &repeatPenaltyTokens, const int &contextLength,
                            const int &numberOfGPULayers) {

    stop();
    m_stopFlag.store(false);

    if (m_thread) {
        if (m_thread->isRunning()) {
            m_thread->quit();
            m_thread->wait();
        }
        delete m_thread;
        m_thread = nullptr;
    }

    m_thread = new QThread;
    auto *worker = new OnlineWorker(m_model, m_key, input, stream, promptTemplate, systemPrompt,
                                    temperature, topK, topP, minP, repeatPenalty,
                                    promptBatchSize, maxTokens, repeatPenaltyTokens,
                                    contextLength, numberOfGPULayers, &m_stopFlag);

    worker->moveToThread(m_thread);

    connect(m_thread, &QThread::started, worker, &OnlineWorker::run);
    connect(worker, &OnlineWorker::tokenReady, this, &OnlineProvider::requestTokenResponse);

    connect(worker, &OnlineWorker::finished, this, [this, worker]() {
        emit requestFinishedResponse("");
        worker->deleteLater();

        if (m_thread) {
            m_thread->quit();
            m_thread->wait();
            m_thread->deleteLater();
            m_thread = nullptr;
        }
    });

    m_thread->start();
}
