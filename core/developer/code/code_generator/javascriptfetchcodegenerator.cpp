#include "javascriptfetchcodegenerator.h"

QString JavascriptFetchCodeGenerator::getModels() {
    return QString("fetch('http://localhost:1234/v1/models')\n"
                   "  .then(res => res.json())\n"
                   "  .then(console.log)\n"
                   "  .catch(console.error);");
}

QString JavascriptFetchCodeGenerator::postChat() {
    QString json = QString(R"({
  "model": "deepseek-r1-distill-qwen-7b",
  "messages": [
    { "role": "system", "content": "%1" },
    { "role": "user", "content": "What day is it today?" }
  ],
  "temperature": %2,
  "max_tokens": %3,
  "stream": %4
})").arg(systemPrompt())
                       .arg(temperature())
                       .arg(maxTokens())
                       .arg(stream() ? "true" : "false");

    return QString("fetch('http://localhost:1234/v1/chat/completions', {\n"
                   "  method: 'POST',\n"
                   "  headers: { 'Content-Type': 'application/json' },\n"
                   "  body: `%1`\n"
                   "})\n"
                   "  .then(res => res.json())\n"
                   "  .then(console.log)\n"
                   "  .catch(console.error);").arg(json);
}
