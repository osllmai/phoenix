#include "nodejsaxioscodegenerator.h"

QString NodeJsAxiosCodeGenerator::getModels() {
    return QString(R"(const axios = require("axios");

axios.get("http://localhost:%1/api/models")
  .then(response => {
    console.log(response.data);
  })
  .catch(error => {
    console.error("Error:", error);
  });)").arg(port());
}

QString NodeJsAxiosCodeGenerator::postChat() {
    QStringList params;

    params << QString("\"model\": \"%1\"").arg(modelName());
    params << QString("\"message\": \"Hi dear!\"");
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

    return QString(R"(const axios = require("axios");

const data = %1;

axios.post("http://localhost:%2/api/chat", data, {
  headers: {
    "Content-Type": "application/json"
  }
})
.then(response => {
  console.log(response.data);
})
.catch(error => {
  console.error("Error:", error);
});)")
        .arg(json)
        .arg(port());
}

