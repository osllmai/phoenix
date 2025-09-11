#include "crudapi.h"

CrudAPI::CrudAPI(const QString &scheme, const QString &hostName, int port)
    :scheme(scheme), hostName(hostName), port(port)
{}

QString CrudAPI::getScheme() const {
    return scheme;
}

QString CrudAPI::getHostName() const {
    return hostName;
}

int CrudAPI::getPort() const {
    return port;
}

std::optional<QJsonObject> CrudAPI::byteArrayToJsonObject(const QByteArray &arr) {
    QJsonParseError err;
    const auto json = QJsonDocument::fromJson(arr, &err);
    if (err.error || !json.isObject()) {
        qCWarning(logDeveloperView) << "Failed to parse JSON:" << err.errorString();
        return std::nullopt;
    }
    return json.object();
}
