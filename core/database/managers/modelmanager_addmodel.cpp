#include "modelmanager.h"

void ModelManager::addModel(const QString &name, const QString &key){
    int id = insertModel(name, key);
    if(id == -1)
        return;

    QSqlQuery query(m_db);
    query.prepare(READ_MODEL_ID_SQL);
    query.addBindValue(id);

    if (!query.exec())
        return;

    if (query.next()) {

        id = query.value(0).toInt();
        QString name = query.value(1).toString();
        QString key = query.value(2).toString();
        QDateTime addDate = query.value(3).toDateTime();
        bool isLike = query.value(4).toBool();

        QFileInfo fileInfo(key);
        double fileSize = (fileInfo.size()/10000000)*0.01;
        QString icon = "phoenix.svg";
        QString information = "This model has been successfully added to the application by you.";
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

        emit addOfflineModel(nullptr, fileSize, ramRequ, "", "", "- bilion", "q4_0",0.0, false, true,
                             id, name, name, key, addDate, isLike, "Text Generation", BackendType::OfflineModel,
                             "qrc:/media/image_company/"+icon, information, "","", QDateTime::currentDateTime(), false, "");

    }
}

void ModelManager::addHuggingfaceModel(const QString &name, const QString &url, const QString& type,
                                   const QString &companyName, const QString &companyIconPath, const QString &currentFolder) {

    // Ensure models directory exists
    QString modelsDir = QString::fromUtf8(APP_PATH) + "/models";
    QDir dir(modelsDir);
    if (!dir.exists())
        dir.mkpath(".");

    QString companyIcon = QFileInfo(companyIconPath).fileName();

    // --- Step 1: Check if the company exists in company.json ---
    QString companyFilePath = modelsDir + "/company.json";
    QJsonArray companyArray;

    {
        QFile companyFile(companyFilePath);
        if (companyFile.exists() && companyFile.open(QIODevice::ReadOnly)) {
            QJsonDocument doc = QJsonDocument::fromJson(companyFile.readAll());
            if (doc.isArray())
                companyArray = doc.array();
            companyFile.close();
        }
    }

    bool companyExists = false;
    for (const QJsonValue &val : companyArray) {
        if (!val.isObject()) continue;
        QJsonObject obj = val.toObject();
        if (obj["name"].toString().compare(QFileInfo(companyName).fileName(), Qt::CaseInsensitive) == 0 &&
            obj["type"].toString() == "OfflineModel") {
            companyExists = true;
            break;
        }
    }

    // If company does not exist, add it
    QString companyJsonFileName = "offline_models/" + QFileInfo(companyName).fileName().toLower() + ".json";
    if (!companyExists) {
        QJsonObject newCompany;
        newCompany["name"] = QFileInfo(companyName).fileName();
        newCompany["organizationName"] = QFileInfo(companyName).fileName();
        newCompany["icon"] = companyIcon;
        newCompany["file"] = companyJsonFileName;
        newCompany["type"] = "OfflineModel";

        companyArray.append(newCompany);

        QFile companyFile(companyFilePath);
        if (companyFile.open(QIODevice::WriteOnly)) {
            companyFile.write(QJsonDocument(companyArray).toJson(QJsonDocument::Indented));
            companyFile.close();
        }
    }

    QString cleanName = name;
    if (cleanName.endsWith(".gguf", Qt::CaseInsensitive)) {
        cleanName.chop(5);
    }

    // --- Step 2: Add the model to the company's JSON file ---
    QString companyModelsPath = modelsDir + "/" + companyJsonFileName;
    QJsonArray modelsArray;
    {
        QFile modelFile(companyModelsPath);
        if (modelFile.exists() && modelFile.open(QIODevice::ReadOnly)) {
            QJsonDocument doc = QJsonDocument::fromJson(modelFile.readAll());
            if (doc.isArray())
                modelsArray = doc.array();
            modelFile.close();
        }
    }

    // Check if model already exists
    bool modelExists = false;
    for (const QJsonValue &val : modelsArray) {
        if (!val.isObject()) continue;
        QJsonObject obj = val.toObject();
        if (obj["modelName"].toString() == cleanName) {
            modelExists = true;
            break;
        }
    }

    // If model does not exist, add it
    if (!modelExists) {
        QJsonObject newModel;

        // ---- newModel ----
        newModel["name"]          = cleanName;
        newModel["modelName"]     = cleanName;
        newModel["url"]           = url;
        newModel["filesize"]      = 0.0;
        newModel["ramrequired"]   = 1;
        newModel["filename"]      = name;
        newModel["parameters"]    = "- billion";
        newModel["quant"]         = "q4_0";
        newModel["type"]          = type;
        newModel["description"]   = "You have added this model from the HuggingFace list to your collection.";
        newModel["promptTemplate"]= "";
        newModel["systemPrompt"]  = "";
        newModel["recommended"]   = false;

        modelsArray.append(newModel);

        QFile modelFile(companyModelsPath);
        if (modelFile.open(QIODevice::WriteOnly)) {
            modelFile.write(QJsonDocument(modelsArray).toJson(QJsonDocument::Indented));
            modelFile.close();
        }

        // --- Step 3: Insert model into DB and emit signal ---
        int id = insertModel(cleanName, ""); // Empty key since it's an offline model
        if (id == -1) return;

        QDateTime addDate = QDateTime::currentDateTime();
        bool isLike = false;
        QString information = newModel["description"].toString();

        emit addOfflineModel(
            nullptr,                               // Company*
            newModel["filesize"].toDouble(),       // fileSize
            newModel["ramrequired"].toInt(),       // ramRamrequired
            newModel["filename"].toString(),       // fileName
            newModel["url"].toString(),            // url
            newModel["parameters"].toString(),     // parameters
            newModel["quant"].toString(),          // quant
            0.0,                                   // downloadPercent
            false,                                 // isDownloading
            false,                                 // downloadFinished
            id,                                    // id
            newModel["modelName"].toString(),      // modelName
            newModel["name"].toString(),           // name
            "",                                    // key (empty for offline)
            addDate,                               // addModelTime
            isLike,                                // isLike
            newModel["type"].toString(),           // type
            BackendType::OfflineModel,             // backend
            "qrc:/media/image_company/"+companyIcon,                           // icon
            information,                           // information
            newModel["promptTemplate"].toString(), // promptTemplate
            newModel["systemPrompt"].toString(),   // systemPrompt
            QDateTime::currentDateTime(),          // expireModelTime
            newModel["recommended"].toBool(),       // recommended
            currentFolder
            );
        emit finishedAddModel(newModel["filename"].toString());
    }
}
