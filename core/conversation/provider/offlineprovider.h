#ifndef OFFLINEPROVIDER_H
#define OFFLINEPROVIDER_H

#include "provider.h"
#include <QThread>
#include <QDebug>

class OfflineProvider : public  Provider
{
    Q_OBJECT
public:
    OfflineProvider(QObject* parent = nullptr);
    virtual ~OfflineProvider();

public slots:
    void prompt(const QString &input, const bool &stream, const QString &promptTemplate,
                const QString &systemPrompt, const double &temperature, const int &topK, const double &topP,
                const double &minP, const double &repeatPenalty, const int &promptBatchSize, const int &maxTokens,
                const int &repeatPenaltyTokens, const int &contextLength, const int &numberOfGPULayers) override;
    void stop() override;
    void loadModel(const QString &model, const QString &key) override;
    void unLoadModel() override;

private:
    QThread chatLLMThread;
    std::atomic<bool> _stopFlag;

    std::string answer = "";
    QString m_model;

    bool handleResponse(int32_t token, const std::string &response);
};

#endif // OFFLINEPROVIDER_H
