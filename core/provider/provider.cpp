#include "provider.h"

Provider::Provider(QObject *parent): QObject(parent) {}

Provider::Provider(QObject *parent, const QString &model, const QString &key):
    QObject(parent) {}

void Provider::prompt(const QString &input, const bool &stream, const QString &promptTemplate,
                      const QString &systemPrompt, const double &temperature, const int &topK, const double &topP,
                      const double &minP, const double &repeatPenalty, const int &promptBatchSize, const int &maxTokens,
                      const int &repeatPenaltyTokens, const int &contextLength, const int &numberOfGPULayers){}
void Provider::stop(){}
void Provider::loadModel(const QString &model, const QString &key){}
// void Provider::unLoadModel(){}
