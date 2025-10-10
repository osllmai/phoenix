#ifndef OFFLINEPROVIDER_H
#define OFFLINEPROVIDER_H

#include "worker/offlineworker.h"
#include <QThread>
#include <QDebug>
#include <QProcess>

#include <QLoggingCategory>
#include "logcategories.h"

class OfflineProvider : public Provider
{
    Q_OBJECT
public:
    OfflineProvider(QObject* parent = nullptr);
    OfflineProvider(QObject *parent, const QString &model, const QString &key);
    virtual ~OfflineProvider();

public slots:
    void prompt(const QString &input, const bool &stream, const QString &promptTemplate,
                const QString &systemPrompt, const double &temperature, const int &topK, const double &topP,
                const double &minP, const double &repeatPenalty, const int &promptBatchSize, const int &maxTokens,
                const int &repeatPenaltyTokens, const int &contextLength, const int &numberOfGPULayers) override;

    void stop() override;
    void loadModel(const QString &model, const QString &key) override;
    // void unLoadModel() override;

signals:
    void sendPromptToProcess(const QString &promptText, const QString &paramBlock);

private:
    QThread chatLLMThread;
    std::atomic<bool> _stopFlag;

    QString m_model;

    QProcess* m_process = nullptr;
    ProviderState state = ProviderState::LoadingModel;

    PromptRequest m_pendingPrompt;
    bool m_hasPendingPrompt = false;
};

#endif // OFFLINEPROVIDER_H
