#include "provider.h"

Provider::Provider(QObject *parent): QObject(parent) {}

void Provider::prompt(const QString &input){}
void Provider::stop(){}
void Provider::loadModel(const QString &modelPath){}
void Provider::unloadModel(){}
