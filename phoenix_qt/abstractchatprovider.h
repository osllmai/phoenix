#pragma once

#include <QObject>

class AbstractChatProvider : public QObject
{
    Q_OBJECT

public:
    explicit AbstractChatProvider(QObject *parent = nullptr);

    virtual void prompt(const QString &input) = 0;

Q_SIGNALS:
    void tokenResponse(const QString &token);
};
