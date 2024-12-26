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
    QUrl url("https://api.openai.com/v1/chat/completions");
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Authorization", "Bearer " + m_apiKey.toUtf8());

    // clang-format off
    QJsonObject json{
        {"model", "gpt-4"},
        {"stream", true},
        {"messages", QJsonArray{
                         // QJsonObject{
                         //     {"role", "system"},
                         //     {"content", "You are a helpful assistant."}
                         // },
                         QJsonObject{
                             {"role", "user"},
                             {"content", message}
                         }
                     }}
    };

    // clang-format on

    QNetworkReply *reply = networkManager->post(request, QJsonDocument(json).toJson());
    connect(reply, &QNetworkReply::finished, this, &OpenAI::onReplyFinished);
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
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    if (!reply)
        return;

    if (reply->error() == QNetworkReply::NoError) {
        QJsonDocument jsonResponse = QJsonDocument::fromJson(reply->readAll());
        QJsonObject jsonObject = jsonResponse.object();
        QString replyText = jsonObject["choices"]
                                .toArray()
                                .first()
                                .toObject()["message"]
                                .toObject()["content"]
                                .toString();
        qDebug() << "ChatGPT reply:" << replyText;

        Q_EMIT tokenResponse(replyText);
    } else {
        qDebug() << "Error:" << reply->errorString();
    }
    reply->deleteLater();
}
