#include "pythonrequestscodegenerator.h"

QString PythonRequestsCodeGenerator::getModels() {
    return QString("import requests\n"
                   "response = requests.get('http://localhost:1234/v1/models')\n"
                   "print(response.json())");
}

QString PythonRequestsCodeGenerator::postChat() {
    QString json = QString(R"({
    "model": "deepseek-r1-distill-qwen-7b",
    "messages": [
        {"role": "system", "content": "%1"},
        {"role": "user", "content": "What day is it today?"}
    ],
    "temperature": %2,
    "max_tokens": %3,
    "stream": %4
})").arg(m_systemPrompt)
                       .arg(m_temperature)
                       .arg(m_maxTokens)
                       .arg(m_stream ? "true" : "false");

    return QString("import requests\n"
                   "url = 'http://localhost:1234/v1/chat/completions'\n"
                   "headers = {'Content-Type': 'application/json'}\n"
                   "data = '''%1'''\n"
                   "response = requests.post(url, headers=headers, data=data)\n"
                   "print(response.json())").arg(json);
}
