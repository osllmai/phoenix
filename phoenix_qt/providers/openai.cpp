#include "openai.h"

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QTextStream>

OpenAI::OpenAI(const QString &apiKey, QObject *parent)
    : AbstractChatProvider{parent}
    , networkManager{new QNetworkAccessManager{this}}
    , m_apiKey{apiKey}
{}

void OpenAI::prompt(const QString &message)
{
    if (_reply) {
        _reply->deleteLater();
        _reply = nullptr;
    }
    QUrl url("https://api.openai.com/v1/chat/completions");
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Authorization", "Bearer " + m_apiKey.toUtf8());

    // clang-format off
    QJsonObject json{
        {"model", "gpt-4"},
        {"stream", true},
        {"messages", QJsonArray{
                         QJsonObject{
                             {"role", "user"},
                             {"content", message}
                         }
                     }}
    };

    // clang-format on

    _stopFlag = false;
    _reply = networkManager->post(request, QJsonDocument(json).toJson());
    connect(_reply, &QNetworkReply::finished, this, &OpenAI::onReplyFinished);
    connect(_reply, &QNetworkReply::readyRead, this, &OpenAI::onReplyReadyRead);
    connect(_reply, &QNetworkReply::errorOccurred, this, &OpenAI::onReplyError);
}

void OpenAI::stop()
{
    _stopFlag = true;
}

QString OpenAI::apiKey() const
{
    return m_apiKey;
}

void OpenAI::setApiKey(const QString &newApiKey)
{
    if (m_apiKey == newApiKey)
        return;
    m_apiKey = newApiKey;
    emit apiKeyChanged();
}

void OpenAI::onReplyFinished()
{
    if (_reply->error() == QNetworkReply::NoError) {
        QJsonDocument jsonResponse = QJsonDocument::fromJson(_reply->readAll());
        QJsonObject jsonObject = jsonResponse.object();
        QString replyText = jsonObject["choices"]
                                .toArray()
                                .first()
                                .toObject()["message"]
                                .toObject()["content"]
                                .toString();
        qDebug() << "ChatGPT reply:" << replyText;

        Q_EMIT finishedResponnse();
    } else {
        qDebug() << "Error:" << _reply->errorString();
    }
    _reply->deleteLater();
    _reply = nullptr;
}

void OpenAI::onReplyError(QNetworkReply::NetworkError)
{
    Q_EMIT tokenResponse("Error:" + _reply->errorString());
}

void OpenAI::onReplyReadyRead()
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
