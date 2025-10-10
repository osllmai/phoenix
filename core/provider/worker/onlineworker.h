#ifndef ONLINEWORKER_H
#define ONLINEWORKER_H

#include "provider.h"
#include <QThread>
#include <QProcess>
#include "apikey.h"

class OnlineWorker : public QObject {
    Q_OBJECT
public:
    OnlineWorker(const QString &model, const QString &key, const QString &input,
                 bool stream, const QString &promptTemplate, const QString &systemPrompt,
                 double temperature, int topK, double topP, double minP,
                 double repeatPenalty, int promptBatchSize, int maxTokens,
                 int repeatPenaltyTokens, int contextLength, int numberOfGPULayers,
                 std::atomic<bool> *stopFlag, QObject *parent = nullptr);

public slots:
    void run();

signals:
    void tokenReady(const QString &text);
    void finished();

private:
    QString m_model, m_key, m_input, m_promptTemplate, m_systemPrompt;
    bool m_stream;
    double m_temperature, m_topP, m_minP, m_repeatPenalty;
    int m_topK, m_promptBatchSize, m_maxTokens, m_repeatPenaltyTokens, m_contextLength, m_numberOfGPULayers;
    std::atomic<bool> *m_stopFlag;
};


#endif // ONLINEWORKER_H
