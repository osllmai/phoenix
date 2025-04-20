#include "offlineprovider.h"

#include <QDebug>
#include <QProcess>
#include <QThread>

OfflineProvider::OfflineProvider(QObject* parent)
    :Provider(parent), _stopFlag(false)
{
    moveToThread(&chatLLMThread);
    chatLLMThread.start();
    qInfo() << "new" << QThread::currentThread();
}

OfflineProvider::~OfflineProvider(){
    qInfo() << "delete" << QThread::currentThread() ;
    chatLLMThread.quit();
    chatLLMThread.wait();
}

void OfflineProvider::stop(){
    _stopFlag = true;
}

void OfflineProvider::loadModel(const QString &model, const QString &key) {
    QThread::create([this, model, key]() {
        QProcess process;
        process.setProcessChannelMode(QProcess::MergedChannels);
        process.setReadChannel(QProcess::StandardOutput);

        qInfo() << "11111";

        QString exePath = "providers/local_provider/applocal_provider.exe";
        QStringList arguments;
        arguments << "--model" << key
                  << "--backend" << "cpu";

        qInfo() << "11111";

        process.start(exePath, arguments);

        if (!process.waitForStarted()) {
            qCritical() << "Failed to start process: " << process.errorString();
            emit requestFinishedResponse("Failed to start process");
            return;
        }

        qInfo() << "11111";

        qInfo() << "Local provider started. Sending prompt...";

        QString text = "__PROMPT__";
        process.write(text.toUtf8());

        qInfo() << "11111";

        QString prompt = "Hello! Who are you?\n";
        process.write(prompt.toUtf8());
        process.waitForBytesWritten();

        qInfo() << "11111";

        QString fullResponse;
        while (process.state() == QProcess::Running) {
            if (_stopFlag) {
                qInfo() << "Stop flag detected. Terminating...";
                process.write("t\n");
                process.waitForBytesWritten();
                break;
            }

            if (process.waitForReadyRead(100)) {
                QByteArray output = process.readAllStandardOutput();
                QString outputString = QString::fromUtf8(output);

                if (!outputString.trimmed().isEmpty()) {
                    fullResponse += outputString;
                    emit requestTokenResponse(outputString);
                    qInfo() << "Received:" << outputString.trimmed();
                }
            }
        }

        process.waitForFinished(2000);
        _stopFlag = false;

        qInfo() << "Process finished.";
        emit requestFinishedResponse(fullResponse);
    })->start();
}


void OfflineProvider::unLoadModel(){
        // delete model;
        // model = nullptr;
}

void OfflineProvider::prompt(const QString &input, const bool &stream, const QString &promptTemplate,
                             const QString &systemPrompt, const double &temperature, const int &topK, const double &topP,
                             const double &minP, const double &repeatPenalty, const int &promptBatchSize, const int &maxTokens,
                             const int &repeatPenaltyTokens, const int &contextLength, const int &numberOfGPULayers){

}
