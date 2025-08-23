#include "huggingfacemodelinfo.h"

HuggingfaceModelInfo::HuggingfaceModelInfo(const QString& id, QObject* parent)
    : QObject(parent),
    m_manager(new QNetworkAccessManager(this)), m_id(id)
{
    setLoadModelProcess(true);
    setSuccessModelProcess(false);

    const QStringList parts = id.split("/");
    if (parts.size() >= 2) {
        QString companyPart = parts.at(0);
        m_name = parts.at(1);
        QString companyLower = companyPart.toLower();

        struct IconMap {
            QString keyword;
            QString iconFile;
        };

        static const QVector<IconMap> icons = {
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
            {"phoenix", "Phoenix.svg"},
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
            if (companyLower.contains(entry.keyword.toLower())) {
                m_icon = QStringLiteral("qrc:/media/image_company/") + entry.iconFile;
                found = true;
                break;
            }
        }

        if (!found) {
            m_icon = QStringLiteral("qrc:/media/image_company/Huggingface.svg");
        }
    } else {
        m_name = id;
        m_icon = QStringLiteral("qrc:/media/image_company/Huggingface.svg");
    }

    connect(m_manager, &QNetworkAccessManager::finished, this, &HuggingfaceModelInfo::onReplyFinished);
}

HuggingfaceModelInfo::~HuggingfaceModelInfo() {
    if (m_manager) {
        m_manager->deleteLater();
    }
}

void HuggingfaceModelInfo::fetchModelInfo() {
        QUrl url(QString("https://huggingface.co/api/models/%1").arg(m_id));
        QNetworkRequest request(url);
        m_manager->get(request);
}

void HuggingfaceModelInfo::onReplyFinished(QNetworkReply *reply) {

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
    setLoadModelProcess(false);
    emit modelLoaded();
}

QString HuggingfaceModelInfo::id() const{return m_id;}
void HuggingfaceModelInfo::setId(const QString& newId){
    if (m_id == newId)
        return;
    m_id = newId;
    emit idChanged();
}

QString HuggingfaceModelInfo::name() const{return m_name;}

QString HuggingfaceModelInfo::icon() const{return m_icon;}

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
    qInfo()<<"setLoadModelProcess: "<<newLoadModelProcess;
    if (loadModelProcess == newLoadModelProcess)
        return;
    loadModelProcess = newLoadModelProcess;
    emit loadModelProcessChanged();
}

bool HuggingfaceModelInfo::getSuccessModelProcess() const{return successModelProcess;}
void HuggingfaceModelInfo::setSuccessModelProcess(bool newSuccessModelProcess){
    qInfo()<<"setSuccessModelProcess: "<< newSuccessModelProcess;
    if (successModelProcess == newSuccessModelProcess)
        return;
    successModelProcess = newSuccessModelProcess;
    emit successModelProcessChanged();
}
