#include "onlineworker.h"
#include <QCoreApplication>
#include <QDebug>

OnlineWorker::OnlineWorker(const QString &model, const QString &key, const QString &input,
                           bool stream, const QString &promptTemplate, const QString &systemPrompt,
                           double temperature, int topK, double topP, double minP,
                           double repeatPenalty, int promptBatchSize, int maxTokens,
                           int repeatPenaltyTokens, int contextLength, int numberOfGPULayers,
                           std::atomic<bool> *stopFlag, QObject *parent)
    : QObject(parent),
    m_model(model), m_key(key), m_input(input),
    m_promptTemplate(promptTemplate), m_systemPrompt(systemPrompt),
    m_stream(stream), m_temperature(temperature), m_topK(topK), m_topP(topP),
    m_minP(minP), m_repeatPenalty(repeatPenalty), m_promptBatchSize(promptBatchSize),
    m_maxTokens(maxTokens), m_repeatPenaltyTokens(repeatPenaltyTokens),
    m_contextLength(contextLength), m_numberOfGPULayers(numberOfGPULayers),
    m_stopFlag(stopFlag)
{}

void OnlineWorker::run() {
    QProcess process;
    process.setProcessChannelMode(QProcess::MergedChannels);

    QString exePath = QCoreApplication::applicationDirPath() + "/providers/online_provider/online_provider.exe";

    QStringList args;

    QString modelName = m_model;
    QString keyIndox = API_KEY_INDOXROUTER;
    QString myKey = m_key;

    if (m_model.startsWith("IndoxRouter/")) {
        modelName = m_model.mid(QString("IndoxRouter/").length());
        keyIndox = m_key;
        myKey = "";
    }

    args << modelName
         << keyIndox
         << m_input
         << (m_stream ? "1" : "0")
         << m_promptTemplate
         << m_systemPrompt
         << QString::number(m_temperature)
         << QString::number(m_topK)
         << QString::number(m_topP)
         << QString::number(m_minP)
         << QString::number(m_repeatPenalty)
         << QString::number(m_promptBatchSize)
         << QString::number(m_maxTokens)
         << QString::number(m_repeatPenaltyTokens)
         << QString::number(m_contextLength)
         << QString::number(m_numberOfGPULayers)
         << myKey;


    process.start(exePath, args);

    if (!process.waitForStarted()) {
        qCritical() << "Failed to start process:" << process.errorString();
        emit finished();
        return;
    }

    while (process.state() == QProcess::Running && !m_stopFlag->load()) {
        if (process.waitForReadyRead(300)) {
            QString output = QString::fromUtf8(process.readAllStandardOutput());
            if (!output.isEmpty()){
                emit tokenReady(output);
                qInfo()<<output;
            }
        }
    }

    if (m_stopFlag->load()) {
        process.kill();
        process.waitForFinished(1000);
    }

    emit finished();
}
