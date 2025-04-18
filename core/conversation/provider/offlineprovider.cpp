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

void OfflineProvider::loadModel(const QString &model, const QString &key){
    QThread::create([this]() {
        QProcess process;
        process.setProcessChannelMode(QProcess::MergedChannels);
        process.setReadChannel(QProcess::StandardOutput);

        QString exePath = "providers/online_provider/main_provider.exe";
        QStringList arguments;
        arguments << m_model
                  /*<< m_key
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
                  << QString::number(numberOfGPULayers)*/;

        process.start(exePath, arguments);

        if (!process.waitForStarted()) {
            qCritical() << "Failed to start process: " << process.errorString();
            return;
        }

        while (process.state() == QProcess::Running) {
            QString stopFlagStr = _stopFlag ? "t" : "f";
            process.write(stopFlagStr.toUtf8());
            process.waitForBytesWritten();

            if (process.waitForReadyRead(500)) {
                QByteArray output = process.readAllStandardOutput();
                QString outputString = QString::fromUtf8(output, output.size());;

                if (!outputString.isEmpty()) {
                    emit requestTokenResponse(outputString);
                }
                qInfo()<<outputString;
            }

            if (_stopFlag) {
                process.write("t");
                process.waitForBytesWritten();
                break;
            }
        }

        _stopFlag = false;

        qInfo() << "Process finished.";
        emit requestFinishedResponse("");
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
