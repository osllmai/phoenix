#include "audiorecorder.h"
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

    const QList<QAudioDevice> devices = QMediaDevices::audioInputs();
    for (const QAudioDevice &device : devices){
        qInfo()<<device.description();
        m_inputDevices << device.description();
    }

    if (!m_inputDevices.isEmpty())
        m_selectedDevice = m_inputDevices.first();

    connect(new QMediaDevices(this), &QMediaDevices::audioInputsChanged, this, [this]() {
        QStringList newList;
        const QList<QAudioDevice> devices = QMediaDevices::audioInputs();

        for (const QAudioDevice &device : devices){
            qInfo()<<device.description();
            newList << device.description();
        }

        if (newList != m_inputDevices) {
            m_inputDevices = newList;
            emit inputDevicesChanged();
        }
    });



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

// Device selection logic
QStringList AudioRecorder::inputDevices() const {
    return m_inputDevices;
}

void AudioRecorder::setInputDevices(const QStringList &newInputDevices) {
    if (m_inputDevices == newInputDevices)
        return;
    m_inputDevices = newInputDevices;
    emit inputDevicesChanged();
}

QString AudioRecorder::selectedDevice() const {
    return m_selectedDevice;
}

void AudioRecorder::setSelectedDevice(const QString &newSelectedDevice) {
    if (m_selectedDevice == newSelectedDevice)
        return;
    m_selectedDevice = newSelectedDevice;
    emit selectedDeviceChanged();

    const QList<QAudioDevice> devices = QMediaDevices::audioInputs();
    for (const QAudioDevice &device : devices) {
        if (device.description() == m_selectedDevice) {
            if (m_audioSource) {
                delete m_audioSource;
                m_audioSource = nullptr;
            }
            QAudioFormat format;
            format.setSampleRate(44100);
            format.setChannelCount(1);
            format.setSampleFormat(QAudioFormat::Int16);
            m_audioSource = new QAudioSource(device, format, this);
            break;
        }
    }
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

    // 🎯 Use selected device
    QAudioDevice micDevice;
    for (const QAudioDevice &device : QMediaDevices::audioInputs()) {
        if (device.description() == m_selectedDevice) {
            micDevice = device;
            break;
        }
    }
    if (!micDevice.isNull())
        m_audioSource = new QAudioSource(micDevice, format, this);
    else
        m_audioSource = new QAudioSource(QMediaDevices::defaultAudioInput(), format, this);

    QString dir = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    QDir().mkpath(dir);
    m_outputFile = dir + "/recording.wav";

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
