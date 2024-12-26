#ifndef CHATLLM_H
#define CHATLLM_H

#include "abstractchatprovider.h"
#include <QThread>
#include <QDebug>

class Chat;
class ChatLLM : public AbstractChatProvider
{
    Q_OBJECT

public:
    ChatLLM(Chat *parent);
    virtual ~ChatLLM();
    void stop() override;

signals:
    void loadModelResult(const bool result);
    void tokenResponse(const QString &token);
    void finishedResponnse();

public slots:
    void loadModel(const QString &modelPath) override;
    void unloadModel() override;
    void prompt(const QString &input);

private:
    QThread chatLLMThread;
    std::atomic<bool> _stopFlag;

    bool handleResponse(int32_t token, const std::string &response);
};

#endif // CHATLLM_H
