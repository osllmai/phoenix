#include "codegenerator.h"

CodeGenerator::CodeGenerator(QObject* parent)
    : QObject(parent),
    m_modelName("Openai/gpt-4o"),
    m_port(8080),
    m_stream(true),
    m_promptTemplate(QStringLiteral("### Human:\n%1\n\n### Assistant:\n")),
    m_systemPrompt(QStringLiteral("### System:\nYou are an AI assistant who gives a quality response to whatever humans ask of you.\n\n")),
    m_temperature(0.8),
    m_topK(650),
    m_topP(1.5),
    m_minP(1.5),
    m_repeatPenalty(1.5),
    m_promptBatchSize(100),
    m_maxTokens(4096),
    m_repeatPenaltyTokens(0.8),
    m_contextLength(2048),
    m_numberOfGPULayers(80),
    m_text(""),
    m_topKVisible(false),
    m_topPVisible(false),
    m_minPVisible(false),
    m_repeatPenaltyVisible(false),
    m_promptBatchSizeVisible(false),
    m_maxTokensVisible(false),
    m_repeatPenaltyTokensVisible(false),
    m_contextLengthVisible(false),
    m_numberOfGPULayersVisible(false)
{}

CodeGenerator::CodeGenerator(const QString &modelName,
                             const quint16 newPort,
                             const bool &stream,
                             const QString &promptTemplate,
                             const QString &systemPrompt,
                             const double &temperature,
                             const int &topK,
                             const double &topP,
                             const double &minP,
                             const double &repeatPenalty,
                             const int &promptBatchSize,
                             const int &maxTokens,
                             const int &repeatPenaltyTokens,
                             const int &contextLength,
                             const int &numberOfGPULayers,
                             const bool &topKVisible,
                             const bool &topPVisible,
                             const bool &minPVisible,
                             const bool &repeatPenaltyVisible,
                             const bool &promptBatchSizeVisible,
                             const bool &maxTokensVisible,
                             const bool &repeatPenaltyTokensVisible,
                             const bool &contextLengthVisible,
                             const bool &numberOfGPULayersVisible,
                             QObject *parent)
    : QObject(parent),
    m_modelName(modelName),
    m_port(newPort),
    m_stream(stream),
    m_promptTemplate(promptTemplate),
    m_systemPrompt(systemPrompt),
    m_temperature(temperature),
    m_topK(topK),
    m_topP(topP),
    m_minP(minP),
    m_repeatPenalty(repeatPenalty),
    m_promptBatchSize(promptBatchSize),
    m_maxTokens(maxTokens),
    m_repeatPenaltyTokens(repeatPenaltyTokens),
    m_contextLength(contextLength),
    m_numberOfGPULayers(numberOfGPULayers),
    m_text(""),
    m_topKVisible(topKVisible),
    m_topPVisible(topPVisible),
    m_minPVisible(minPVisible),
    m_repeatPenaltyVisible(repeatPenaltyVisible),
    m_promptBatchSizeVisible(promptBatchSizeVisible),
    m_maxTokensVisible(maxTokensVisible),
    m_repeatPenaltyTokensVisible(repeatPenaltyTokensVisible),
    m_contextLengthVisible(contextLengthVisible),
    m_numberOfGPULayersVisible(numberOfGPULayersVisible)
{}

CodeGenerator::~CodeGenerator() {}

QString CodeGenerator::text(){
    return postChat();
}

QString CodeGenerator::modelName() const{return m_modelName;}
void CodeGenerator::setModelName(const QString &newModelName){
    if (m_modelName == newModelName)
        return;
    m_modelName = newModelName;
    emit textChanged();
    emit modelNameChanged();
}

quint16 CodeGenerator::port() const{return m_port;}
void CodeGenerator::setPort(quint16 newPort){
    if (m_port == newPort)
        return;
    m_port = newPort;
    emit textChanged();
    emit portChanged();
}

bool CodeGenerator::stream() const{return m_stream;}
void CodeGenerator::setStream(bool newStream){
    if (m_stream == newStream)
        return;
    m_stream = newStream;
    emit streamChanged();
    emit textChanged();
}

