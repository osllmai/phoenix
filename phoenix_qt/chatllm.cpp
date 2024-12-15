#include "chatllm.h"
#include "chat.h"

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

#include "../phoenix/llmodel.h"

std::string answer = "";
LLModel::PromptContext prompt_context;
LLModel* model;
std::string prompt_template;

ChatLLM::ChatLLM(Chat *parent)
    : QObject{parent}
    , stop(false)
{
    moveToThread(&chatLLMThread);
    chatLLMThread.start();
    qInfo() << "new" << QThread::currentThread();
}

ChatLLM::~ChatLLM(){
    qInfo() << "delete" << QThread::currentThread() ;
    chatLLMThread.quit();
    chatLLMThread.wait();
}

void ChatLLM::setStop(){
    stop = true;
}

void ChatLLM::loadModel(const QString &modelPath)
{
    qInfo() << "Running" << QThread::currentThread() << " in the loadModel chatllm.cpp";

    std::string backend = "cuda";

    prompt_context.n_ctx = 4096;
    prompt_context.n_predict = 4096;
    int ngl = 100;
    model = LLModel::Implementation::construct(modelPath.toStdString(), backend, prompt_context.n_ctx);
    prompt_template = "<|start_header_id|>user<|end_header_id|>\n\n%1<|eot_id|><|start_header_id|>assistant<|end_header_id|>\n\n%2<|eot_id|>";

#if(WIN32)
    if (backend == "cuda") {
        auto devices = LLModel::Implementation::availableGPUDevices();
        if (!devices.empty()) {
            // Example: Initialize the first available device
            size_t memoryRequired = devices[0].heapSize;
            const std::string& name = devices[0].name;
            const size_t requiredMemory = model->requiredMem(modelPath.toStdString(), prompt_context.n_ctx, ngl);
            auto devices = model->availableGPUDevices(memoryRequired);
            for (const auto& device : devices) {
                if (device.name == name && model->initializeGPUDevice(device.index)) {
                    break;
                }
            }
        }
    }
#endif
    auto check_model = model->loadModel(modelPath.toStdString(), prompt_context.n_ctx , ngl);
    if (check_model == false) {
        qDebug()<<"load Unsuccessful";
        emit loadModelResult(false);
    }
    else {
        qDebug() << "\r" << "done loading!" ;
        emit loadModelResult(true);
    }
    // emit loadModelResult(true);
    qInfo() << "Finished" << QThread::currentThread() << " in the loadModel chatllm.cpp";
}

void ChatLLM::unLoadModel(){
    delete model;
    model = nullptr;
}

void ChatLLM::prompt(const QString &input){
    stop = false;
    qInfo() << "Running" << QThread::currentThread()<< " in the prompt chatllm.cpp";

    answer = "";

    qDebug() << "This is C++ talking, input: " << input;

    auto prompt_callback = [](int32_t token_id) { return true;};

    auto response_callback = std::bind(&ChatLLM::handleResponse, this, std::placeholders::_1, std::placeholders::_2);

    auto recalculate_callback = [](bool is_recalculating) {return is_recalculating;};

    std::string stdStr = input.toStdString();

    model->prompt( stdStr , prompt_template, prompt_callback, response_callback, recalculate_callback,prompt_context , false, nullptr);

    QString qStr = QString::fromStdString(answer);
    qInfo() <<  qStr;

    // for(int i=0;i<30;i++){
    //     emit tokenResponse("Hi  :)  ");
    //     // qInfo()<<"send";
    //     Sleep(50);
    //     emit tokenResponse("Phoenix!, ");
    //     Sleep(50);
    // }

    emit finishedResponnse();
    qInfo() << "Finished" << QThread::currentThread() <<" in the prompt chatllm.cpp";

}

bool ChatLLM::handleResponse(int32_t token, const std::string &response){
    const char* responsechars = response.c_str();


    if (!(responsechars == nullptr || responsechars[0] == '\0')) {

        std::cout << responsechars << std::flush;
        qInfo()<<responsechars;

        answer += responsechars;
        emit tokenResponse(QString::fromStdString(response));
    }
    return !stop;
}

