#include "model.h"


// Model::Model(const QString &email, const QString &firstName, const QString &lastName,
//            const QUrl &avatarUrl,
//            const QDateTime &createdAt,
//            const QDateTime &updatedAt)
//     : id(nextId()),
//     email(email),
//     firstName(firstName),
//     lastName(lastName),
//     avatarUrl(avatarUrl),
//     createdAt(createdAt),
//     updatedAt(updatedAt)
// {}

// bool Model::update(const QJsonObject &json)
// {
//     if (!json.contains("email") || !json.contains("first_name") || !json.contains("last_name")
//         || !json.contains("avatar"))
//         return false;

//     email = json.value("email").toString();
//     firstName = json.value("first_name").toString();
//     lastName = json.value("last_name").toString();
//     avatarUrl.setPath(json.value("avatar").toString());
//     updateTimestamp();
//     return true;
// }

// void Model::updateFields(const QJsonObject &json)
// {
//     if (json.contains("email"))
//         email = json.value("email").toString();
//     if (json.contains("first_name"))
//         firstName = json.value("first_name").toString();
//     if (json.contains("last_name"))
//         lastName = json.value("last_name").toString();
//     if (json.contains("avatar"))
//         avatarUrl.setPath(json.value("avatar").toString());
//     updateTimestamp();
// }

// QJsonObject Model::toJson() const
// {
//     return QJsonObject{ { "id", id },
//                        { "email", email },
//                        { "first_name", firstName },
//                        { "last_name", lastName },
//                        { "avatar", avatarUrl.toString() },
//                        { "createdAt", createdAt.toString(Qt::ISODateWithMs) },
//                        { "updatedAt", updatedAt.toString(Qt::ISODateWithMs) } };
// }

// void Model::updateTimestamp() { updatedAt = QDateTime::currentDateTimeUtc(); }
