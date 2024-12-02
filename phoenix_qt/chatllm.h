#ifndef CHATLLM_H
#define CHATLLM_H

#include <QObject>
#include <QThread>
#include <QDebug>

class Chat;
class ChatLLM : public QObject
{
    Q_OBJECT
public:
    ChatLLM(Chat *parent);
    virtual ~ChatLLM();
    void setStop();

signals:
    void loadModelResult(const bool result);
    void tokenResponse(const QString &token);
    void finishedResponnse();

public slots:
    void loadModel(const QString &modelPath);
    void unLoadModel();
    void prompt(const QString &input);

private:
    QThread chatLLMThread;
    std::atomic<bool> stop;

    // bool handleResponse(int32_t token, const std::string &response);
};

#endif // CHATLLM_H
