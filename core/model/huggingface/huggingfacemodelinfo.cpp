#include "huggingfacemodelinfo.h"

HuggingfaceModelInfo::HuggingfaceModelInfo(const QString& id, QObject* parent)
    : QObject(parent),
    m_manager(new QNetworkAccessManager(this))
{
    setLoadModelProcess(true);
    setSuccessModelProcess(false);

    connect(m_manager, &QNetworkAccessManager::finished, this, &HuggingfaceModelInfo::onReplyFinished);

    QtConcurrent::run([=]() {
        this->fetchModelInfo(id);
    });

}

HuggingfaceModelInfo::~HuggingfaceModelInfo() {
    if (m_manager) {
        m_manager->deleteLater();
    }
}

void HuggingfaceModelInfo::fetchModelInfo(const QString& id) {
    QUrl url("https://huggingface.co/api/models");
    QNetworkRequest request(url);
    m_manager->get(request);
}

void HuggingfaceModelInfo::onReplyFinished(QNetworkReply *reply) {
    setLoadModelProcess(false);

    if (reply->error() != QNetworkReply::NoError) {
        emit modelLoadFailed(reply->errorString());
        setSuccessModelProcess(false);
        reply->deleteLater();
        reply = nullptr;
        return;
    }

    QByteArray response = reply->readAll();
    reply->deleteLater();

    QJsonDocument doc = QJsonDocument::fromJson(response);

    if (!doc.isObject()) {
        emit modelLoadFailed("Invalid JSON format");
        setSuccessModelProcess(false);
        return;
    }

    QJsonObject obj = doc.object();

    setId(obj["id"].toString());
    setIsPrivate(obj["private"].toBool());
    setPipeline_tag(obj["pipeline_tag"].toString());
    setLibrary_name(obj["library_name"].toString());

    // tags
    QStringList tags;
    for (auto t : obj["tags"].toArray())
        tags << t.toString();
    setTags(tags);

    setDownloads(obj["downloads"].toInt());
    setLikes(obj["likes"].toInt());
    setModelId(obj["modelId"].toString());
    setAuthor(obj["author"].toString());
    setSha(obj["sha"].toString());
    setLastModified(obj["lastModified"].toString());
    setGated(obj["gated"].toBool());
    setDisabled(obj["disabled"].toBool());

    // widgetData
    QVector<WidgetData> widgets;
    for (auto w : obj["widgetData"].toArray()) {
        WidgetData wd;
        wd.text = w.toObject()["text"].toString();
        widgets.append(wd);
    }
    setWidgetData(widgets);

    // config
    ConfigData cfg;
    for (auto a : obj["config"].toObject()["architectures"].toArray())
        cfg.architectures.append(a.toString());
    cfg.model_type = obj["config"].toObject()["model_type"].toString();
    setConfig(cfg);

    // cardData
    CardData cd;
    for (auto bm : obj["cardData"].toObject()["base_model"].toArray())
        cd.base_model.append(bm.toString());
    cd.license = obj["cardData"].toObject()["license"].toString();
    cd.pipeline_tag = obj["cardData"].toObject()["pipeline_tag"].toString();
    cd.library_name = obj["cardData"].toObject()["library_name"].toString();
    for (auto t : obj["cardData"].toObject()["tags"].toArray())
        cd.tags.append(t.toString());
    setCardData(cd);

    // transformersInfo
    TransformersInfo ti;
    ti.auto_model = obj["transformersInfo"].toObject()["auto_model"].toString();
    ti.pipeline_tag = obj["transformersInfo"].toObject()["pipeline_tag"].toString();
    ti.processor = obj["transformersInfo"].toObject()["processor"].toString();
    setTransformersInfo(ti);

    // gguf
    GgufData gg;
    gg.total = obj["gguf"].toObject()["total"].toVariant().toLongLong();
    gg.architecture = obj["gguf"].toObject()["architecture"].toString();
    gg.context_length = obj["gguf"].toObject()["context_length"].toInt();
    gg.chat_template = obj["gguf"].toObject()["chat_template"].toString();
    gg.bos_token = obj["gguf"].toObject()["bos_token"].toString();
    gg.eos_token = obj["gguf"].toObject()["eos_token"].toString();
    setGguf(gg);

    // siblings
    QVector<SiblingFile> siblings;
    for (auto s : obj["siblings"].toArray()) {
        SiblingFile sf;
        sf.rfilename = s.toObject()["rfilename"].toString();
        siblings.append(sf);
    }
    setSiblings(siblings);

    // spaces
    QStringList spaces;
    for (auto sp : obj["spaces"].toArray())
        spaces << sp.toString();
    setSpaces(spaces);

    setCreatedAt(obj["createdAt"].toString());
    setUsedStorage(obj["usedStorage"].toVariant().toLongLong());

    // success finished
    setSuccessModelProcess(true);
    emit modelLoaded();
}

QString HuggingfaceModelInfo::id() const{return m_id;}
void HuggingfaceModelInfo::setId(const QString& newId){
    if (m_id == newId)
        return;
    m_id = newId;
    emit idChanged();
}

bool HuggingfaceModelInfo::isPrivate() const{return m_isPrivate;}
void HuggingfaceModelInfo::setIsPrivate(bool newIsPrivate){
    if (m_isPrivate == newIsPrivate)
        return;
    m_isPrivate = newIsPrivate;
    emit isPrivateChanged();
}

QString HuggingfaceModelInfo::pipeline_tag() const{return m_pipeline_tag;}
void HuggingfaceModelInfo::setPipeline_tag(const QString& newPipeline_tag){
    if (m_pipeline_tag == newPipeline_tag)
        return;
    m_pipeline_tag = newPipeline_tag;
    emit pipeline_tagChanged();
}

