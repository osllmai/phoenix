#include "nerdtoken.h"

#include <QJsonArray>
#include <QJsonObject>
#include <QNetworkRequest>

NerdToken::NerdToken(QObject *parent)
    : AbstractChatProvider{parent}
    , networkManager{new QNetworkAccessManager{this}}
{}

QString NerdToken::apiKey() const
{
    return m_apiKey;
}

void NerdToken::setApiKey(const QString &newApiKey)
{
    if (m_apiKey == newApiKey)
        return;
    m_apiKey = newApiKey;
    emit apiKeyChanged();
}

void NerdToken::prompt(const QString &input)
{
    if (_reply) {
        _reply->deleteLater();
        _reply = nullptr;
    }
    QUrl url("https://api-token.nerdstudio.ai/v1/api/text_generation/generate/");
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Authorization", "Bearer " + m_apiKey.toUtf8());

    // clang-format off
    QJsonObject json{
        {"model", "gpt-4o-mini"},
        {"presence_penalty", 0},
        {"stream", true},
        {"temperature", 0.3},
        {"top_p", 1},
        {"model", m_modelName},
        {"stream", true},
        {"messages", QJsonArray{
                            QJsonObject{
                                {"role", "user"},
                                {"content", input}
                            }
                     }
        }
    };
    // clang-format on

    _stopFlag = false;
    _reply = networkManager->post(request, QJsonDocument(json).toJson());
    connect(_reply, &QNetworkReply::finished, this, &OpenAI::onReplyFinished);
    connect(_reply, &QNetworkReply::readyRead, this, &OpenAI::onReplyReadyRead);
    connect(_reply, &QNetworkReply::errorOccurred, this, &OpenAI::onReplyError);
}

void NerdToken::stop()
{
    _stopFlag = true;
}

QString NerdToken::modelName() const
{
    return m_modelName;
}

void NerdToken::setModelName(const QString &newModelName)
{
    if (m_modelName == newModelName)
        return;
    m_modelName = newModelName;
    emit modelNameChanged();
}

void NerdToken::onReplyFinished() {}

void NerdToken::onReplyError(QNetworkReply::NetworkError) {}

void NerdToken::onReplyReadyRead()
{
    if (_stopFlag) {
        _reply->abort();
        return;
    }

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

                    Q_EMIT tokenResponse(content);
                }
            }
        }
    }
}
