#include "converttomd.h"

ConvertToMD::ConvertToMD(QObject *parent)
    : QObject(parent), m_process(nullptr), m_filePath(""), m_text(""), m_convertInProcess(false)
{}

ConvertToMD::~ConvertToMD(){
    if (m_process) {
        m_process->kill();
        m_process->deleteLater();
    }
}

void ConvertToMD::startConvert() {
    if(m_filePath == "")
        return;
    setText("");
    setConvertInProcess(true);

    if (m_process) {
        qWarning() << "Already recording!";
        return;
    }

    QThread::create([this]() {
        m_process = new QProcess;
        m_process->setProcessChannelMode(QProcess::MergedChannels);
        m_process->setReadChannel(QProcess::StandardOutput);

        QString exePath = QCoreApplication::applicationDirPath() + "/docling/ConvertToMD/convert_to_md.exe";
        QStringList arguments;
        arguments << m_filePath;

        m_process->start(exePath, arguments);

        qInfo()<<m_filePath;

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
                if((m_text == "") && (outputString == "---- BEGIN MARKDOWN ----") && (!run)){
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

        setConvertInProcess(false);

    })->start();
}

QString ConvertToMD::filePath() const{return m_filePath;}
void ConvertToMD::setFilePath(const QString &newFilePath){
    if (m_filePath == newFilePath)
        return;
    m_filePath = newFilePath;
    emit filePathChanged();
}

QString ConvertToMD::text() const{return m_text;}
void ConvertToMD::setText(const QString &newText){
    if (m_text == newText)
        return;
    m_text = newText;
    emit textChanged();
}

bool ConvertToMD::convertInProcess() const{return m_convertInProcess;}
void ConvertToMD::setConvertInProcess(bool newConvertInProcess){
    if (m_convertInProcess == newConvertInProcess)
        return;
    m_convertInProcess = newConvertInProcess;
    emit convertInProcessChanged();
}
