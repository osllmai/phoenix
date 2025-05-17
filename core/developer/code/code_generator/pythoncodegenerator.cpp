#include "pythoncodegenerator.h"

PythonCodeGenerator::PythonCodeGenerator(QObject* parent)
    : CodeGenerator(parent)
{}

PythonCodeGenerator::PythonCodeGenerator(const bool &stream,
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
                                         QObject *parent)
    : CodeGenerator(stream, promptTemplate, systemPrompt, temperature, topK, topP, minP, repeatPenalty,
                    promptBatchSize, maxTokens, repeatPenaltyTokens, contextLength, numberOfGPULayers, parent)
{}

PythonCodeGenerator::~PythonCodeGenerator() {}

QString PythonCodeGenerator::getModels()
{
    return QString(
        "import requests\n"
        "url = \"http://localhost:1234/v1/models\"\n"
        "headers = {\"Accept\": \"application/json\"}\n"
        "response = requests.get(url, headers=headers)\n"
        "print(response.json())\n"
        );
}

QString PythonCodeGenerator::postChat()
{
    QString body = QString(
                       "{\n"
                       "  \"model\": \"deepseek-r1-distill-qwen-7b\",\n"
                       "  \"messages\": [\n"
                       "    {\"role\": \"system\", \"content\": \"%1\"},\n"
                       "    {\"role\": \"user\", \"content\": \"What day is it today?\"}\n"
                       "  ],\n"
                       "  \"temperature\": %2,\n"
                       "  \"stream\": %3\n"
                       "}"
                       ).arg(m_systemPrompt)
                       .arg(m_temperature)
                       .arg(m_stream ? "True" : "False");

    return QString(
               "import requests\n"
               "import json\n\n"
               "url = \"http://localhost:1234/v1/chat/completions\"\n"
               "headers = {\"Content-Type\": \"application/json\"}\n"
               "data = %1\n"
               "response = requests.post(url, headers=headers, data=json.dumps(data))\n"
               "print(response.json())\n"
               ).arg(body);
}
