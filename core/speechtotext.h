#ifndef SPEECHTOTEXT_H
#define SPEECHTOTEXT_H

#include <QObject>
#include <QQmlEngine>
#include <QProcess>

class SpeechToText : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString modelPath READ getModelPath WRITE setModelPath NOTIFY modelPathChanged FINAL)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged FINAL)
    Q_PROPERTY(bool speechInProcess READ speechInProcess WRITE setSpeechInProcess NOTIFY speechInProcessChanged FINAL)
    Q_PROPERTY(bool modelSelect READ modelSelect WRITE setModelSelect NOTIFY modelSelectChanged FINAL)

public:
    static SpeechToText* instance(QObject* parent);

    ~SpeechToText();

    Q_INVOKABLE void startRecording();
    Q_INVOKABLE void stopRecording();

    QString getModelPath() const;
    void setModelPath(const QString &newModelPath);

    QString text() const;
    void setText(const QString &newText);

    bool speechInProcess() const;
    void setSpeechInProcess(bool newSpeechInProcess);

    bool modelSelect() const;
    void setModelSelect(bool newModelSelect);

signals:
    void modelPathChanged();
    void textChanged();
    void speechInProcessChanged();
    void modelSelectChanged();

private:
    explicit SpeechToText(QObject *parent = nullptr);
    static SpeechToText* m_instance;

    QProcess *m_process = nullptr;
    std::atomic_bool m_stopFlag = false;

    QString m_modelPath;
    bool m_modelSelect;
    QString m_text;
    bool m_speechInProcess;
};

#endif // SPEECHTOTEXT_H
