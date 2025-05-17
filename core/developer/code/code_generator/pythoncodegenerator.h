#ifndef PYTHONCODEGENERATOR_H
#define PYTHONCODEGENERATOR_H

#include <QObject>
#include <QQmlEngine>
#include "../codegenerator.h"

class PythonCodeGenerator : public CodeGenerator {
    Q_OBJECT
    QML_ELEMENT

public:
    explicit PythonCodeGenerator(QObject* parent = nullptr);
    explicit PythonCodeGenerator(const bool &stream,
                                 const QString &promptTemplate,
                                 const QString &systemPrompt,
                                 const double &temperature,
                                 const int &topK,
                                 const double &topP,
                                 const double &minP,
                                 const double &repeatPenalty,
                                 const int &promptBatchSize,
                                 const int &maxTokens,
                                 const int &repeatPenaltyTokens,
                                 const int &contextLength,
                                 const int &numberOfGPULayers,
                                 QObject *parent = nullptr);
    virtual ~PythonCodeGenerator();

    QString getModels() override;
    QString postChat() override;
};

#endif // PYTHONCODEGENERATOR_H
