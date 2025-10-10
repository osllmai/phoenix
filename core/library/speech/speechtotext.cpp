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
    setModelInProcess(false);
}

SpeechToText::~SpeechToText(){
    if (m_process) {
        m_process->kill();
        m_process->deleteLater();
    }
}

void SpeechToText::start()
{
    QString dir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    QDir().mkpath(dir);
    QString audioPath = dir + "/recording.wav";

    QFileInfo fileInfo(audioPath);
    if (!fileInfo.exists() || fileInfo.suffix().toLower() != "wav") {
        qWarning() << "Invalid audio file";
        return;
    }

    if(m_modelPath.isEmpty())
        return;

    if (m_modelInProcess) {
        qWarning() << "Already recording!";
        return;
    }

    setText("");
    setModelInProcess(true);

    SpeechToTextWorker *worker = new SpeechToTextWorker(m_modelPath, audioPath, isCudaAvailable());
    QThread *workerThread = new QThread;

    worker->moveToThread(workerThread);

    connect(workerThread, &QThread::started, worker, &SpeechToTextWorker::process);
    connect(worker, &SpeechToTextWorker::textUpdated, this, [this](const QString &text){
        setText(text);
    });
    connect(worker, &SpeechToTextWorker::progressUpdated, this, [this](int p){
        setPercent(p);
    });
    connect(worker, &SpeechToTextWorker::errorOccurred, this, [](const QString &msg){
        qWarning() << msg;
    });
    connect(worker, &SpeechToTextWorker::finished, this, [this, workerThread, worker](){
        setModelInProcess(false);
        workerThread->quit();
    });
    connect(workerThread, &QThread::finished, worker, &QObject::deleteLater);
    connect(workerThread, &QThread::finished, workerThread, &QObject::deleteLater);

    workerThread->start();
}

bool SpeechToText::isCudaAvailable() {
    std::string cudaDllPath = "C:\\Windows\\System32\\nvcuda.dll";
    return std::filesystem::exists(cudaDllPath);
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

bool SpeechToText::modelInProcess() const{return m_modelInProcess;}
void SpeechToText::setModelInProcess(bool newmodelInProcess){
    if (m_modelInProcess == newmodelInProcess)
        return;
    m_modelInProcess = newmodelInProcess;
    qInfo()<<m_modelInProcess;
    emit modelInProcessChanged();
}

bool SpeechToText::percent() const{return m_percent;}
void SpeechToText::setPercent(bool newPercent){
    if (m_percent == newPercent)
        return;
    m_percent = newPercent;
    emit percentChanged();
}
