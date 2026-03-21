#include "modelmanager.h"
#include "modelmanager_icons.h"

QList<int> ModelManager::readOnlineCompany() {
    int indoxRouterId;
    QString indoxRouterName = "Indox Router";
    QString indoxRouterKey = "";
    QDateTime indoxRouterAddDate = QDateTime::currentDateTime();
    bool indoxRouterIsLike = false;

    QSqlQuery query(m_db);
    query.prepare(READ_MODEL_SQL);
    query.addBindValue(indoxRouterName);

    if (query.exec()){
        if (!query.next()) {
            indoxRouterId = insertModel(indoxRouterName, indoxRouterKey);
        } else {
            indoxRouterId = query.value(0).toInt();
            indoxRouterName = query.value(1).toString();
            indoxRouterKey = query.value(2).toString();
            indoxRouterAddDate = query.value(3).toDateTime();
            indoxRouterIsLike = query.value(4).toBool();
        }
    }


    emit addOnlineProvider(indoxRouterId, indoxRouterName,
                           "qrc:/media/image_company/indoxRoter.png",
                           indoxRouterIsLike, BackendType::OnlineModel, "",
                           indoxRouterKey);

    QList<int> allID;
    QString filePath = QString::fromUtf8(APP_PATH) + "/models/online_models/online_models.json";

    bool fileExists = QFile::exists(filePath);

    if (fileExists) {

        QNetworkAccessManager *manager = new QNetworkAccessManager(this);
        QNetworkRequest request(QUrl("https://api.indoxrouter.com/api/v1/models/"));
        QNetworkReply *reply = manager->get(request);

        QObject::connect(reply, &QNetworkReply::finished, [reply, filePath]() {
            if (reply->error() == QNetworkReply::NoError) {
                QByteArray data = reply->readAll();
                QDir().mkpath(QFileInfo(filePath).absolutePath());
                QFile file(filePath);
                if (file.open(QIODevice::WriteOnly)) {
                    file.write(data);
                    file.close();
                }
            } else {
                qWarning() << "Cannot fetch updated online models:" << reply->errorString();
            }
            reply->deleteLater();
        });
    } else {
        QNetworkAccessManager manager;
        QNetworkRequest request(QUrl("https://api.indoxhub.com/api/v1/models/"));
        QNetworkReply *reply = manager.get(request);

        QEventLoop loop;
        QObject::connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
        loop.exec();

        if (reply->error() == QNetworkReply::NoError) {
            QByteArray data = reply->readAll();
            QDir().mkpath(QFileInfo(filePath).absolutePath());
            QFile file(filePath);
            if (file.open(QIODevice::WriteOnly)) {
                file.write(data);
                file.close();
                qInfo() << "Downloaded online models file for the first time.";
            }
        } else {
            qWarning() << "Cannot fetch online models and no cache found!";
        }
        reply->deleteLater();
    }

    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Cannot open JSON file!";
        return allID;
    }

    QByteArray jsonData = file.readAll();
    file.close();

    QJsonDocument doc = QJsonDocument::fromJson(jsonData);
    if (!doc.isArray()) {
        qWarning() << "Invalid JSON format!";
        return allID;
    }

    QJsonArray jsonArray = doc.array();
    for (const QJsonValue &value : jsonArray) {
        if (!value.isObject())
            continue;
        QJsonObject obj = value.toObject();

        QJsonArray modelsArray = obj["text_completions"].toArray();
        if (modelsArray.isEmpty()) {
            continue;
        }

        int id;
        QString name = obj["name"].toString();
        QString key = "";
        QDateTime addDate = QDateTime::currentDateTime();
        bool isLike = false;

        QSqlQuery query(m_db);
        query.prepare(READ_MODEL_SQL);
        query.addBindValue(name);
        if (!query.exec())
            continue;

        if (!query.next()) {
            id = insertModel(name, key);
        } else {
            id = query.value(0).toInt();
            name = query.value(1).toString();
            key = query.value(2).toString();
            addDate = query.value(3).toDateTime();
            isLike = query.value(4).toBool();
        }

        if (id == -1)
            continue;

        QString icon = "";
        QString idLower = name.toLower();

        const auto &icons = onlineProviderIcons();
        bool found = false;
        for (const auto &entry : icons) {
            if (idLower.contains(entry.first)) {
                icon = QString("qrc:/media/image_company/%1").arg(entry.second);
                found = true;
                break;
            }
        }

        if (!found)
            icon = "qrc:/media/image_company/Huggingface.svg";

        emit addOnlineProvider(id, name, icon, isLike, BackendType::OnlineModel,
                               obj["file"].toString(), key);

        allID.append(id);
    }
    return allID;
}
