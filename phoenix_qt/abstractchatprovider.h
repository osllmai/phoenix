#pragma once

#include <QObject>

class AbstractChatProvider : public QObject
{
    Q_OBJECT

public:
    explicit AbstractChatProvider(QObject *parent = nullptr);

    virtual void prompt(const QString &input) = 0;
    virtual void stop();
    virtual void loadModel(const QString &modelPath);
    virtual void unloadModel();

Q_SIGNALS:
    void tokenResponse(const QString &token);
};
