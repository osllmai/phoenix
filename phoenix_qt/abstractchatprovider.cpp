#include "abstractchatprovider.h"

AbstractChatProvider::AbstractChatProvider(QObject *parent)
    : QObject{parent}
{}

void AbstractChatProvider::stop() {}

void AbstractChatProvider::loadModel(const QString &modelPath) {}

void AbstractChatProvider::unloadModel() {}