QString CodeGenerator::promptTemplate() {return escapeForJson(m_promptTemplate);}
void CodeGenerator::setPromptTemplate(const QString &newPromptTemplate){
    if (m_promptTemplate == newPromptTemplate)
        return;
    m_promptTemplate = newPromptTemplate;
    emit promptTemplateChanged();
    emit textChanged();
}

QString CodeGenerator::systemPrompt() {return escapeForJson(m_systemPrompt);}
void CodeGenerator::setSystemPrompt(const QString &newSystemPrompt){
    if (m_systemPrompt == newSystemPrompt)
        return;
    m_systemPrompt = newSystemPrompt;
    emit systemPromptChanged();
    emit textChanged();
}

double CodeGenerator::temperature() const{return m_temperature;}
void CodeGenerator::setTemperature(double newTemperature){
    if (qFuzzyCompare(m_temperature, newTemperature))
        return;
    m_temperature = newTemperature;
    emit temperatureChanged();
    emit textChanged();
}

int CodeGenerator::topK() const{return m_topK;}
void CodeGenerator::setTopK(int newTopK){
    if (m_topK == newTopK)
        return;
    m_topK = newTopK;
    emit topKChanged();
    setTopKVisible(true);
    emit textChanged();
}

double CodeGenerator::topP() const{return m_topP;}
void CodeGenerator::setTopP(double newTopP){
    if (qFuzzyCompare(m_topP, newTopP))
        return;
    m_topP = newTopP;
    emit topPChanged();
    setTopPVisible(true);
    emit textChanged();
}

double CodeGenerator::minP() const{return m_minP;}
void CodeGenerator::setMinP(double newMinP){
    if (qFuzzyCompare(m_minP, newMinP))
        return;
    m_minP = newMinP;
    emit minPChanged();
    setMinPVisible(true);
    emit textChanged();
}

double CodeGenerator::repeatPenalty() const{return m_repeatPenalty;}
void CodeGenerator::setRepeatPenalty(double newRepeatPenalty){
    if (qFuzzyCompare(m_repeatPenalty, newRepeatPenalty))
        return;
    m_repeatPenalty = newRepeatPenalty;
    emit repeatPenaltyChanged();
    setRepeatPenaltyVisible(true);
    emit textChanged();
}

int CodeGenerator::promptBatchSize() const{return m_promptBatchSize;}
void CodeGenerator::setPromptBatchSize(int newPromptBatchSize){
    if (m_promptBatchSize == newPromptBatchSize)
        return;
    m_promptBatchSize = newPromptBatchSize;
    emit promptBatchSizeChanged();
    setPromptBatchSizeVisible(true);
    emit textChanged();
}

int CodeGenerator::maxTokens() const{return m_maxTokens;}
void CodeGenerator::setMaxTokens(int newMaxTokens){
    if (m_maxTokens == newMaxTokens)
        return;
    m_maxTokens = newMaxTokens;
    emit maxTokensChanged();
    setMaxTokensVisible(true);
    emit textChanged();
}

double CodeGenerator::repeatPenaltyTokens() const{return m_repeatPenaltyTokens;}
void CodeGenerator::setRepeatPenaltyTokens(double newRepeatPenaltyTokens){
    if (m_repeatPenaltyTokens == newRepeatPenaltyTokens)
        return;
    m_repeatPenaltyTokens = newRepeatPenaltyTokens;
    emit repeatPenaltyTokensChanged();
    setRepeatPenaltyTokensVisible(true);
    emit textChanged();
}

int CodeGenerator::contextLength() const{return m_contextLength;}
void CodeGenerator::setContextLength(int newContextLength){
    if (m_contextLength == newContextLength)
        return;
    m_contextLength = newContextLength;
    emit contextLengthChanged();
    setContextLengthVisible(true);
    emit textChanged();
}

int CodeGenerator::numberOfGPULayers() const{return m_numberOfGPULayers;}
void CodeGenerator::setNumberOfGPULayers(int newNumberOfGPULayers){
    if (m_numberOfGPULayers == newNumberOfGPULayers)
        return;
    m_numberOfGPULayers = newNumberOfGPULayers;
    emit numberOfGPULayersChanged();
    setNumberOfGPULayersVisible(true);
    emit textChanged();
}

