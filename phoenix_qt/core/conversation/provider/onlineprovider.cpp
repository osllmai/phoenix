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

std::string answer = "";
// LLModel::PromptContext prompt_context;
// LLModel* model;
std::string prompt_template;

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

void OnlineProvider::prompt(const QString &input){
    QThread::create([this, input]() {
        QProcess process;
        process.setProcessChannelMode(QProcess::MergedChannels);

        process.start("python", QStringList() << "bin/provider.py" << "mistral-tiny" << "" << input);

        while (process.state() == QProcess::Running) {
            if (process.waitForReadyRead(100)) {
                QByteArray output = process.readAllStandardOutput();
                QString outputString = QString::fromUtf8(output);
                if (!outputString.isEmpty()) {
                    qDebug() << outputString;
                    emit requestTokenResponse(outputString);
                }
            }
        }
    })->start();
}

bool OnlineProvider::handleResponse(int32_t token, const std::string &response){
    return true;
}

