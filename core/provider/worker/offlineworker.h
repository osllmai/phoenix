#ifndef OFFLINEWORKER_H
#define OFFLINEWORKER_H

#include <QObject>
#include <QProcess>
#include <QDebug>
#include <QLoggingCategory>
#include "logcategories.h"
#include "./Provider.h"

class OfflineWorker : public QObject
{
    Q_OBJECT
public:
    explicit OfflineWorker(const QString &modelKey, QObject *parent = nullptr);
    ~OfflineWorker();

    enum class ProviderState {
        LoadingModel,
        WaitingForPrompt,
        SendingPrompt,
        ReadingResponse,
        Finished
    };

public slots:
    void startModel();
    void stopModel();
    void handlePrompt(const QString &promptText, const QString &paramBlock);

signals:
    void tokenResponse(const QString &text);
    void finishedResponse(const QString &text);
    void modelLoaded();
    void errorOccurred(const QString &msg);

private:
    QProcess *m_process = nullptr;
    QString m_modelKey;
    std::atomic<bool> _stopFlag{false};
    ProviderState state = ProviderState::LoadingModel;
};

#endif // OFFLINEWORKER_H
