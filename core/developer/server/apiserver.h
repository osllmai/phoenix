#ifndef APISERVER_H
#define APISERVER_H

#include "type.h"
#include "utils.h"

#include <QtHttpServer/QHttpServer>
#include <QtConcurrent/qtconcurrentrun.h>

#include <optional>

template<typename T, typename = void>
class CrudApi{};

template<typename T>
class CrudApi<T, std::enable_if_t<std::conjunction_v<std::is_base_of<Jsonable, T>,std::is_base_of<Updatable, T>>>>
{
public:
    explicit CrudApi(const IdMap<T> &data, std::unique_ptr<FromJsonFactory<T>> factory)
        : data(data), factory(std::move(factory))
    {}

    QHttpServerResponse getFullList() const {
        QJsonArray allItems;
        for (const auto &item : data)
            allItems.append(item.toJson());
        return QHttpServerResponse(allItems);
    }

    QHttpServerResponse getItem(qint64 itemId) const{
        const auto item = data.find(itemId);
        return item != data.end() ? QHttpServerResponse(item->toJson())
                                  : QHttpServerResponse(QHttpServerResponder::StatusCode::NotFound);
    }

    QHttpServerResponse postItem(const QHttpServerRequest &request){
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

    QHttpServerResponse updateItem(qint64 itemId, const QHttpServerRequest &request){
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

    QHttpServerResponse updateItemFields(qint64 itemId, const QHttpServerRequest &request){
        const std::optional<QJsonObject> json = byteArrayToJsonObject(request.body());
        if (!json)
            return QHttpServerResponse(QHttpServerResponder::StatusCode::BadRequest);

        auto item = data.find(itemId);
        if (item == data.end())
            return QHttpServerResponse(QHttpServerResponder::StatusCode::NoContent);
        item->updateFields(*json);

        return QHttpServerResponse(item->toJson());
    }

    QHttpServerResponse deleteItem(qint64 itemId){
        if (!data.remove(itemId))
            return QHttpServerResponse(QHttpServerResponder::StatusCode::NoContent);
        return QHttpServerResponse(QHttpServerResponder::StatusCode::Ok);
    }

private:
    IdMap<T> data;
    std::unique_ptr<FromJsonFactory<T>> factory;
};

#endif // APISERVER_H
