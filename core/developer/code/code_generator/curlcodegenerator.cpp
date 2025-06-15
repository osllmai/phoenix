#include "curlcodegenerator.h"

QString CurlCodeGenerator::getModels() {
    return QString("curl http://localhost:1234/v1/models");
}

QString CurlCodeGenerator::postChat() {
    QStringList params;

    params << QString("\"model\": \"deepseek-r1-distill-qwen-7b\"");
    params << QString("\"messages\": ["
                      "{ \"role\": \"system\", \"content\": \"%1\" },"
                      "{ \"role\": \"user\", \"content\": \"What day is it today?\" }"
                      "]").arg(m_systemPrompt);
    params << QString("\"temperature\": %1").arg(m_temperature);
    params << QString("\"max_tokens\": %1").arg(m_maxTokens);
    params << QString("\"stream\": %1").arg(m_stream ? "true" : "false");

    qInfo()<<"***************m_repeatPenaltyTokensVisible"<<m_repeatPenaltyTokensVisible;

    if (m_topKVisible)
        params << QString("\"top_k\": %1").arg(m_topK);
    if (m_topPVisible)
        params << QString("\"top_p\": %1").arg(m_topP);
    if (m_minPVisible)
        params << QString("\"min_p\": %1").arg(m_minP);
    if (m_repeatPenaltyVisible)
        params << QString("\"repeat_penalty\": %1").arg(m_repeatPenalty);
    if (m_promptBatchSizeVisible)
        params << QString("\"prompt_batch_size\": %1").arg(m_promptBatchSize);
    if (m_repeatPenaltyTokensVisible)
        params << QString("\"repeat_penalty_tokens\": %1").arg(m_repeatPenaltyTokens);
    if (m_contextLengthVisible)
        params << QString("\"context_length\": %1").arg(m_contextLength);
    if (m_numberOfGPULayersVisible)
        params << QString("\"n_gpu_layers\": %1").arg(m_numberOfGPULayers);

    QString json = QString("{\n  %1\n}").arg(params.join(",\n  "));

    return QString("curl http://localhost:1234/v1/chat/completions \\\n"
                   "  -H \"Content-Type: application/json\" \\\n"
                   "  -d '%1'").arg(json);
}
