#include "modelmanager.h"

void ModelManager::readModel(const QList<Company*> companys){

    QList<int> allID;

    for (Company* company : companys){

        QFile file(QString::fromUtf8(APP_PATH) + "/models/" + company->filePath());

        if (!file.open(QIODevice::ReadOnly)) {
            qWarning() << "Cannot open JSON file!";
            continue;
        }

        QByteArray jsonData = file.readAll();
        file.close();

        QJsonParseError err;
        QJsonDocument document = QJsonDocument::fromJson(jsonData, &err);
        if (err.error != QJsonParseError::NoError) {
            qWarning() << "ERROR: Couldn't parse: " << jsonData << err.errorString();
            continue;
        }

        QJsonArray jsonArray = document.array();

        if (company->backend() == BackendType::OfflineModel) {

            for (const QJsonValue &value : jsonArray) {

                if (!value.isObject()) continue;

                QJsonObject obj = value.toObject();

                int id;
                QString name = obj["name"].toString();
                QString key = "";
                QDateTime addDate = QDateTime::currentDateTime();
                bool isLike = false;

                QSqlQuery query(m_db);
                query.prepare(READ_MODEL_SQL);
                query.addBindValue(obj["name"].toString());

                if (!query.exec())
                    continue;

                bool downloadFinished = false;
                if (!query.next()) {
                    id = insertModel(obj["name"].toString(), "");
                } else {
                    id = query.value(0).toInt();
                    name = query.value(1).toString();
                    key = query.value(2).toString();
                    addDate = query.value(3).toDateTime();
                    isLike = query.value(4).toBool();

                    if (!key.isEmpty() && !QFile::exists(key)){
                        updateKeyModel(id,"");
                        key = "";
                    }else if (!key.isEmpty() && QFile::exists(key)){
                        downloadFinished = true;
                    }
                }

                if (id == -1)
                    continue;

                emit addOfflineModel(company, obj["filesize"].toDouble(), obj["ramrequired"].toInt(),
                                     obj["filename"].toString(), obj["url"].toString(), obj["parameters"].toString(),
                                     obj["quant"].toString(), 0.0, false, downloadFinished,
                                     id, obj["modelName"].toString(), name, key, addDate, isLike,
                                     obj["type"].toString(), BackendType::OfflineModel,
                                     "qrc:/media/image_company/" + company->icon(),
                                     obj["description"].toString(),
                                     obj["promptTemplate"].toString(),
                                     obj["systemPrompt"].toString(),
                                     QDateTime::currentDateTime(),
                                     obj["recommended"].toBool(), "");

                allID.append(id);
            }
        }

    }

    QList<int> existId = readOnlineCompany();
    allID.append(existId);

    emit finishedReadOnlineModel();

    QSqlQuery query(m_db);
    query.prepare(READALL_MODEL_SQL);

    if (query.exec()){
        while(query.next()) {
            bool findIndex = false;
            for(int id : allID){
                if(id == query.value(0).toInt()){
                    findIndex = true;
                    break;
                }
            }
            if(findIndex == false){

                int id = query.value(0).toInt();
                QString name = query.value(1).toString();
                QString key = query.value(2).toString();
                QDateTime addDate = query.value(3).toDateTime();
                bool isLike = query.value(4).toBool();

                QFile file(key);
                if (!file.exists() && (name !="Indox Router")){
                    deleteModel(id);
                }else if(name !="Indox Router"){
                    QFileInfo fileInfo(key);
                    QString icon = "qrc:/media/image_company/phoenix.svg";
                    QString information = "This model has been successfully added to the application by you.";
                    double fileSize = (fileInfo.size()/10000000)*0.01;
                    int ramRequ;
                    if(fileSize<0.6)
                        ramRequ = 1;
                    else if(fileSize <1.5)
                        ramRequ = 2;
                    else if(fileSize <3.0)
                        ramRequ = 4;
                    else if(fileSize <6.0)
                        ramRequ = 8;
                    else if(fileSize <10.0)
                        ramRequ = 16;
                    else
                        ramRequ = 32;

                    emit addOfflineModel(nullptr, fileSize, ramRequ, "", "", "- billion", "q4_0",0.0, false, true,
                                         id, name,  name, key, addDate, isLike, "Text Generation", BackendType::OfflineModel,
                                         icon, information, "","", QDateTime::currentDateTime(), false, "");
                }
            }
        }
    }

    emit finishedReadOfflineModel();
}
