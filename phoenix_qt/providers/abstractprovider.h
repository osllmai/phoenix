#pragma once

#include <QObject>

class AbstractProvider : public QObject
{
    Q_OBJECT
public:
    explicit AbstractProvider(QObject *parent = nullptr);

    virtual void send(const QString &message) = 0;

Q_SIGNALS:
    void responseRecivied(const QString &response);
};
