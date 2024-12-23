#include "offlinemodel.h"

#include <QDebug>
#include <QThread>

OfflineModel::OfflineModel(QObject *parent)
    : AbstractProvider{parent}
{}

bool OfflineModel::loadModel(const QString &modelPath)
{
    qInfo() << "Running" << QThread::currentThread() << " in the loadModel chatllm.cpp";

    std::string backend = "cuda";

    prompt_context.n_ctx = 4096;
    prompt_context.n_predict = 4096;
    int ngl = 100;
    model = LLModel::Implementation::construct(modelPath.toStdString(),
                                               backend,
                                               prompt_context.n_ctx);
    prompt_template = "<|start_header_id|>user<|end_header_id|>\n\n%1<|eot_id|><|start_header_id|>"
                      "assistant<|end_header_id|>\n\n%2<|eot_id|>";

#ifdef Q_OS_WIN
    if (backend == "cuda") {
        auto devices = LLModel::Implementation::availableGPUDevices();
        if (!devices.empty()) {
            // Example: Initialize the first available device
            size_t memoryRequired = devices[0].heapSize;
            const std::string &name = devices[0].name;
            const size_t requiredMemory = model->requiredMem(modelPath.toStdString(),
                                                             prompt_context.n_ctx,
                                                             ngl);
            auto devices = model->availableGPUDevices(memoryRequired);
            for (const auto &device : devices) {
                if (device.name == name && model->initializeGPUDevice(device.index)) {
                    break;
                }
            }
        }
    }
#endif
    auto check_model = model->loadModel(modelPath.toStdString(), prompt_context.n_ctx, ngl);
    if (check_model) {
        qDebug() << "\r" << "done loading!";
        emit loadModelFinished(true);
    } else {
        qDebug() << "load Unsuccessful";
        emit loadModelFinished(false);
    }
    // emit loadModelResult(true);
    qInfo() << "Finished" << QThread::currentThread() << " in the loadModel chatllm.cpp";
    return check_model;
}

void OfflineModel::unloadModel()
{
    delete model;
    model = nullptr;
}

void OfflineModel::prompt(const QString &text)
{
    stop = false;
    qInfo() << "Running" << QThread::currentThread() << " in the prompt chatllm.cpp";

    qDebug() << "This is C++ talking, input: " << text;

    auto prompt_callback = [](int32_t token_id) { return true; };

    auto response_callback = std::bind(&OfflineModel::handleResponse,
                                       this,
                                       std::placeholders::_1,
                                       std::placeholders::_2);

    auto recalculate_callback = [](bool is_recalculating) { return is_recalculating; };

    std::string stdStr = text.toStdString();

    model->prompt(stdStr,
                  prompt_template,
                  prompt_callback,
                  response_callback,
                  recalculate_callback,
                  prompt_context,
                  false,
                  nullptr);

    qInfo() << answer;

    // for(int i=0;i<30;i++){
    //     emit tokenResponse("Hi  :)  ");
    //     // qInfo()<<"send";
    //     Sleep(50);
    //     emit tokenResponse("Phoenix!, ");
    //     Sleep(50);
    // }

    emit finished();
    qInfo() << "Finished" << QThread::currentThread() << " in the prompt chatllm.cpp";
}

bool OfflineModel::handleResponse(int32_t token, const std::string &response)
{
    Q_UNUSED(token)
    const char *responsechars = response.c_str();

    if (responsechars != nullptr && responsechars[0] != '\0') {
        qInfo() << responsechars;

        answer += responsechars;
        emit tokenRecivied(QString::fromStdString(response));
    }
    return !stop;
}
