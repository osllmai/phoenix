#ifndef SPEECHTOTEXTWORKER_H
#define SPEECHTOTEXTWORKER_H

#include <QObject>
#include <QString>
#include <QProcess>
#include <atomic>

class SpeechToTextWorker : public QObject
{
    Q_OBJECT
public:
    explicit SpeechToTextWorker(const QString &modelPath, const QString &audioPath, bool cuda, QObject *parent = nullptr);

signals:
    void finished();
    void textUpdated(const QString &newText);
    void progressUpdated(int percent);
    void errorOccurred(const QString &message);

public slots:
    void process();

private:
    QString m_modelPath;
    QString m_audioPath;
    bool m_cuda;
    std::atomic_bool m_stopFlag;
};

#endif // SPEECHTOTEXTWORKER_H
