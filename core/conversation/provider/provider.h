#ifndef PROVIDER_H
#define PROVIDER_H

#pragma once

#include <QObject>

class Provider: public QObject
{
    Q_OBJECT
public:
    Provider();
    explicit Provider(QObject *parent = nullptr);

    explicit Provider(QObject *parent, const QString &model, const QString &key);

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
    virtual void prompt(const QString &input, const bool &stream, const QString &promptTemplate,
                        const QString &systemPrompt, const double &temperature, const int &topK, const double &topP,
                        const double &minP, const double &repeatPenalty, const int &promptBatchSize, const int &maxTokens,
                        const int &repeatPenaltyTokens, const int &contextLength, const int &numberOfGPULayers);
    virtual void stop();
    virtual void loadModel(const QString &model, const QString &key);
    virtual void unLoadModel();

signals:
    void requestLoadModelResult(const bool result, const QString &warning);
    void requestTokenResponse(const QString &token);
    void requestFinishedResponse(const QString &warning);
};

#endif // PROVIDER_H
