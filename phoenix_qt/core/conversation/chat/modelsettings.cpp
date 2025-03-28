#include "modelsettings.h"

ModelSettings::ModelSettings(const int &id, QObject *parent ):QObject(parent), m_id(id){}
ModelSettings::ModelSettings(const int &id, const bool &stream, const QString &promptTemplate, const QString &systemPrompt,
                             const double &temperature, const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                             const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                             const int &contextLength, const int &numberOfGPULayers, QObject *parent)
    : QObject(parent),
    m_id(id),
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

ModelSettings::~ModelSettings(){}

const int ModelSettings::id() const{return m_id;}

const bool ModelSettings::stream() const{return m_stream;}
void ModelSettings::setStream(const bool stream){
    if(m_stream == stream)
        return;
    m_stream = stream;
    emit streamChanged();
}

const QString ModelSettings::promptTemplate() const{return m_promptTemplate;}
void ModelSettings::setPromptTemplate(const QString promptTemplate){
    if(m_promptTemplate == promptTemplate)
        return;
    m_promptTemplate = promptTemplate;
    emit promptTemplateChanged();
}

const QString ModelSettings::systemPrompt() const{return m_systemPrompt;}
void ModelSettings::setSystemPrompt(const QString systemPrompt){
    if(m_systemPrompt == systemPrompt)
        return;
    m_systemPrompt = systemPrompt;
    emit systemPromptChanged();
}

const double ModelSettings::temperature() const{return m_temperature;}
void ModelSettings::setTemperature(const double temperature){
    if((m_temperature == temperature) && (temperature<0) && (temperature>2))
        return;
    m_temperature = temperature;
    emit temperatureChanged();
}

const int ModelSettings::topK() const{return m_topK;}
void ModelSettings::setTopK(const int topK){
    if((m_topK == topK) && (topK<0) && (topK>50000))
        return;
    m_topK = topK;
    emit topKChanged();
}

const double ModelSettings::topP() const{return m_topP;}
void ModelSettings::setTopP(const double topP){
    if((m_topP == topP) && (topP<0) && (topP>0))
        return;
    m_topP = topP;
    emit topPChanged();
}

const double ModelSettings::minP() const{return m_minP;}
void ModelSettings::setMinP(const double minP){
    if((m_minP == minP) && (minP<0) && (minP>1))
        return;
    m_minP = minP;
    emit minPChanged();
}

const double ModelSettings::repeatPenalty() const{ return m_repeatPenalty;}
void ModelSettings::setRepeatPenalty(const double repeatPenalty){
    if((m_repeatPenalty == repeatPenalty) && (repeatPenalty<1) && (repeatPenalty>2))
        return;
    m_repeatPenalty = repeatPenalty;
    emit repeatPenaltyChanged();
}

const int ModelSettings::promptBatchSize() const{return m_promptBatchSize;}
void ModelSettings::setPromptBatchSize(const int promptBatchSize){
    if((m_promptBatchSize == promptBatchSize) && (promptBatchSize<1) && (promptBatchSize>128))
        return;
    m_promptBatchSize = promptBatchSize;
    emit promptBatchSizeChanged();
}

const int ModelSettings::maxTokens() const{return m_maxTokens;}
void ModelSettings::setMaxTokens(const int maxTokens){
    if((m_maxTokens == maxTokens) && (maxTokens<100) && (maxTokens>4096))
        return;
    m_maxTokens = maxTokens;
    emit maxTokensChanged();
}

const int ModelSettings::repeatPenaltyTokens() const{return m_repeatPenaltyTokens;}
void ModelSettings::setRepeatPenaltyTokens(const int repeatPenaltyTokens){
    if((m_repeatPenaltyTokens == repeatPenaltyTokens) && (repeatPenaltyTokens<0) && (repeatPenaltyTokens>1))
        return;
    m_repeatPenaltyTokens = repeatPenaltyTokens;
    emit repeatPenaltyTokensChanged();
}

const int ModelSettings::contextLength() const{return m_contextLength;}
void ModelSettings::setContextLength(const int contextLength){
    if((m_contextLength == contextLength) && (contextLength<120) && (contextLength>4096))
        return;
    m_contextLength = contextLength;
    emit contextLengthChanged();
}

const int ModelSettings::numberOfGPULayers() const{return m_numberOfGPULayers;}
void ModelSettings::setNumberOfGPULayers(const int numberOfGPULayers){
    if((m_numberOfGPULayers == numberOfGPULayers) && (numberOfGPULayers<0) && (numberOfGPULayers>100))
        return;
    m_numberOfGPULayers = numberOfGPULayers;
    emit numberOfGPULayersChanged();
}
