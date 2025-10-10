#include "converttomd.h"

ConvertToMD* ConvertToMD::m_instance = nullptr;

ConvertToMD* ConvertToMD::instance(QObject* parent){
    if (!m_instance) {
        m_instance = new ConvertToMD(parent);
    }
    return m_instance;
}

ConvertToMD::ConvertToMD(QObject *parent)
    : QObject(parent), m_process(nullptr), m_filePath(""), m_convertInProcess(false), m_fileIsSelect(false)
{
    setTextMD("");
}

ConvertToMD::~ConvertToMD(){
    if (m_process) {
        m_process->kill();
        m_process->deleteLater();
    }
}

void ConvertToMD::startConvert() {
    if(m_filePath.isEmpty())
        return;

    setTextMD("");
    if (m_convertInProcess) {
        qWarning() << "Already converting!";
        return;
    }

    setConvertInProcess(true);
    setFileIsSelect(true);

    ConvertWorker *worker = new ConvertWorker(m_filePath);
    QThread *workerThread = new QThread;

    worker->moveToThread(workerThread);

    connect(workerThread, &QThread::started, worker, &ConvertWorker::process);
    connect(worker, &ConvertWorker::finished, this, [this, worker, workerThread](const QString &mdText){
        setTextMD(mdText);
        setConvertInProcess(false);
        workerThread->quit();
    });
    connect(worker, &ConvertWorker::error, this, [](const QString &msg){
        qWarning() << msg;
    });
    connect(workerThread, &QThread::finished, worker, &QObject::deleteLater);
    connect(workerThread, &QThread::finished, workerThread, &QObject::deleteLater);

    workerThread->start();
}

QString ConvertToMD::filePath() const{return m_filePath;}
void ConvertToMD::setFilePath(const QString &newFilePath){
    if (m_filePath == newFilePath)
        return;
    m_filePath = newFilePath;
    m_filePath.remove("file:///");
    emit filePathChanged();
}

QString ConvertToMD::textMD() const{return m_textMD;}
void ConvertToMD::setTextMD(const QString &newTextMD){
    if (m_textMD == newTextMD)
        return;
    m_textMD = newTextMD;
    qInfo()<< m_textMD;
    emit textMDChanged();
}

bool ConvertToMD::convertInProcess() const{return m_convertInProcess;}
void ConvertToMD::setConvertInProcess(bool newConvertInProcess){
    if (m_convertInProcess == newConvertInProcess)
        return;
    m_convertInProcess = newConvertInProcess;
    emit convertInProcessChanged();
}

bool ConvertToMD::fileIsSelect() const{return m_fileIsSelect;}
void ConvertToMD::setFileIsSelect(bool newFileIsSelect){
    if (m_fileIsSelect == newFileIsSelect)
        return;
    m_fileIsSelect = newFileIsSelect;
    emit fileIsSelectChanged();
}
