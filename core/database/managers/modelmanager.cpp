#include "modelmanager.h"

ModelManager::ModelManager(QSqlDatabase db, QObject* parent)
    : QObject{nullptr}, m_db(db)
{

    if (m_db.isOpen()) {
        QSqlQuery query(m_db);

        QStringList tables = m_db.tables();
        if (!tables.contains("model", Qt::CaseInsensitive)) {
            query.exec(MODEL_SQL);
        }
    } else {
        qDebug() << "Failed to open ModelManager:" << m_db.lastError().text();
    }
}

ModelManager::~ModelManager(){}

const QString ModelManager::MODEL_SQL = QLatin1String(R"(
    CREATE TABLE model(
        id INTEGER NOT NULL UNIQUE,
        name TEXT NOT NULL,
        key TEXT,
        add_model_time DATE,
        isLike BOOL NOT NULL,
        PRIMARY KEY(id AUTOINCREMENT)
    )
)");

const QString ModelManager::INSERT_MODEL_SQL = QLatin1String(R"(
    INSERT INTO model(name, key, add_model_time, isLike) VALUES (?, ?, ?, ?)
)");

const QString ModelManager::READALL_MODEL_SQL = QLatin1String(R"(
    SELECT id, name, key, add_model_time, isLike FROM model
)");

const QString ModelManager::READ_MODEL_SQL = QLatin1String(R"(
    SELECT id, name, key, add_model_time, isLike FROM model WHERE name=?
)");

const QString ModelManager::READ_MODEL_ID_SQL = QLatin1String(R"(
    SELECT id, name, key, add_model_time, isLike FROM model WHERE id=?
)");

const QString ModelManager::UPDATE_KEYMODEL_SQL = QLatin1String(R"(
    UPDATE model SET key=?, add_model_time=? WHERE id=?
)");

const QString ModelManager::UPDATE_ISLIKE_SQL = QLatin1String(R"(
    UPDATE model SET isLike=? WHERE id=?
)");

const QString ModelManager::DELETE_MODEL_SQL = QLatin1String(R"(
    DELETE FROM model WHERE id=?
)");

int ModelManager::insertModel(const QString &name, const QString &key){
    QSqlQuery query(m_db);

    query.prepare(INSERT_MODEL_SQL);
    query.addBindValue(name);
    query.addBindValue(key);
    query.addBindValue(QDateTime::currentDateTime());
    query.addBindValue(false);
    if (!query.exec()){
        return -1;
    }

    return query.lastInsertId().toInt();
}

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

void ModelManager::deleteModel(const int id){
    QSqlQuery query(m_db);

    if (!query.prepare(DELETE_MODEL_SQL))
        return;
    query.addBindValue(id);
    if (!query.exec())
        return;
}

void ModelManager::updateKeyModel(const int id, const QString &key){
    QSqlQuery query(m_db);

    if (!query.prepare(UPDATE_KEYMODEL_SQL))
        return ;
    query.addBindValue(key);
    query.addBindValue(QDateTime::currentDateTime());
    query.addBindValue(id);
    if (!query.exec())
        return;
}

