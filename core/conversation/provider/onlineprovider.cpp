#include "onlineprovider.h"

#include <QCoreApplication>

OnlineProvider::OnlineProvider(QObject* parent)
    : Provider(parent), _stopFlag(false)
{}

OnlineProvider::OnlineProvider(QObject *parent, const QString &model, const QString &key)
    :Provider(parent), _stopFlag(false), m_model(model), m_key(key)
{}

OnlineProvider::~OnlineProvider(){
    if (m_process) {
        m_process->kill();
        m_process->deleteLater();
    }
}

void OnlineProvider::stop(){
    _stopFlag = true;
}

void OnlineProvider::loadModel(const QString &model, const QString &key){
    m_model = model;
    m_key = key;
}

void OnlineProvider::unLoadModel(){}

void OnlineProvider::prompt(const QString &input, const bool &stream, const QString &promptTemplate,
                            const QString &systemPrompt, const double &temperature, const int &topK, const double &topP,
                            const double &minP, const double &repeatPenalty, const int &promptBatchSize, const int &maxTokens,
                            const int &repeatPenaltyTokens, const int &contextLength, const int &numberOfGPULayers) {

    QThread::create([this, input, stream, promptTemplate, systemPrompt, temperature, topK, topP, minP,
                     repeatPenalty, promptBatchSize, maxTokens, repeatPenaltyTokens, contextLength, numberOfGPULayers]() {
        m_process = new QProcess;
        m_process->setProcessChannelMode(QProcess::MergedChannels);
        m_process->setReadChannel(QProcess::StandardOutput);

        QString exePath = QCoreApplication::applicationDirPath() + "/providers/online_provider/main_provider.exe";
        QStringList arguments;
        arguments << m_model
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

        m_process->start(exePath, arguments);

        if (!m_process->waitForStarted()) {
            qCritical() << "Failed to start process: " << m_process->errorString();
            return;
        }

        while (m_process->state() == QProcess::Running) {
            QString stopFlagStr = _stopFlag ? "t" : "f";
            m_process->write(stopFlagStr.toUtf8());
            m_process->waitForBytesWritten();

            if (m_process->waitForReadyRead(400)) {
                QByteArray output = m_process->readAllStandardOutput();
                QString outputString = QString::fromUtf8(output, output.size());;

                if (!outputString.isEmpty()) {
                    emit requestTokenResponse(outputString);
                }
                qInfo()<<outputString;
            }

            if (_stopFlag) {
                m_process->write("t");
                m_process->waitForBytesWritten();
                break;
            }
        }

        _stopFlag = false;

        qInfo() << "Process finished.";
        emit requestFinishedResponse("");
    })->start();
}

