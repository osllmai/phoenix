#include "onlineprovider.h"

#include <QDebug>
#include <cassert>
#include <string>
#include <cstring>
#include <cstdio>
#include <cassert>
#include <string>
#include <vector>
#include <cstring>
#include <iostream>
#include <cstring>

#include <QProcess>
#include <QDebug>
#include <QThread>

// #include "../phoenix/llmodel.h"

// std::string answer = "";
// LLModel::PromptContext prompt_context;
// LLModel* model;
// std::string prompt_template;

OnlineProvider::OnlineProvider(QObject* parent)
    :Provider(parent), _stopFlag(false)
{
    moveToThread(&chatLLMThread);
    chatLLMThread.start();
}

OnlineProvider::~OnlineProvider(){
    chatLLMThread.quit();
    chatLLMThread.wait();
}

void OnlineProvider::stop(){
    _stopFlag = true;
}

void OnlineProvider::loadModel(const QString &model, const QString &key){
    m_model = model;
    m_key = key;
}

void OnlineProvider::unLoadModel(){

}

void OnlineProvider::prompt(const QString &input, const bool &stream, const QString &promptTemplate,
                            const QString &systemPrompt, const double &temperature, const int &topK, const double &topP,
                            const double &minP, const double &repeatPenalty, const int &promptBatchSize, const int &maxTokens,
                            const int &repeatPenaltyTokens, const int &contextLength, const int &numberOfGPULayers){

    QThread::create([this, input, stream, promptTemplate, systemPrompt, temperature, topK, topP, minP,
                     repeatPenalty, promptBatchSize, maxTokens, repeatPenaltyTokens, contextLength, numberOfGPULayers]() {
        QProcess process;
        process.setProcessChannelMode(QProcess::MergedChannels);

        QStringList arguments;
        arguments << "bin/main_provider.py"
                  << m_model
                  << m_key
                  << input
                  << (stream ? "1" : "0")
                  << promptTemplate
                  << systemPrompt
                  << QString::number(temperature, 'f', 6)
                  << QString::number(topK)
                  << QString::number(topP, 'f', 6)
                  << QString::number(minP, 'f', 6)
                  << QString::number(repeatPenalty, 'f', 6)
                  << QString::number(promptBatchSize)
                  << QString::number(maxTokens)
                  << QString::number(repeatPenaltyTokens)
                  << QString::number(contextLength)
                  << QString::number(numberOfGPULayers);

        process.start("python", arguments);

        QString response = "";
        int numberOfResponse = 0;
        while (process.state() == QProcess::Running) {
            if (process.waitForReadyRead(100)) {
                QByteArray output = process.readAllStandardOutput();
                QString outputString = QString::fromUtf8(output);
                response = response + outputString;
                numberOfResponse++;
                qDebug() << outputString<<"        "<<numberOfResponse;
                if (!response.isEmpty() && numberOfResponse > 20000) {
                    qDebug() << response<<"        "<<numberOfResponse;
                    emit requestTokenResponse(response);
                    response = "";
                    numberOfResponse = 0;
                }
            }
        }
        qInfo()<<"FInish";
        if (numberOfResponse != 0) {
            qDebug() << response<<"        "<<numberOfResponse;
            emit requestTokenResponse(response);
            response = "";
            numberOfResponse = 0;
        }
        emit requestFinishedResponse("");
    })->start();
}


bool OnlineProvider::handleResponse(int32_t token, const std::string &response){
    return true;
}

