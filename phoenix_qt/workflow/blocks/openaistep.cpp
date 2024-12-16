#include "openaistep.h"

#include "workflowrunner.h"
#include "workflowstepfield.h"

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkReply>
#include <QNetworkRequest>

OpenAIStep::OpenAIStep(WorkFlowRunner *parent)
    : WorkFlowStep{parent, "Open AI"}
{
    _apiKey = createInputField("apiKey");
}

void OpenAIStep::init()
{
    _outputField = parentRunner()->field("output");
}

void OpenAIStep::run()
{
    auto input = parentRunner()->field("input");

    QUrl url("https://api.openai.com/v1/chat/completions");
    QNetworkRequest request(url);

    // Set headers
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Authorization", "Bearer " + _apiKey->value().toString().toUtf8());

    // // Prepare JSON payload
    // QJsonObject json;
    // json["model"] = "gpt-4"; // Replace with your desired model
    // // json["stream"] = true;   // Enable streaming

    // QJsonArray messages;
    // QJsonObject message;
    // message["role"] = "user";
    // message["content"] = input->value().toString();
    // messages.append(message);

    // json["messages"] = messages;

    // clang-format off
    QJsonObject json{
        {"model", "gpt-4o"},
        {"stream", true},
        {"messages", QJsonArray{
                        QJsonObject{
                            {"role", "system"},
                            {"content", "You are a helpful assistant."}
                        },
                        QJsonObject{
                            {"role", "user"},
                            {"content", input->value().toString()}
                        }
                    }
        }
    };
    // clang-format on

    QByteArray requestData = QJsonDocument(json).toJson();

    _reply = networkManager.post(request, requestData);
    connect(_reply, &QNetworkReply::readyRead, this, &OpenAIStep::reply_readyRead);
    connect(_reply, &QNetworkReply::finished, this, &OpenAIStep::reply_finished);
}

bool OpenAIStep::checkReady() const
{
    return !_apiKey->value().toString().isEmpty();
}

void OpenAIStep::reply_readyRead()
{
    while (_reply->canReadLine()) {
        QByteArray line = _reply->readLine().trimmed();
        if (line.startsWith("data: ")) {
            QByteArray jsonData = line.mid(6);
            if (jsonData == "[DONE]") {
                qDebug() << "Stream finished.";
                _reply->deleteLater();
                return;
            }

            QJsonDocument doc = QJsonDocument::fromJson(jsonData);
            if (doc.isObject()) {
                QJsonObject obj = doc.object();
                QString content = obj["choices"]
                                      .toArray()[0]
                                      .toObject()["delta"]
                                      .toObject()["content"]
                                      .toString();
                if (!content.isEmpty()) {
                    qDebug() << "Received content:" << content;

                    _buffer.append(content);
                    _outputField->setValue(_buffer);
                }
            }
        }
    }
}

void OpenAIStep::reply_finished()
{
    if (_reply->error() != QNetworkReply::NoError) {
        qWarning() << "Error:" << _reply->errorString();
    }
    _reply->deleteLater();
    _reply = nullptr;
}
