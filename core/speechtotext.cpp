#include "speechtotext.h"
#include <QDebug>
#include <QProcess>
#include <QThread>

#include <QCoreApplication>

SpeechToText* SpeechToText::m_instance = nullptr;

SpeechToText* SpeechToText::instance(QObject* parent){
    if (!m_instance) {
        m_instance = new SpeechToText(parent);
    }
    return m_instance;
}

SpeechToText::SpeechToText(QObject *parent)
    : QObject(parent), m_process(nullptr), m_modelPath(""), m_text("")
{
    setModelSelect(false);
    setSpeechInProcess(false);
}

SpeechToText::~SpeechToText(){
    if (m_process) {
        m_process->kill();
        m_process->deleteLater();
    }
}

void SpeechToText::startRecording() {
    if(m_modelPath == "")
        return;
    setText("");
    setSpeechInProcess(true);

    if (m_process) {
        qWarning() << "Already recording!";
        return;
    }
    m_stopFlag = false;

    QThread::create([this]() {
        m_process = new QProcess;
        m_process->setProcessChannelMode(QProcess::MergedChannels);
        m_process->setReadChannel(QProcess::StandardOutput);

        QString exePath = QCoreApplication::applicationDirPath() + "whisper/cpu-device/whisper-stream.exe";
        QStringList arguments;
        arguments << "-m" << m_modelPath
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

        bool run = false;
        while (m_process->state() == QProcess::Running && !m_stopFlag) {
            if (m_process->waitForReadyRead(500)) {
                QByteArray output = m_process->readAllStandardOutput();
                QString outputString = QString::fromUtf8(output, output.size());
                qInfo() << outputString;
                if((m_text == "") && (outputString == "Run") && (!run)){
                    run = true;
                }else if(run){
                    setText(m_text + outputString);
                }
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
    setText("");
    setSpeechInProcess(false);

    if (!m_process) {
        qWarning() << "No recording process to stop.";
        return;
    }
    m_stopFlag = true;
}

bool SpeechToText::modelSelect() const{return m_modelSelect;}
void SpeechToText::setModelSelect(bool newModelSelect){
    if (m_modelSelect == newModelSelect)
        return;
    m_modelSelect = newModelSelect;
    emit modelSelectChanged();
}

QString SpeechToText::getModelPath() const{return m_modelPath;}
void SpeechToText::setModelPath(const QString &newModelPath){
    if (m_modelPath == newModelPath)
        return;
    m_modelPath = newModelPath;
    emit modelPathChanged();
}

QString SpeechToText::text() const{return m_text;}
void SpeechToText::setText(const QString &newText){
    if (m_text == newText)
        return;
    m_text = newText;
    emit textChanged();
}

bool SpeechToText::speechInProcess() const{return m_speechInProcess;}
void SpeechToText::setSpeechInProcess(bool newSpeechInProcess){
    if (m_speechInProcess == newSpeechInProcess)
        return;
    m_speechInProcess = newSpeechInProcess;
    qInfo()<<m_speechInProcess;
    emit speechInProcessChanged();
}
