#ifndef OFFLINEPROVIDER_H
#define OFFLINEPROVIDER_H

#include "provider.h"
#include <QThread>
#include <QDebug>
#include <QProcess>

class OfflineProvider : public Provider
{
    Q_OBJECT
public:
    OfflineProvider(QObject* parent = nullptr);
    virtual ~OfflineProvider();

    enum class ProviderState {
        LoadingModel,
        WaitingForPrompt,
        SendingPrompt,
        ReadingResponse,
        Finished
    };

    struct PromptRequest {
        QString input;
        bool stream;
        QString promptTemplate;
        QString systemPrompt;
        double temperature;
        int topK;
        double topP;
        double minP;
        double repeatPenalty;
        int promptBatchSize;
        int maxTokens;
        int repeatPenaltyTokens;
        int contextLength;
        int numberOfGPULayers;
    };

public slots:
    void prompt(const QString &input, const bool &stream, const QString &promptTemplate,
                const QString &systemPrompt, const double &temperature, const int &topK, const double &topP,
                const double &minP, const double &repeatPenalty, const int &promptBatchSize, const int &maxTokens,
                const int &repeatPenaltyTokens, const int &contextLength, const int &numberOfGPULayers) override;

    void stop() override;
    void loadModel(const QString &model, const QString &key) override;
    void unLoadModel() override;

signals:
    void sendPromptToProcess(const QString &promptText);

private:
    QThread chatLLMThread;
    std::atomic<bool> _stopFlag;

    std::string answer = "";
    QString m_model;

    QProcess* m_process = nullptr;
    ProviderState state = ProviderState::LoadingModel;

    PromptRequest m_pendingPrompt;
    bool m_hasPendingPrompt = false;
};

#endif // OFFLINEPROVIDER_H
