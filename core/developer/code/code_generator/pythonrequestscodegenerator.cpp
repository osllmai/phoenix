#include "pythonrequestscodegenerator.h"

QString PythonRequestsCodeGenerator::getModels() {
    return QString(R"(import requests

try:
    response = requests.get("http://localhost:%1/api/models")
    response.raise_for_status()
    print(response.json())
except requests.exceptions.RequestException as e:
    print("Error:", e))").arg(port());
}

QString PythonRequestsCodeGenerator::postChat() {
    QStringList params;

    params << QString("\"model\": \"%1\"").arg(modelName());
    params << QString("\"messages\": \"Hi dear!\"");
    params << QString("\"promptTemplate\": \"%1\"").arg(escapeForJson(promptTemplate()));
    params << QString("\"systemPrompt\": \"%1\"").arg(escapeForJson(systemPrompt()));
    params << QString("\"stream\": %1").arg(stream() ? "true" : "false");
    params << QString("\"temperature\": %1").arg(temperature());

    if (maxTokensVisible())
        params << QString("\"maxTokens\": %1").arg(maxTokens());
    if (topKVisible())
        params << QString("\"top_k\": %1").arg(topK());
    if (topPVisible())
        params << QString("\"top_p\": %1").arg(topP());
    if (minPVisible())
        params << QString("\"min_p\": %1").arg(minP());
    if (repeatPenaltyVisible())
        params << QString("\"repeat_penalty\": %1").arg(repeatPenalty());
    if (promptBatchSizeVisible())
        params << QString("\"prompt_batch_size\": %1").arg(promptBatchSize());
    if (repeatPenaltyTokensVisible())
        params << QString("\"repeat_penalty_tokens\": %1").arg(repeatPenaltyTokens());
    if (contextLengthVisible())
        params << QString("\"context_length\": %1").arg(contextLength());
    if (numberOfGPULayersVisible())
        params << QString("\"n_gpu_layers\": %1").arg(numberOfGPULayers());

    QString json = QString("{\n  %1\n}").arg(params.join(",\n  "));

    return QString(R"(import requests
import json

data = %1

try:
    response = requests.post(
        "http://localhost:%2/api/chat",
        headers={"Content-Type": "application/json"},
        data=json.dumps(data)
    )
    response.raise_for_status()
    print(response.json())
except requests.exceptions.RequestException as e:
    print("Error:", e))")
        .arg(json)
        .arg(port());
}

