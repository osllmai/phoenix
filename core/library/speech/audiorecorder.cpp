#include "AudioRecorder.h"

#include <QCoreApplication>

AudioRecorder* AudioRecorder::m_instance = nullptr;

AudioRecorder* AudioRecorder::instance(QObject* parent){
    if (!m_instance) {
        m_instance = new AudioRecorder(parent);
    }
    return m_instance;
}

AudioRecorder::~AudioRecorder(){}

AudioRecorder::AudioRecorder(QObject *parent) : QObject(parent) {
    m_recorder = new QMediaRecorder(this);

    QAudioFormat format;
    format.setSampleRate(44100);
    format.setChannelCount(1);
    format.setSampleFormat(QAudioFormat::Int16);

    QAudioDevice micDevice = QMediaDevices::defaultAudioInput();
    m_audioSource = new QAudioSource(micDevice, format, this);

    m_audioInput = new QAudioInput(this);

    m_session.setAudioInput(m_audioInput);
    m_session.setRecorder(m_recorder);

    connect(m_recorder, &QMediaRecorder::recorderStateChanged, this, [this](QMediaRecorder::RecorderState state) {
        setIsRecording(state == QMediaRecorder::RecordingState);
        if (state == QMediaRecorder::StoppedState) {
            emit recordingFinished(m_outputFile);
        }
    });

    connect(&m_levelTimer, &QTimer::timeout, this, [this]() {
        if (!m_inputDevice)
            return;

        QByteArray data = m_inputDevice->readAll();
        if (data.isEmpty())
            return;

        qint16 maxSample = 0;
        const qint16 *samples = reinterpret_cast<const qint16*>(data.constData());
        int sampleCount = data.size() / sizeof(qint16);

        for (int i = 0; i < sampleCount; ++i) {
            qint16 value = qAbs(samples[i]);
            if (value > maxSample)
                maxSample = value;
        }

        float newLevel = maxSample / 32767.0f;
        if (!qFuzzyCompare(newLevel, m_level)) {
            setLevel(newLevel);
        }
    });
}

void AudioRecorder::startRecording() {
    if (m_inputDevice) {
        m_inputDevice->close();
        m_inputDevice = nullptr;
    }

    if (m_audioSource) {
        delete m_audioSource;
        m_audioSource = nullptr;
    }

    QAudioFormat format;
    format.setSampleRate(44100);
    format.setChannelCount(1);
    format.setSampleFormat(QAudioFormat::Int16);

    QAudioDevice micDevice = QMediaDevices::defaultAudioInput();
    m_audioSource = new QAudioSource(micDevice, format, this);

    QString dir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    QDir().mkpath(dir);
    // QString timestamp = QDateTime::currentDateTime().toString("yyyyMMdd_HHmmss");
    m_outputFile = dir + "/recording" /*+ timestamp*/ + ".wav";

    QMediaFormat mediaFormat;
    mediaFormat.setFileFormat(QMediaFormat::Wave);
    mediaFormat.setAudioCodec(QMediaFormat::AudioCodec::Wave);

    m_recorder->setMediaFormat(mediaFormat);
    m_recorder->setOutputLocation(QUrl::fromLocalFile(m_outputFile));
    m_recorder->record();

    m_inputDevice = m_audioSource->start();

    if (!m_inputDevice || !m_inputDevice->isOpen()) {
        qWarning() << "Failed to open input device!";
    }

    m_levelTimer.start(50);
}


void AudioRecorder::stopRecording() {
    m_recorder->stop();

    if (m_inputDevice) {
        m_inputDevice->close();
        m_inputDevice = nullptr;
    }

    if (m_audioSource) {
        m_audioSource->stop();
    }
    m_levelTimer.stop();
    setLevel(0.0f);
}

bool AudioRecorder::isRecording() const { return m_isRecording; }
void AudioRecorder::setIsRecording(const bool &newIsRecording) {
    if (m_isRecording == newIsRecording)
        return;
    m_isRecording = newIsRecording;
    emit isRecordingChanged();
}

float AudioRecorder::level() const { return m_level; }
void AudioRecorder::setLevel(const float &newLevel) {
    m_level = newLevel;
    emit levelChanged();
}
