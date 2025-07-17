#include "converttomd.h"

ConvertToMD* ConvertToMD::m_instance = nullptr;

ConvertToMD* ConvertToMD::instance(QObject* parent){
    if (!m_instance) {
        m_instance = new ConvertToMD(parent);
    }
    return m_instance;
}

ConvertToMD::ConvertToMD(QObject *parent)
    : QObject(parent), m_process(nullptr), m_filePath(""), m_convertInProcess(false)
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
    if(m_filePath == "")
        return;
    setTextMD("");
    setConvertInProcess(true);

    if (m_process) {
        qWarning() << "Already recording!";
        return;
    }

    QThread::create([this]() {
        m_process = new QProcess;
        m_process->setProcessChannelMode(QProcess::MergedChannels);
        m_process->setReadChannel(QProcess::StandardOutput);

        QString exePath = QCoreApplication::applicationDirPath() + "/docling/convert/convert_to_md.exe";
        QStringList arguments;
        arguments << m_filePath;

        m_process->start(exePath, arguments);

        qInfo()<< "\"" + m_filePath + "\"";

        if (!m_process->waitForStarted()) {
            qCritical() << "Failed to start process: " << m_process->errorString();
            delete m_process;
            m_process = nullptr;
            return;
        }

        bool run = false;
        while (m_process->state() == QProcess::Running) {
            if (m_process->waitForReadyRead(500)) {
                QByteArray output = m_process->readAllStandardOutput();
                QString outputString = QString::fromUtf8(output, output.size());
                qInfo() << outputString;
                if((m_textMD == "") && (outputString == "---- BEGIN MARKDOWN ----") && (!run)){
                    run = true;
                }else if(run){
                    setTextMD(m_textMD + outputString);
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

        setConvertInProcess(false);

    })->start();
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
    emit textMDChanged();
}

bool ConvertToMD::convertInProcess() const{return m_convertInProcess;}
void ConvertToMD::setConvertInProcess(bool newConvertInProcess){
    if (m_convertInProcess == newConvertInProcess)
        return;
    m_convertInProcess = newConvertInProcess;
    emit convertInProcessChanged();
}
