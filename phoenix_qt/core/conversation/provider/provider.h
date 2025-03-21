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
    virtual void loadModel(const QString &model, const QString &key);
    virtual void unLoadModel();

signals:
    void requestLoadModelResult(const bool result, const QString &warning);
    void requestTokenResponse(const QString &token);
    void requestFinishedResponse(const QString &warning);
};

#endif // PROVIDER_H
