#ifndef CONVERTTOMD_H
#define CONVERTTOMD_H

#include <QObject>
#include <QQmlEngine>
#include <QCoreApplication>
#include <QProcess>
#include <QThread>
#include <QDebug>

class ConvertToMD : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString filePath READ filePath WRITE setFilePath NOTIFY filePathChanged FINAL)
    Q_PROPERTY(QString text READ text NOTIFY textChanged FINAL)
    Q_PROPERTY(bool convertInProcess READ convertInProcess NOTIFY convertInProcessChanged FINAL)

public:
    static ConvertToMD* instance(QObject* parent);

    ~ConvertToMD();

    Q_INVOKABLE void startConvert();

    QString filePath() const;
    void setFilePath(const QString &newFilePath);

    QString text() const;
    void setText(const QString &newText);

    bool convertInProcess() const;
    void setConvertInProcess(bool newConvertInProcess);

signals:
    void filePathChanged();
    void textChanged();
    void convertInProcessChanged();

private:
    explicit ConvertToMD(QObject *parent = nullptr);
    static ConvertToMD* m_instance;

    QProcess *m_process = nullptr;

    QString m_filePath;
    QString m_text;
    bool m_convertInProcess;
};

#endif // CONVERTTOMD_H
