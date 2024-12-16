#pragma once

#include "workflowstep.h"

#include <QNetworkAccessManager>

class OpenAIStep : public WorkFlowStep
{
    Q_OBJECT
public:
    explicit OpenAIStep(WorkFlowRunner *parent);

public:
    void init() override;
    void run() override;

protected:
    bool checkReady() const override;

private Q_SLOTS:
    void reply_readyRead();
    void reply_finished();

private:
    QNetworkAccessManager networkManager;
    WorkFlowStepField *_apiKey;
    WorkFlowStepField *_outputField;
    QString _buffer;
    QNetworkReply *_reply;
};