QString HuggingfaceModelInfo::library_name() const{return m_library_name;}
void HuggingfaceModelInfo::setLibrary_name(const QString& newLibrary_name){
    if (m_library_name == newLibrary_name)
        return;
    m_library_name = newLibrary_name;
    emit library_nameChanged();
}

QStringList HuggingfaceModelInfo::tags() const{return m_tags;}
void HuggingfaceModelInfo::setTags(const QStringList& newTags){
    m_tags = newTags;
    emit tagsChanged();
}

int HuggingfaceModelInfo::downloads() const{return m_downloads;}
void HuggingfaceModelInfo::setDownloads(int newDownloads){
    if (m_downloads == newDownloads)
        return;
    m_downloads = newDownloads;
    emit downloadsChanged();
}

int HuggingfaceModelInfo::likes() const{return m_likes;}
void HuggingfaceModelInfo::setLikes(int newLikes){
    if (m_likes == newLikes)
        return;
    m_likes = newLikes;
    emit likesChanged();
}

QString HuggingfaceModelInfo::modelId() const{return m_modelId;}
void HuggingfaceModelInfo::setModelId(const QString& newModelId){
    if (m_modelId == newModelId)
        return;
    m_modelId = newModelId;
    emit modelIdChanged();
}

QString HuggingfaceModelInfo::author() const{return m_author;}
void HuggingfaceModelInfo::setAuthor(const QString& newAuthor){
    if (m_author == newAuthor)
        return;
    m_author = newAuthor;
    emit authorChanged();
}

QString HuggingfaceModelInfo::sha() const{return m_sha;}
void HuggingfaceModelInfo::setSha(const QString& newSha){
    if (m_sha == newSha)
        return;
    m_sha = newSha;
    emit shaChanged();
}

QString HuggingfaceModelInfo::lastModified() const{return m_lastModified;}
void HuggingfaceModelInfo::setLastModified(const QString& newLastModified){
    if (m_lastModified == newLastModified)
        return;
    m_lastModified = newLastModified;
    emit lastModifiedChanged();
}

bool HuggingfaceModelInfo::gated() const{return m_gated;}
void HuggingfaceModelInfo::setGated(bool newGated){
    if (m_gated == newGated)
        return;
    m_gated = newGated;
    emit gatedChanged();
}

bool HuggingfaceModelInfo::disabled() const{return m_disabled;}
void HuggingfaceModelInfo::setDisabled(bool newDisabled){
    if (m_disabled == newDisabled)
        return;
    m_disabled = newDisabled;
    emit disabledChanged();
}

QVector<WidgetData> HuggingfaceModelInfo::widgetData() const{return m_widgetData;}
void HuggingfaceModelInfo::setWidgetData(const QVector<WidgetData>& newWidgetData){
    m_widgetData = newWidgetData;
    emit widgetDataChanged();
}

ConfigData HuggingfaceModelInfo::config() const{return m_config;}
void HuggingfaceModelInfo::setConfig(const ConfigData& newConfig){
    m_config = newConfig;
    emit configChanged();
}

CardData HuggingfaceModelInfo::cardData() const{return m_cardData;}
void HuggingfaceModelInfo::setCardData(const CardData& newCardData){
    m_cardData = newCardData;
    emit cardDataChanged();
}

TransformersInfo HuggingfaceModelInfo::transformersInfo() const{return m_transformersInfo;}
void HuggingfaceModelInfo::setTransformersInfo(const TransformersInfo& newTransformersInfo){
    m_transformersInfo = newTransformersInfo;
    emit transformersInfoChanged();
}

GgufData HuggingfaceModelInfo::gguf() const{return m_gguf;}
void HuggingfaceModelInfo::setGguf(const GgufData& newGguf){
    m_gguf = newGguf;
    emit ggufChanged();
}

QVector<SiblingFile> HuggingfaceModelInfo::siblings() const{return m_siblings;}
void HuggingfaceModelInfo::setSiblings(const QVector<SiblingFile>& newSiblings){
    m_siblings = newSiblings;
    emit siblingsChanged();
}

QStringList HuggingfaceModelInfo::spaces() const{return m_spaces;}
void HuggingfaceModelInfo::setSpaces(const QStringList& newSpaces){
    m_spaces = newSpaces;
    emit spacesChanged();
}

QString HuggingfaceModelInfo::createdAt() const{return m_createdAt;}
void HuggingfaceModelInfo::setCreatedAt(const QString& newCreatedAt){
    if (m_createdAt == newCreatedAt)
        return;
    m_createdAt = newCreatedAt;
    emit createdAtChanged();
}

qint64 HuggingfaceModelInfo::usedStorage() const{return m_usedStorage;}
void HuggingfaceModelInfo::setUsedStorage(qint64 newUsedStorage){
    if (m_usedStorage == newUsedStorage)
        return;
    m_usedStorage = newUsedStorage;
    emit usedStorageChanged();
}

bool HuggingfaceModelInfo::getLoadModelProcess() const{return loadModelProcess;}
void HuggingfaceModelInfo::setLoadModelProcess(bool newLoadModelProcess){
    if (loadModelProcess == newLoadModelProcess)
        return;
    loadModelProcess = newLoadModelProcess;
    emit loadModelProcessChanged();
}

bool HuggingfaceModelInfo::getSuccessModelProcess() const{return successModelProcess;}
void HuggingfaceModelInfo::setSuccessModelProcess(bool newSuccessModelProcess){
    if (successModelProcess == newSuccessModelProcess)
        return;
    successModelProcess = newSuccessModelProcess;
    emit successModelProcessChanged();
}
