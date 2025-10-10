#ifndef CONVERTWORKER_H
#define CONVERTWORKER_H

#include <QObject>
#include <QProcess>
#include <QDebug>

class ConvertWorker : public QObject
{
    Q_OBJECT
public:
    explicit ConvertWorker(const QString &filePath, QObject *parent = nullptr);

signals:
    void finished(const QString &markdownText);
    void error(const QString &message);

public slots:
    void process();

private:
    QString m_filePath;
};

#endif // CONVERTWORKER_H
