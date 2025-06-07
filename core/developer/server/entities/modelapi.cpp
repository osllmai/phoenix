#include "modelapi.h"

ModelAPI::ModelAPI(const QString &scheme, const QString &hostName, int port)
    : CrudAPI(scheme, hostName, port)
{}

QHttpServerResponse ModelAPI::getFullList() const {
    const auto onlineModels = OnlineModelList::instance(nullptr);
    auto* onlineModelInstallFilter = new OnlineModelListFilter(onlineModels, nullptr);
    onlineModelInstallFilter->setFilterType(OnlineModelListFilter::FilterType::InstallModel);

    QJsonArray onlineArray = extractModelsAsJsonArray(onlineModelInstallFilter);

    const auto offlineModels = OfflineModelList::instance(nullptr);
    auto* offlineModelListFinishedDownloadFilter = new OfflineModelListFilter(offlineModels, nullptr);
    offlineModelListFinishedDownloadFilter->setFilterType(OfflineModelListFilter::FilterType::DownloadFinished);

    QJsonArray offlineArray = extractModelsAsJsonArray(offlineModelListFinishedDownloadFilter);

    delete onlineModelInstallFilter;
    delete offlineModelListFinishedDownloadFilter;

    QJsonObject result;
    result["online"] = onlineArray;
    result["offline"] = offlineArray;
    return QHttpServerResponse(result);
}

QHttpServerResponse ModelAPI::getItem(qint64 itemId) const{
    return QHttpServerResponse(QHttpServerResponder::StatusCode::Ok);
}

void ModelAPI::postItem(const QHttpServerRequest &request, QSharedPointer<QHttpServerResponder> responder){
}

QHttpServerResponse ModelAPI::updateItem(qint64 itemId, const QHttpServerRequest &request){
    return QHttpServerResponse(QHttpServerResponder::StatusCode::Ok);
}

QHttpServerResponse ModelAPI::updateItemFields(qint64 itemId, const QHttpServerRequest &request){
    return QHttpServerResponse(QHttpServerResponder::StatusCode::Ok);
}

QHttpServerResponse ModelAPI::deleteItem(qint64 itemId){
    return QHttpServerResponse(QHttpServerResponder::StatusCode::Ok);
}

QJsonArray ModelAPI::extractModelsAsJsonArray(QSortFilterProxyModel* proxyModel) const{
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

        models.append(item);
    }

    return models;
}
