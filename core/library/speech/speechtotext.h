#ifndef SPEECHTOTEXT_H
#define SPEECHTOTEXT_H

#include <QObject>
#include <QQmlEngine>
#include <QProcess>
#include <QThread>
#include <QStandardPaths>
#include <QFile>
#include <QFileInfo>
#include <QDir>
#include <QRegularExpression>
#include <iostream>
#include <regex>
#include <string>
#include <sstream>
#include <iostream>
#include <filesystem>
#include "SpeechToTextWorker.h"

class SpeechToText : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString modelPath READ getModelPath WRITE setModelPath NOTIFY modelPathChanged FINAL)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged FINAL)
    Q_PROPERTY(bool modelInProcess READ modelInProcess WRITE setModelInProcess NOTIFY modelInProcessChanged FINAL)
    Q_PROPERTY(bool modelSelect READ modelSelect WRITE setModelSelect NOTIFY modelSelectChanged FINAL)
    Q_PROPERTY(bool percent READ percent WRITE setPercent NOTIFY percentChanged FINAL)

public:
    static SpeechToText* instance(QObject* parent);

    ~SpeechToText();

    Q_INVOKABLE void start();

    QString getModelPath() const;
    void setModelPath(const QString &newModelPath);

    QString text() const;
    void setText(const QString &newText);

    bool modelInProcess() const;
    void setModelInProcess(bool newmodelInProcess);

    bool modelSelect() const;
    void setModelSelect(bool newModelSelect);

    bool percent() const;
    void setPercent(bool newPercent);

signals:
    void modelPathChanged();
    void textChanged();
    void modelInProcessChanged();
    void modelSelectChanged();
    void percentChanged();

private:
    explicit SpeechToText(QObject *parent = nullptr);
    static SpeechToText* m_instance;

    QProcess *m_process = nullptr;
    std::atomic_bool m_stopFlag = false;

    QString m_modelPath;
    bool m_modelSelect;
    QString m_text;
    bool m_modelInProcess;
    bool m_percent;

    bool isCudaAvailable();
};

#endif // SPEECHTOTEXT_H
