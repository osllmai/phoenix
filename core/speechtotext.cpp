#include "speechtotext.h"
#include <QDebug>
#include <QProcess>
#include <QThread>

SpeechToText* SpeechToText::m_instance = nullptr;

SpeechToText* SpeechToText::instance(QObject* parent){
    if (!m_instance) {
        m_instance = new SpeechToText(parent);
    }
    return m_instance;
}

SpeechToText::SpeechToText(QObject *parent)
    : QObject(parent), m_process(nullptr)
{}

SpeechToText::~SpeechToText(){
    if (!m_process) {
        qWarning() << "No recording process to stop.";
        return;
    }

    m_stopFlag = true;
}

void SpeechToText::startRecording() {
    if (m_process) {
        qWarning() << "Already recording!";
        return;
    }

    m_stopFlag = false;

    QThread::create([this]() {
        m_process = new QProcess;
        m_process->setProcessChannelMode(QProcess::MergedChannels);
        m_process->setReadChannel(QProcess::StandardOutput);

        QString exePath = "./whisper/whisper-stream.exe";
        QStringList arguments;
        arguments << "-m" << "./whisper/ggml-base.en.bin"
                  << "--step" << "0"
                  << "--length" << "3000"
                  << "--keep" << "1000";

        m_process->start(exePath, arguments);

        if (!m_process->waitForStarted()) {
            qCritical() << "Failed to start process: " << m_process->errorString();
            delete m_process;
            m_process = nullptr;
            return;
        }

        while (m_process->state() == QProcess::Running && !m_stopFlag) {
            if (m_process->waitForReadyRead(500)) {
                QByteArray output = m_process->readAllStandardOutput();
                QString outputString = QString::fromUtf8(output, output.size());
                qInfo() << outputString;
            }
        }

        if (m_process->state() != QProcess::NotRunning) {
            m_process->terminate();
            if (!m_process->waitForFinished(1000)) {
                m_process->kill();
                m_process->waitForFinished();
            }
        }

        delete m_process;
        m_process = nullptr;

        qInfo() << "Recording process finished.";

    })->start();
}


void SpeechToText::stopRecording() {
    if (!m_process) {
        qWarning() << "No recording process to stop.";
        return;
    }

    m_stopFlag = true;
}


void SpeechToText::onReadyRead() {
    QString output = m_process->readAllStandardOutput();
    emit newText(output);
}
