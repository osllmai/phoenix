#include "modelapi.h"

ModelAPI::ModelAPI(const QString &scheme, const QString &hostName, int port)
    : CrudAPI(scheme, hostName, port)
{
    qCInfo(logDeveloper) << "ModelAPI constructed with scheme:" << scheme << ", host:" << hostName << ", port:" << port;
}

QHttpServerResponse ModelAPI::getFullList() const {
    qCInfo(logDeveloper) << "GET Request";

    const auto onlineModels = OnlineModelList::instance(nullptr);
    auto* onlineModelInstallFilter = new OnlineModelListFilter(onlineModels, nullptr);
    onlineModelInstallFilter->setFilterType(OnlineModelListFilter::FilterType::InstallModel);
    qCInfo(logDeveloper) << "Online model install filter created and filter type set";

    QJsonArray onlineArray = extractModelsAsJsonArray(onlineModelInstallFilter);
    qCInfo(logDeveloper) << "Extracted" << onlineArray.size() << "online models";

    const auto offlineModels = OfflineModelList::instance(nullptr);
    auto* offlineModelListFinishedDownloadFilter = new OfflineModelListFilter(offlineModels, nullptr);
    offlineModelListFinishedDownloadFilter->setFilterType(OfflineModelListFilter::FilterType::DownloadFinished);
    qCInfo(logDeveloper) << "Offline model download finished filter created and filter type set";

    QJsonArray offlineArray = extractModelsAsJsonArray(offlineModelListFinishedDownloadFilter);
    qCInfo(logDeveloper) << "Extracted" << offlineArray.size() << "offline models";

    delete onlineModelInstallFilter;
    delete offlineModelListFinishedDownloadFilter;
    qCInfo(logDeveloper) << "Filters deleted";

    QJsonObject result;
    result["online"] = onlineArray;
    result["offline"] = offlineArray;

    qCInfo(logDeveloper) << "Returning full list response with online and offline models";
    return QHttpServerResponse(result);
}

QHttpServerResponse ModelAPI::getItem(qint64 itemId) const{
    qCInfo(logDeveloper) << "GET-Item Request";
    return QHttpServerResponse(QHttpServerResponder::StatusCode::Ok);
}

void ModelAPI::postItem(const QHttpServerRequest &request, QSharedPointer<QHttpServerResponder> responder){
    qCInfo(logDeveloper) << "POST Request" ;
    // No implementation yet
}

QHttpServerResponse ModelAPI::updateItem(qint64 itemId, const QHttpServerRequest &request){
    qCInfo(logDeveloper) << "UPDATE-Item Request";
    return QHttpServerResponse(QHttpServerResponder::StatusCode::Ok);
}

QHttpServerResponse ModelAPI::updateItemFields(qint64 itemId, const QHttpServerRequest &request){
    qCInfo(logDeveloper) << "UPDATE-Item Request";
    return QHttpServerResponse(QHttpServerResponder::StatusCode::Ok);
}

QHttpServerResponse ModelAPI::deleteItem(qint64 itemId){
    qCInfo(logDeveloper) << "DELETE-Item Request";
    return QHttpServerResponse(QHttpServerResponder::StatusCode::Ok);
}

QJsonArray ModelAPI::extractModelsAsJsonArray(QSortFilterProxyModel* proxyModel) const{
    qCInfo(logDeveloper) << "extractModelsAsJsonArray() called, rows";

    QJsonArray models;

    for (int row = 0; row < proxyModel->rowCount(); ++row) {
        QModelIndex index = proxyModel->index(row, 0);

        QJsonObject item;
        item["name"] = proxyModel->data(index, Qt::UserRole + 2).toString();          // NameRole
        item["information"] = proxyModel->data(index, Qt::UserRole + 4).toString();   // InformationRole
        item["type"] = proxyModel->data(index, Qt::UserRole + 8).toString();          // TypeRole
        item["contextWindows"] = proxyModel->data(index, Qt::UserRole + 9).toString();// ContextWindowsRole
        item["output"] = proxyModel->data(index, Qt::UserRole + 10).toString();       // OutputRole
        item["commercial"] = proxyModel->data(index, Qt::UserRole + 11).toBool();     // CommercialRole

        qCInfo(logDeveloper) << "Model extracted:" << item["name"].toString();

        models.append(item);
    }

    qCInfo(logDeveloper) << "extractModelsAsJsonArray() finished, total models:" << models.size();

    return models;
}
