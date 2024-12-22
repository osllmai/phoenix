#pragma once

#include <abstractprovider.h>

class OpenAIProvider : public AbstractProvider
{
    Q_OBJECT

public:
    OpenAIProvider(QObject *parent = nullptr);

    // AbstractProvider interface
public:
    QString name() const;
};
