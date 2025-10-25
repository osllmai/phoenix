#pragma once

#include <QObject>
#include <QMediaCaptureSession>
#include <QMediaRecorder>
#include <QMediaDevices>
#include <QAudioSource>
#include <QAudioInput>
#include <QAudioFormat>
#include <QStandardPaths>
#include <QDir>
#include <QDateTime>
#include <QDebug>
#include <QMediaDevices>
#include <QMediaFormat>
#include <QIODevice>
#include <QTimer>
#include <QUrl>

class AudioRecorder : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool isRecording READ isRecording NOTIFY isRecordingChanged FINAL)
    Q_PROPERTY(float level READ level NOTIFY levelChanged FINAL)
    Q_PROPERTY(QStringList inputDevices READ inputDevices NOTIFY inputDevicesChanged FINAL)
    Q_PROPERTY(QString selectedDevice READ selectedDevice WRITE setSelectedDevice NOTIFY selectedDeviceChanged FINAL)

public:
    static AudioRecorder* instance(QObject* parent);
    ~AudioRecorder();

    Q_INVOKABLE void startRecording();
    Q_INVOKABLE void stopRecording();

    void setIsRecording(const bool &newIsRecording);
    bool isRecording() const;

    void setLevel(const float &newLevel);
    float level() const;

    QStringList inputDevices() const;
    void setInputDevices(const QStringList &newInputDevices);

    QString selectedDevice() const;
    void setSelectedDevice(const QString &newSelectedDevice);

signals:
    void isRecordingChanged();
    void levelChanged();
    void recordingFinished(const QString &filePath);

    void inputDevicesChanged();
    void selectedDeviceChanged();

private:
    explicit AudioRecorder(QObject *parent = nullptr);
    static AudioRecorder* m_instance;

    QMediaCaptureSession m_session;
    QMediaRecorder *m_recorder = nullptr;
    QAudioSource *m_audioSource = nullptr;
    QIODevice *m_inputDevice = nullptr;
    QAudioInput *m_audioInput = nullptr;
    QTimer m_levelTimer;

    bool m_isRecording = false;
    float m_level = 0.0f;
    QString m_outputFile;

    QStringList m_inputDevices;
    QString m_selectedDevice;
};
