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

void SpeechToText::start() {
    QString dir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    QDir().mkpath(dir);
    QString audioPath = dir + "/recording"+ ".wav";

    QFileInfo fileInfo(audioPath);
    if (!fileInfo.exists() || fileInfo.suffix().toLower() != "wav") {
        qWarning() << "Invalid audio file: either not exists or not a .wav file";
        return;
    }

    if(m_modelPath == "")
        return;

    if (m_process) {
        qWarning() << "Already recording!";
        return;
    }

    setText("");
    setModelInProcess(true);

    QThread::create([this, audioPath]() {
        m_process = new QProcess;
        m_process->setProcessChannelMode(QProcess::MergedChannels);
        m_process->setReadChannel(QProcess::StandardOutput);

        QString exePath = "";

        if(isCudaAvailable())
            exePath = QCoreApplication::applicationDirPath() + "/whisper/cuda-device/whisper-cli.exe";
        else
            exePath = QCoreApplication::applicationDirPath() + "/whisper/cpu-device/whisper-cli.exe";

        QStringList arguments;
        arguments << "-m" << m_modelPath
                  << "-f" << audioPath
                  << "--print-progress"
                  << "--language" << "auto";

        m_process->start(exePath, arguments);

        if (!m_process->waitForStarted()) {
            qCritical() << "Failed to start process: " << m_process->errorString();
            delete m_process;
            m_process = nullptr;
            setModelInProcess(false);
            return;
        }

        std::regex timestamp_regex(R"(^\[\d{2}:\d{2}:\d{2}\.\d{3} --> \d{2}:\d{2}:\d{2}\.\d{3}\]\s*(.+)$)");
        std::regex progress_regex(R"(whisper_print_progress_callback:\s*progress\s*=\s*(\d{1,3})%)");

        while (m_process->state() == QProcess::Running) {
            if (m_process->waitForReadyRead(300)) {
                QByteArray output = m_process->readAllStandardOutput();
                QString outputString = QString::fromUtf8(output, output.size());

                qInfo() << outputString;
                QStringList lines = outputString.split(QRegularExpression("[\r\n]+"), Qt::SkipEmptyParts);

                for (const QString& line : lines) {
                    std::string stdLine = line.toStdString();
                    std::smatch match;

                    if (std::regex_search(stdLine, match, timestamp_regex)) {
                        QString text = QString::fromStdString(match[1]);
                        std::cout << "Text: " << match[1] << std::endl;
                        setText(m_text + text);
                    }
                    else if (std::regex_search(stdLine, match, progress_regex)) {
                        int progress = std::stoi(match[1]);
                        setPercent(progress);
                        std::cout << "Progress: " << progress << "%" << std::endl;
                    }
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
        setModelInProcess(false);

    })->start();

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
