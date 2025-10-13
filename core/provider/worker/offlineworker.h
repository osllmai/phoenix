#ifndef OFFLINEWORKER_H
#define OFFLINEWORKER_H

#include <QObject>
#include <QProcess>
#include <QCoreApplication>
#include <QLoggingCategory>
#include "logcategories.h"
#include "provider.h"

class OfflineWorker : public QObject
{
    Q_OBJECT
public:
    explicit OfflineWorker(std::atomic<bool> *stopFlag,
                           QObject *parent = nullptr);

public slots:
    void runLoadModel(const QString &model, const QString &key);
    void prompt(const QString &input, const bool &stream, const QString &promptTemplate,
                const QString &systemPrompt, const double &temperature, const int &topK,
                const double &topP, const double &minP, const double &repeatPenalty,
                const int &promptBatchSize, const int &maxTokens,
                const int &repeatPenaltyTokens, const int &contextLength,
                const int &numberOfGPULayers);

signals:
    void sendPromptToProcess(const QString &promptText, const QString &paramBlock);
    void tokenReady(const QString &text);
    void finished();

private:
    std::atomic<bool> *m_stopFlag;
    QProcess* m_process = nullptr;
    Provider::ProviderState state = Provider::ProviderState::LoadingModel;

    Provider::PromptRequest m_pendingPrompt;
    bool m_hasPendingPrompt = false;
};

#endif // OFFLINEWORKER_H