void ModelManager::updateIsLikeModel(const int id, const bool isLike){
    QSqlQuery query(m_db);

    if (!query.prepare(UPDATE_ISLIKE_SQL))
        return ;
    query.addBindValue(isLike);
    query.addBindValue(id);
    if (!query.exec())
        return;
}

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
        QNetworkRequest request(QUrl("https://api.indoxrouter.com/api/v1/models/"));
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

        static const QVector<QPair<QString, QString>> icons = {
            {"adobe", "adobe.svg"},
            {"adobefirefly", "adobefirefly.svg"},
            {"agui", "agui.svg"},
            {"ai21", "ai21.svg"},
            {"ai302", "ai302.svg"},
            {"ai360", "ai360.svg"},
            {"aihubmix", "aihubmix.svg"},
            {"aimass", "aimass.svg"},
            {"aionlabs", "aionlabs.svg"},
            {"aistudio", "aistudio.svg"},
            {"alephalpha", "alephalpha.svg"},
            {"alibaba", "alibaba.svg"},
            {"alibabacloud", "alibabacloud.svg"},
            {"antgroup", "antgroup.svg"},
            {"anthropic", "anthropic.svg"},
            {"aya", "aya.svg"},
            {"azure", "azure.svg"},
            {"azureai", "azureai.svg"},
            {"baai", "baai.svg"},
            {"baichuan", "baichuan.svg"},
            {"baidu", "baidu.svg"},
            {"baiducloud", "baiducloud.svg"},
            {"baseten", "baseten.svg"},
            {"bedrock", "bedrock.svg"},
            {"bert", "Bert.svg"},
            {"bfl", "bfl.svg"},
            {"bigcode", "BigCode.png"},
            {"bilibili", "bilibili.svg"},
            {"bilibiliindex", "bilibiliindex.svg"},
            {"bing", "bing.svg"},
            {"burncloud", "burncloud.svg"},
            {"bytedance", "bytedance.svg"},
            {"centml", "centml.svg"},
            {"cerebras", "cerebras.svg"},
            {"chatglm", "chatglm.svg"},
            {"civitai", "civitai.svg"},
            {"claude", "Claude.svg"},
            {"cline", "cline.svg"},
            {"clipdrop", "clipdrop.svg"},
            {"cloudflare", "cloudflare.svg"},
            {"codegeex", "codegeex.svg"},
            {"cogvideo", "cogvideo.svg"},
            {"cogview", "cogview.svg"},
            {"cohere", "Cohere.svg"},
            {"colab", "colab.svg"},
            {"comfyui", "comfyui.svg"},
            {"commanda", "commanda.svg"},
            {"copilot", "copilot.svg"},
            {"copilotkit", "copilotkit.svg"},
            {"coqui", "coqui.svg"},
            {"coze", "coze.svg"},
            {"crewai", "crewai.svg"},
            {"crusoe", "crusoe.svg"},
            {"cursor", "cursor.svg"},
            {"dalle", "dalle.svg"},
            {"databricks", "Databricks.svg"},
            {"dbrx", "dbrx.svg"},
            {"deepai", "deepai.svg"},
            {"deepinfra", "deepinfra.svg"},
            {"deepmind", "deepmind.svg"},
            {"deepseek", "Deepseek.svg"},
            {"dify", "dify.svg"},
            {"doc2x", "doc2x.svg"},
            {"docsearch", "docsearch.svg"},
            {"dolphin", "dolphin.svg"},
            {"doubao", "doubao.svg"},
            {"dreammachine", "dreammachine.svg"},
            {"elevenlabs", "elevenlabs.svg"},
            {"elevenx", "elevenx.svg"},
            {"exa-color", "exa-color.svg"},
            {"fireworks", "fireworks.svg"},
            {"flowith", "flowith.svg"},
            {"flux", "flux.svg"},
            {"friendli", "friendli.svg"},
            {"gemini", "gemini.svg"},
            {"gemma", "gemma.svg"},
            {"giteeai", "giteeai.svg"},
            {"githubcopilot", "githubcopilot.svg"},
            {"glama", "glama.svg"},
            {"glif", "glif.svg"},
            {"glmv", "glmv.svg"},
            {"google", "Google.svg"},
            {"goose", "goose.svg"},
            {"gradio", "gradio.svg"},
            {"greptile", "greptile.svg"},
            {"grok", "grok.svg"},
            {"groq", "groq.svg"},
            {"hailuo", "hailuo.svg"},
            {"haiper", "haiper.svg"},
            {"hedra", "hedra.svg"},
            {"higress", "higress.svg"},
            {"huggingface", "Huggingface.svg"},
            {"hunyuan", "hunyuan.svg"},
            {"hyperbolic", "hyperbolic.svg"},
            {"ibm", "ibm.svg"},
            {"ideogram", "ideogram.svg"},
            {"iflytekcloud", "iflytekcloud.svg"},
            {"inference", "inference.svg"},
            {"infermatic", "infermatic.svg"},
            {"infinigence", "infinigence.svg"},
            {"inflection", "inflection.svg"},
            {"internlm", "internlm.svg"},
            {"jimeng", "jimeng.svg"},
            {"jina", "jina.svg"},
            {"kera", "kera.svg"},
            {"kimi", "kimi.svg"},
            {"kling", "kling.svg"},
            {"kluster", "kluster.svg"},
            {"kolors", "kolors.svg"},
            {"lambda", "lambda.svg"},
            {"langchain", "langchain.svg"},
            {"langfuse", "langfuse.svg"},
            {"langgraph", "langgraph.svg"},
            {"langsmith", "langsmith.svg"},
            {"lepton", "lepton.svg"},
            {"lg", "lg.svg"},
            {"lightricks", "lightricks.svg"},
            {"liquid", "liquid.svg"},
            {"livekit", "livekit.svg"},
            {"llamaindex", "llamaindex.svg"},
            {"llava", "llava.svg"},
            {"lmstudio", "lmstudio.svg"},
            {"lobehub", "lobehub.svg"},
            {"lovable", "lovable.svg"},
            {"luma", "luma.svg"},
            {"magic", "magic.svg"},
            {"make", "make.svg"},
            {"manus", "manus.svg"},
            {"mastra", "mastra.svg"},
            {"mcp", "mcp.svg"},
            {"mcpso", "mcpso.svg"},
            {"menlo", "menlo.svg"},
            {"meta", "Meta.svg"},
            {"metaai", "metaai.svg"},
            {"metagpt", "metagpt.svg"},
            {"microsoft", "Microsoft.svg"},
            {"midjourney", "midjourney.svg"},
            {"minimax", "minimax.svg"},
            {"mistral", "Mistral.svg"},
            {"modelscope", "modelscope.svg"},
            {"monica", "monica.svg"},
            {"moonshot", "moonshot.svg"},
            {"mpt", "MPT.svg"},
            {"myshell", "myshell.svg"},
            {"n8n", "n8n.svg"},
            {"nebius", "nebius.svg"},
            {"notebooklm", "notebooklm.svg"},
            {"notion", "notion.svg"},
            {"nousresearch", "nousresearch.svg"},
            {"nova", "nova.svg"},
            {"novelai", "novelai.svg"},
            {"novita", "novita.svg"},
            {"nplcloud", "nplcloud.svg"},
            {"nvidia", "Nvidia.svg"},
            {"ollama", "ollama.svg"},
            {"openai", "Openai.svg"},
            {"openchat", "openchat.svg"},
            {"openrouter", "openrouter.svg"},
            {"openwebui", "openwebui.svg"},
            {"palm", "palm.svg"},
            {"parasail", "parasail.svg"},
            {"perplexity", "perplexity.svg"},
            {"phidata", "phidata.svg"},
            {"phind", "phind.svg"},
            {"phoenix", "phoenix.svg"},
            {"pika", "pika.svg"},
            {"pixverse", "pixverse.svg"},
            {"player2", "player2.svg"},
            {"poe", "poe.svg"},
            {"pollinations", "pollinations.svg"},
            {"ppio", "ppio.svg"},
            {"pydanticai", "pydanticai.svg"},
            {"qingyan", "qingyan.svg"},
            {"qiniu", "qiniu.svg"},
            {"qwen", "Qwen.svg"},
            {"railway", "railway.svg"},
            {"recraft", "recraft.svg"},
            {"replicate", "replicate.svg"},
            {"replit", "Replit.svg"},
            {"rsshub", "rsshub.svg"},
            {"runway", "runway.svg"},
            {"rwkv", "rwkv.svg"},
            {"sambanova", "sambanova.svg"},
            {"search1api", "search1api.svg"},
            {"searchapi", "searchapi.svg"},
            {"sensenova", "sensenova.svg"},
            {"siliconcloud", "siliconcloud.svg"},
            {"skywork", "skywork.svg"},
            {"smithery", "smithery.svg"},
            {"snowflake", "snowflake.svg"},
            {"spark", "spark.svg"},
            {"stability", "stability.svg"},
            {"starcoder", "Starcoder.svg"},
            {"statecloud", "statecloud.svg"},
            {"stepfun", "stepfun.svg"},
            {"suno", "suno.svg"},
            {"sync", "sync.svg"},
            {"targon", "targon.svg"},
            {"tavily", "tavily.svg"},
            {"tencent", "tencent.svg"},
            {"tencentcloud", "tencentcloud.svg"},
            {"tiangong", "tiangong.svg"},
            {"tii", "tii.svg"},
            {"together", "together.svg"},
            {"topazlabs", "topazlabs.svg"},
            {"trae", "trae.svg"},
            {"tripo", "tripo.svg"},
            {"udio", "udio.svg"},
            {"unstructured", "unstructured.svg"},
            {"upstage", "upstage.svg"},
            {"user", "user.svg"},
            {"v0", "v0.svg"},
            {"vectorizerai", "vectorizerai.svg"},
            {"vercel", "vercel.svg"},
            {"vertexai", "vertexai.svg"},
            {"vidu", "vidu.svg"},
            {"viggle", "viggle.svg"},
            {"vllm", "vllm.svg"},
            {"volcengine", "volcengine.svg"},
            {"voyage", "voyage.svg"},
            {"wenxin", "wenxin.svg"},
            {"whisper", "Whisper.svg"},
            {"windsurf", "windsurf.svg"},
            {"workersai", "workersai.svg"},
            {"xai", "xai.svg"},
            {"xinference", "xinference.svg"},
            {"xuanyuan", "xuanyuan.svg"},
            {"yandex", "yandex.svg"},
            {"yi", "yi.svg"},
            {"youmind", "youmind.svg"},
            {"yuanbao", "yuanbao.svg"},
            {"zai", "zai.svg"},
            {"zapier", "zapier.svg"},
            {"zeabur", "zeabur.svg"},
            {"zeroone", "zeroone.svg"},
            {"zhipu", "zhipu.svg"}
        };

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
