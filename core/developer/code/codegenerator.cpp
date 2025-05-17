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
    m_numberOfGPULayers(80)
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
    m_numberOfGPULayers(numberOfGPULayers)
{}

CodeGenerator::~CodeGenerator() {}

QString CodeGenerator::text() const{
    return m_text;
}

void CodeGenerator::setText(const QString &newText){
    if (m_text != newText) {
        m_text = newText;
        emit textChanged();
    }
}

void CodeGenerator::setStream(const bool stream) {
    m_stream = stream;
}

void CodeGenerator::setPromptTemplate(const QString promptTemplate) {
    m_promptTemplate = promptTemplate;
}

void CodeGenerator::setSystemPrompt(const QString systemPrompt) {
    m_systemPrompt = systemPrompt;
}

void CodeGenerator::setTemperature(const double temperature) {
    m_temperature = temperature;
}

void CodeGenerator::setTopK(const int topK) { m_topK = topK; }

void CodeGenerator::setTopP(const double topP) {
    m_topP = topP;
}

void CodeGenerator::setMinP(const double minP) {
    m_minP = minP;
}

void CodeGenerator::setRepeatPenalty(const double repeatPenalty) {
    m_repeatPenalty = repeatPenalty;
}

void CodeGenerator::setPromptBatchSize(const int promptBatchSize) {
    m_promptBatchSize = promptBatchSize;
}

void CodeGenerator::setMaxTokens(const int maxTokens) {
    m_maxTokens = maxTokens;
}

void CodeGenerator::setRepeatPenaltyTokens(const int repeatPenaltyTokens) {
    m_repeatPenaltyTokens = repeatPenaltyTokens;
}

void CodeGenerator::setContextLength(const int contextLength) {
    m_contextLength = contextLength;
}

void CodeGenerator::setNumberOfGPULayers(const int numberOfGPULayers) {
    m_numberOfGPULayers = numberOfGPULayers;
}

QString CodeGenerator::getModels(){
    return QString("GET /v1/models\n");
}

QString CodeGenerator::postChat(){
    return QString("POST /v1/chat/completions\n");
}
