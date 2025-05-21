#include "codegenerator.h"

CodeGenerator::CodeGenerator(QObject* parent)
    : QObject(parent),
    m_stream(true),
    m_promptTemplate("### Human:\n%1\n\n### Assistant:\n"),
    m_systemPrompt("### System:\nYou are an AI assistant who gives a quality response to whatever humans ask of you.\n\n"),
    m_temperature(0.7),
    m_topK(40),
    m_topP(0.4),
    m_minP(0.0),
    m_repeatPenalty(1.18),
    m_promptBatchSize(128),
    m_maxTokens(4096),
    m_repeatPenaltyTokens(64),
    m_contextLength(2048),
    m_numberOfGPULayers(80),
    m_text("")
{}

CodeGenerator::CodeGenerator(const bool &stream,
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
                             QObject *parent)
    : QObject(parent),
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
    m_text("")
{}

CodeGenerator::~CodeGenerator() {}

QString CodeGenerator::text(){
    return postChat();
}

bool CodeGenerator::stream() const{return m_stream;}
void CodeGenerator::setStream(bool newStream){
    if (m_stream == newStream)
        return;
    m_stream = newStream;
    emit streamChanged();
}

QString CodeGenerator::promptTemplate() const{return m_promptTemplate;}
void CodeGenerator::setPromptTemplate(const QString &newPromptTemplate){
    if (m_promptTemplate == newPromptTemplate)
        return;
    m_promptTemplate = newPromptTemplate;
    emit promptTemplateChanged();
}

QString CodeGenerator::systemPrompt() const{return m_systemPrompt;}
void CodeGenerator::setSystemPrompt(const QString &newSystemPrompt){
    if (m_systemPrompt == newSystemPrompt)
        return;
    m_systemPrompt = newSystemPrompt;
    emit systemPromptChanged();
}

double CodeGenerator::temperature() const{return m_temperature;}
void CodeGenerator::setTemperature(double newTemperature){
    if (qFuzzyCompare(m_temperature, newTemperature))
        return;
    m_temperature = newTemperature;
    emit temperatureChanged();
}

int CodeGenerator::topK() const{return m_topK;}
void CodeGenerator::setTopK(int newTopK){
    if (m_topK == newTopK)
        return;
    m_topK = newTopK;
    emit topKChanged();
}

double CodeGenerator::topP() const{return m_topP;}
void CodeGenerator::setTopP(double newTopP){
    if (qFuzzyCompare(m_topP, newTopP))
        return;
    m_topP = newTopP;
    emit topPChanged();
}

double CodeGenerator::minP() const{return m_minP;}
void CodeGenerator::setMinP(double newMinP){
    if (qFuzzyCompare(m_minP, newMinP))
        return;
    m_minP = newMinP;
    emit minPChanged();
}

double CodeGenerator::repeatPenalty() const{return m_repeatPenalty;}
void CodeGenerator::setRepeatPenalty(double newRepeatPenalty){
    if (qFuzzyCompare(m_repeatPenalty, newRepeatPenalty))
        return;
    m_repeatPenalty = newRepeatPenalty;
    emit repeatPenaltyChanged();
}

int CodeGenerator::promptBatchSize() const{return m_promptBatchSize;}
void CodeGenerator::setPromptBatchSize(int newPromptBatchSize){
    if (m_promptBatchSize == newPromptBatchSize)
        return;
    m_promptBatchSize = newPromptBatchSize;
    emit promptBatchSizeChanged();
}

int CodeGenerator::maxTokens() const{return m_maxTokens;}
void CodeGenerator::setMaxTokens(int newMaxTokens){
    if (m_maxTokens == newMaxTokens)
        return;
    m_maxTokens = newMaxTokens;
    emit maxTokensChanged();
}

int CodeGenerator::repeatPenaltyTokens() const{return m_repeatPenaltyTokens;}
void CodeGenerator::setRepeatPenaltyTokens(int newRepeatPenaltyTokens){
    if (m_repeatPenaltyTokens == newRepeatPenaltyTokens)
        return;
    m_repeatPenaltyTokens = newRepeatPenaltyTokens;
    emit repeatPenaltyTokensChanged();
}

int CodeGenerator::contextLength() const{return m_contextLength;}
void CodeGenerator::setContextLength(int newContextLength){
    if (m_contextLength == newContextLength)
        return;
    m_contextLength = newContextLength;
    emit contextLengthChanged();
}

int CodeGenerator::numberOfGPULayers() const{return m_numberOfGPULayers;}
void CodeGenerator::setNumberOfGPULayers(int newNumberOfGPULayers){
    if (m_numberOfGPULayers == newNumberOfGPULayers)
        return;
    m_numberOfGPULayers = newNumberOfGPULayers;
    emit numberOfGPULayersChanged();
}

QString CodeGenerator::getModels(){
    return "GET /v1/models\n";
}

QString CodeGenerator::postChat(){
    return "POST /v1/chat/completions\n";
}
