#ifndef SPEECHTOTEXT_H
#define SPEECHTOTEXT_H

#include <QObject>
#include <QProcess>

class SpeechToText : public QObject {
    Q_OBJECT
public:
    static SpeechToText* instance(QObject* parent);

    ~SpeechToText();

    Q_INVOKABLE void startRecording();
    Q_INVOKABLE void stopRecording();

signals:
    void newText(const QString &text);

private slots:
    void onReadyRead();

private:
    explicit SpeechToText(QObject *parent = nullptr);
    static SpeechToText* m_instance;

    QProcess *m_process = nullptr;
    std::atomic_bool m_stopFlag = false;

};

#endif // SPEECHTOTEXT_H
