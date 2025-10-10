#ifndef ONLINEPROVIDER_H
#define ONLINEPROVIDER_H

#include "worker/onlineworker.h"
#include "provider.h"
#include <QThread>
#include <QProcess>
#include <atomic>

class OnlineProvider : public Provider {
    Q_OBJECT
public:
    OnlineProvider(QObject *parent = nullptr);
    OnlineProvider(QObject *parent, const QString &model, const QString &key);
    ~OnlineProvider();

public slots:
    void prompt(const QString &input, const bool &stream, const QString &promptTemplate,
                const QString &systemPrompt, const double &temperature, const int &topK,
                const double &topP, const double &minP, const double &repeatPenalty,
                const int &promptBatchSize, const int &maxTokens,
                const int &repeatPenaltyTokens, const int &contextLength,
                const int &numberOfGPULayers) override;
    void stop() override;
    void loadModel(const QString &model, const QString &key) override;

private:
    QThread *m_thread = nullptr;
    std::atomic<bool> m_stopFlag;
    QString m_model;
    QString m_key;
};

#endif // ONLINEPROVIDER_H
