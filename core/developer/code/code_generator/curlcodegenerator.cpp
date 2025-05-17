#include "curlcodegenerator.h"

QString CurlCodeGenerator::getModels() {
    return QString("curl http://localhost:1234/v1/models");
}

QString CurlCodeGenerator::postChat() {
    QString json = QString(R"({
  "model": "deepseek-r1-distill-qwen-7b",
  "messages": [
    { "role": "system", "content": "%1" },
    { "role": "user", "content": "What day is it today?" }
  ],
  "temperature": %2,
  "max_tokens": %3,
  "stream": %4
})")
                       .arg(m_systemPrompt)
                       .arg(m_temperature)
                       .arg(m_maxTokens)
                       .arg(m_stream ? "true" : "false");

    return QString("curl http://localhost:1234/v1/chat/completions \\\n"
                   "  -H \"Content-Type: application/json\" \\\n"
                   "  -d '%1'").arg(json);
}
