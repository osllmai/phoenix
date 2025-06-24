#include "nodejsaxioscodegenerator.h"

QString NodeJsAxiosCodeGenerator::getModels() {
    return QString("const axios = require('axios');\n"
                   "axios.get('http://localhost:1234/v1/models')\n"
                   "  .then(res => console.log(res.data))\n"
                   "  .catch(err => console.error(err));");
}

QString NodeJsAxiosCodeGenerator::postChat() {
    QString json = QString(R"({
  model: "deepseek-r1-distill-qwen-7b",
  messages: [
    { role: "system", content: "%1" },
    { role: "user", content: "What day is it today?" }
  ],
  temperature: %2,
  max_tokens: %3,
  stream: %4
})").arg(systemPrompt())
                       .arg(temperature())
                       .arg(maxTokens())
                       .arg(stream() ? "true" : "false");

    return QString("const axios = require('axios');\n"
                   "axios.post('http://localhost:1234/v1/chat/completions', %1, {\n"
                   "  headers: { 'Content-Type': 'application/json' }\n"
                   "}).then(res => console.log(res.data))\n"
                   ".catch(err => console.error(err));").arg(json);
}
