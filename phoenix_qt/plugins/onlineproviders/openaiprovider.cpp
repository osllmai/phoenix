#include "openaiprovider.h"

OpenAIProvider::OpenAIProvider(QObject *parent)
    : AbstractProvider{parent}
{}

QString OpenAIProvider::name() const
{
    return "Open AI";
}
