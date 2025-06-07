#include "crudapi.h"

CrudAPI::CrudAPI(const QString &scheme, const QString &hostName, int port)
    :scheme(scheme), hostName(hostName), port(port)
{
    qCInfo(logDeveloper) << "CrudAPI constructed with scheme:" << scheme
                         << ", host:" << hostName << ", port:" << port;
}

QString CrudAPI::getScheme() const {
    qCInfo(logDeveloper) << "getScheme called, returning:" << scheme;
    return scheme;
}

QString CrudAPI::getHostName() const {
    qCInfo(logDeveloper) << "getHostName called, returning:" << hostName;
    return hostName;
}

int CrudAPI::getPort() const {
    qCInfo(logDeveloper) << "getPort called, returning:" << port;
    return port;
}

std::optional<QJsonObject> CrudAPI::byteArrayToJsonObject(const QByteArray &arr) {
    qCInfo(logDeveloper) << "byteArrayToJsonObject called with data size:" << arr.size();
    QJsonParseError err;
    const auto json = QJsonDocument::fromJson(arr, &err);
    if (err.error || !json.isObject()) {
        qCWarning(logDeveloper) << "Failed to parse JSON:" << err.errorString();
        return std::nullopt;
    }
    qCInfo(logDeveloper) << "JSON parsed successfully";
    return json.object();
}
