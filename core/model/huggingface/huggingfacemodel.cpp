#include "huggingfacemodel.h"

#include "huggingfacemodel.h"
#include <QFileInfo>
#include <QRegularExpression>
#include <QDebug>

HuggingfaceModel::HuggingfaceModel(const QString& id,
                                   const int likes,
                                   const int downloads,
                                   const QString& pipelineTag,
                                   const QString& libraryName,
                                   const QStringList& tags,
                                   const QString& createdAt,
                                   QObject* parent)
    : m_id(id),
    m_likes(likes),
    m_downloads(downloads),
    m_pipelineTag(pipelineTag),
    m_libraryName(libraryName),
    m_createdAt(createdAt),
    QObject(parent)
{
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

    //tagVarient
    for (const QString &tag : tags)
        m_tags.append(tag);
}


const QString &HuggingfaceModel::id() const{return m_id;}

const QString &HuggingfaceModel::name() const{return m_name;}

const QString &HuggingfaceModel::icon() const{return m_icon;}

const int HuggingfaceModel::likes() const{return m_likes;}

const int HuggingfaceModel::downloads() const{return m_downloads;}

const QString &HuggingfaceModel::pipelineTag() const{return m_pipelineTag;}

const QString &HuggingfaceModel::libraryName() const{return m_libraryName;}

QVariantList HuggingfaceModel::tags() const{
    return m_tags;
}

QString HuggingfaceModel::createdAt() const{
    if (m_createdAt.isEmpty())
        return QString();

    QDateTime dt = QDateTime::fromString(m_createdAt, Qt::ISODate);

    if (!dt.isValid())
        return m_createdAt;

    return dt.toString("dd MMM yyyy");
}
