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
    if(m_filePath == "")
        return;
    setTextMD("");

    if (m_process) {
        qWarning() << "Already recording!";
        return;
    }

    setConvertInProcess(true);
    setFileIsSelect(true);

    QThread::create([this]() {
        m_process = new QProcess;
        m_process->setProcessChannelMode(QProcess::MergedChannels);
        m_process->setReadChannel(QProcess::StandardOutput);

        QString exePath = QCoreApplication::applicationDirPath() + "/markitdown/markitdown.exe";
        QStringList arguments;
        arguments << m_filePath;

        m_process->start(exePath, arguments);

        qInfo()<< "\"" + m_filePath + "\"";

        if (!m_process->waitForStarted()) {
            qCritical() << "Failed to start process: " << m_process->errorString();
            delete m_process;
            m_process = nullptr;

            setConvertInProcess(false);
            setFileIsSelect(false);
            return;
        }

        // bool run = false;
        while (m_process->state() == QProcess::Running) {
            if (m_process->waitForReadyRead(500)) {
                QByteArray output = m_process->readAllStandardOutput();
                QString outputString = QString::fromUtf8(output, output.size());
                qInfo() << outputString;

                // ---------------------set whisper---------------------
                // if ((m_textMD == "") && outputString.contains("---- BEGIN MARKDOWN ----") && !run) {
                //     int startIndex = outputString.indexOf("---- BEGIN MARKDOWN ----") + QString("---- BEGIN MARKDOWN ----").length();
                //     int endIndex = outputString.indexOf("---- END MARKDOWN ----");

                //     QString extracted;
                //     if (endIndex != -1) {
                //         extracted = outputString.mid(startIndex, endIndex - startIndex);
                //     } else {
                //         extracted = outputString.mid(startIndex);
                //     }

                //     setTextMD(m_textMD + extracted.trimmed());
                //     run = true;

                // }else if(run){
                //     setTextMD(m_textMD + outputString);

                // }
                // ---------------------end whisper---------------------
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

        // ---------------------set markitdown---------------------
        QString mdFilePath = QFileInfo(m_filePath).absolutePath() + "/" + QFileInfo(m_filePath).completeBaseName() + ".md";
        QFile mdFile(mdFilePath);
        if (mdFile.exists()) {
            if (mdFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
                QString markdownText = QString::fromUtf8(mdFile.readAll());
                mdFile.close();

                QMetaObject::invokeMethod(this, [this, markdownText]() {
                    setTextMD(markdownText);
                }, Qt::QueuedConnection);
            } else {
                qWarning() << "Cannot open markdown file for reading:" << mdFilePath;
            }
        } else {
            qWarning() << "Markdown file does not exist:" << mdFilePath;
        }
        // ---------------------end markitdown---------------------

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