bool CodeGenerator::topKVisible() const{return m_topKVisible;}
void CodeGenerator::setTopKVisible(bool newTopKVisible){
    if (m_topKVisible == newTopKVisible)
        return;
    m_topKVisible = newTopKVisible;
    emit topKVisibleChanged();
}

bool CodeGenerator::topPVisible() const{return m_topPVisible;}
void CodeGenerator::setTopPVisible(bool newTopPVisible){
    if (m_topPVisible == newTopPVisible)
        return;
    m_topPVisible = newTopPVisible;
    emit topPVisibleChanged();
}

bool CodeGenerator::minPVisible() const{return m_minPVisible;}
void CodeGenerator::setMinPVisible(bool newMinPVisible){
    if (m_minPVisible == newMinPVisible)
        return;
    m_minPVisible = newMinPVisible;
    emit minPVisibleChanged();
}

bool CodeGenerator::repeatPenaltyVisible() const{return m_repeatPenaltyVisible;}
void CodeGenerator::setRepeatPenaltyVisible(bool newRepeatPenaltyVisible){
    if (m_repeatPenaltyVisible == newRepeatPenaltyVisible)
        return;
    m_repeatPenaltyVisible = newRepeatPenaltyVisible;
    emit repeatPenaltyVisibleChanged();
}

bool CodeGenerator::promptBatchSizeVisible() const{return m_promptBatchSizeVisible;}
void CodeGenerator::setPromptBatchSizeVisible(bool newPromptBatchSizeVisible){
    if (m_promptBatchSizeVisible == newPromptBatchSizeVisible)
        return;
    m_promptBatchSizeVisible = newPromptBatchSizeVisible;
    emit promptBatchSizeVisibleChanged();
}

bool CodeGenerator::maxTokensVisible() const{return m_maxTokensVisible;}
void CodeGenerator::setMaxTokensVisible(bool newMaxTokensVisible){
    if (m_maxTokensVisible == newMaxTokensVisible)
        return;
    m_maxTokensVisible = newMaxTokensVisible;
    emit maxTokensVisibleChanged();
}

bool CodeGenerator::repeatPenaltyTokensVisible() const{ return m_repeatPenaltyTokensVisible;}
void CodeGenerator::setRepeatPenaltyTokensVisible(bool newRepeatPenaltyTokensVisible){
    if (m_repeatPenaltyTokensVisible == newRepeatPenaltyTokensVisible)
        return;
    m_repeatPenaltyTokensVisible = newRepeatPenaltyTokensVisible;
    emit repeatPenaltyTokensVisibleChanged();
}

bool CodeGenerator::contextLengthVisible() const{return m_contextLengthVisible;}
void CodeGenerator::setContextLengthVisible(bool newContextLengthVisible){
    if (m_contextLengthVisible == newContextLengthVisible)
        return;
    m_contextLengthVisible = newContextLengthVisible;
    emit contextLengthVisibleChanged();
}

bool CodeGenerator::numberOfGPULayersVisible() const{return m_numberOfGPULayersVisible;}
void CodeGenerator::setNumberOfGPULayersVisible(bool newNumberOfGPULayersVisible){
    if (m_numberOfGPULayersVisible == newNumberOfGPULayersVisible)
        return;
    m_numberOfGPULayersVisible = newNumberOfGPULayersVisible;
    emit numberOfGPULayersVisibleChanged();
}

QString CodeGenerator::getModels(){
    return "GET /v1/models\n";
}

QString CodeGenerator::postChat(){
    return "POST /v1/chat/completions\n";
}

QString CodeGenerator::escapeForJson(const QString& input) {
    QString escaped = input;
    escaped.replace("\\n", "__TEMP_NEWLINE__");
    escaped.replace("\\r", "__TEMP_RETURN__");

    escaped.replace("\n", "\\n");
    escaped.replace("\r", "\\r");

    escaped.replace("__TEMP_NEWLINE__", "\\n");
    escaped.replace("__TEMP_RETURN__", "\\r");
    return escaped;
}

