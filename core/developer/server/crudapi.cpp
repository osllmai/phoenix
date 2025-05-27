#include "crudapi.h"

template<typename T>
CrudApi::CrudApi(const IdMap<T> &data, std::unique_ptr<FromJsonFactory<T>> factory)
    : data(data), factory(std::move(factory))
{}

template<typename T>
QHttpServerResponse CrudApi::getFullList() const {
    QJsonArray allItems;
    for (const auto &item : data)
        allItems.append(item.toJson());
    return QHttpServerResponse(allItems);
}

template<typename T>
QHttpServerResponse CrudApi::getItem(qint64 itemId) const{
    const auto item = data.find(itemId);
    return item != data.end() ? QHttpServerResponse(item->toJson())
                              : QHttpServerResponse(QHttpServerResponder::StatusCode::NotFound);
}

template<typename T>
QHttpServerResponse CrudApi::postItem(const QHttpServerRequest &request){
    const std::optional<QJsonObject> json = byteArrayToJsonObject(request.body());
    if (!json)
        return QHttpServerResponse(QHttpServerResponder::StatusCode::BadRequest);

    const std::optional<T> item = factory->fromJson(*json);
    if (!item)
        return QHttpServerResponse(QHttpServerResponder::StatusCode::BadRequest);
    if (data.contains(item->id))
        return QHttpServerResponse(QHttpServerResponder::StatusCode::AlreadyReported);

    const auto entry = data.insert(item->id, *item);
    return QHttpServerResponse(entry->toJson(), QHttpServerResponder::StatusCode::Created);
}

template<typename T>
QHttpServerResponse CrudApi::updateItem(qint64 itemId, const QHttpServerRequest &request){
    const std::optional<QJsonObject> json = byteArrayToJsonObject(request.body());
    if (!json)
        return QHttpServerResponse(QHttpServerResponder::StatusCode::BadRequest);

    auto item = data.find(itemId);
    if (item == data.end())
        return QHttpServerResponse(QHttpServerResponder::StatusCode::NoContent);
    if (!item->update(*json))
        return QHttpServerResponse(QHttpServerResponder::StatusCode::BadRequest);

    return QHttpServerResponse(item->toJson());
}

template<typename T>
QHttpServerResponse CrudApi::updateItemFields(qint64 itemId, const QHttpServerRequest &request){
    const std::optional<QJsonObject> json = byteArrayToJsonObject(request.body());
    if (!json)
        return QHttpServerResponse(QHttpServerResponder::StatusCode::BadRequest);

    auto item = data.find(itemId);
    if (item == data.end())
        return QHttpServerResponse(QHttpServerResponder::StatusCode::NoContent);
    item->updateFields(*json);

    return QHttpServerResponse(item->toJson());
}

template<typename T>
QHttpServerResponse CrudApi::deleteItem(qint64 itemId){
    if (!data.remove(itemId))
        return QHttpServerResponse(QHttpServerResponder::StatusCode::NoContent);
    return QHttpServerResponse(QHttpServerResponder::StatusCode::Ok);
}
