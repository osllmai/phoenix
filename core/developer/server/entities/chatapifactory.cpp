#include "chatapifactory.h"

ChatAPIFactory::ChatAPIFactory(const QString &scheme, const QString &hostName, int port)
    : scheme(scheme), hostName(hostName), port(port)
{}

std::optional<ChatAPI> ChatAPIFactory::fromJson(const QJsonObject &json) const
{
    if (!json.contains("email") || !json.contains("first_name") || !json.contains("last_name")
        || !json.contains("avatar")) {
        return std::nullopt;
    }

    if (json.contains("createdAt") && json.contains("updatedAt")) {
        return ChatAPI(
            json.value("email").toString(), json.value("first_name").toString(),
            json.value("last_name").toString(), json.value("avatar").toString(),
            QDateTime::fromString(json.value("createdAt").toString(), Qt::ISODateWithMs),
            QDateTime::fromString(json.value("updatedAt").toString(), Qt::ISODateWithMs));
    }
    QUrl avatarUrl(json.value("avatar").toString());
    if (!avatarUrl.isValid()) {
        avatarUrl.setPath(json.value("avatar").toString());
    }
    avatarUrl.setScheme(scheme);
    avatarUrl.setHost(hostName);
    avatarUrl.setPort(port);

    return ChatAPI(json.value("email").toString(), json.value("first_name").toString(),
                   json.value("last_name").toString(), avatarUrl);
}
