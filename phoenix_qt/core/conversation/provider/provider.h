#ifndef PROVIDER_H
#define PROVIDER_H

#pragma once

#include <QObject>

class Provider: public QObject
{
    Q_OBJECT
public:
    Provider();
    explicit Provider(QObject *parent = nullptr);

public slots:
    virtual void prompt(const QString &input);
    virtual void stop();
    virtual void loadModel(const QString &key);
    virtual void unloadModel();

signals:
    void tokenResponse(const QString &token);
    void finishedResponnse();
};

#endif // PROVIDER_H
