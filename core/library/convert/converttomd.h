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
    Q_PROPERTY(QString textMD READ textMD NOTIFY textMDChanged FINAL)
    Q_PROPERTY(bool convertInProcess READ convertInProcess NOTIFY convertInProcessChanged FINAL)
    Q_PROPERTY(bool fileIsSelect READ fileIsSelect WRITE setFileIsSelect NOTIFY fileIsSelectChanged FINAL)

public:
    static ConvertToMD* instance(QObject* parent);

    ~ConvertToMD();

    Q_INVOKABLE void startConvert();

    QString filePath() const;
    void setFilePath(const QString &newFilePath);

    QString textMD() const;
    void setTextMD(const QString &newTextMD);

    bool convertInProcess() const;
    void setConvertInProcess(bool newConvertInProcess);

    bool fileIsSelect() const;
    void setFileIsSelect(bool newFileIsSelect);

signals:
    void filePathChanged();
    void textMDChanged();
    void convertInProcessChanged();

    void fileIsSelectChanged();

private:
    explicit ConvertToMD(QObject *parent = nullptr);
    static ConvertToMD* m_instance;

    QProcess *m_process = nullptr;

    QString m_filePath;
    QString m_textMD;
    bool m_convertInProcess;
    bool m_fileIsSelect;
};

#endif // CONVERTTOMD_H
