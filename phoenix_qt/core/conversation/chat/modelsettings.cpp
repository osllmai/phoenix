#include "modelsettings.h"

ModelSettings::ModelSettings(const int &id, QObject *parent ):QObject(parent), m_id(id){}

ModelSettings::~ModelSettings(){}

//*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
//*----------------------------------------------------------------------------------------* Read Property  *----------------------------------------------------------------------------------------*//
int ModelSettings::id() const{
    return m_id;
}
bool ModelSettings::stream() const{
    return m_stream;
}
QString ModelSettings::promptTemplate() const{
    return m_promptTemplate;
}
QString ModelSettings::systemPrompt() const{
    return m_systemPrompt;
}
double ModelSettings::temperature() const{
    return m_temperature;
}
int ModelSettings::topK() const{
    return m_topK;
}
double ModelSettings::topP() const{
    return m_topP;
}
double ModelSettings::minP() const{
    return m_minP;
}
double ModelSettings::repeatPenalty() const{
    return m_repeatPenalty;
}
int ModelSettings::promptBatchSize() const{
    return m_promptBatchSize;
}
int ModelSettings::maxTokens() const{
    return m_maxTokens;
}
int ModelSettings::repeatPenaltyTokens() const{
    return m_repeatPenaltyTokens;
}
int ModelSettings::contextLength() const{
    return m_contextLength;
}
int ModelSettings::numberOfGPULayers() const{
    return m_numberOfGPULayers;
}
//*--------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//


//*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
//*----------------------------------------------------------------------------------------* Write Property *----------------------------------------------------------------------------------------*//
void ModelSettings::setId(const int id){
    if(m_id == id)
        return;
    m_id = id;
    emit idChanged();
}
void ModelSettings::setStream(const bool stream){
    if(m_stream == stream)
        return;
    m_stream = stream;
    emit streamChanged();
}
void ModelSettings::setPromptTemplate(const QString promptTemplate){
    if(m_promptTemplate == promptTemplate)
        return;
    m_promptTemplate = promptTemplate;
    emit promptTemplateChanged();
}
void ModelSettings::setSystemPrompt(const QString systemPrompt){
    if(m_systemPrompt == systemPrompt)
        return;
    m_systemPrompt = systemPrompt;
    emit systemPromptChanged();
}
void ModelSettings::setTemperature(const double temperature){
    if((m_temperature == temperature) && (temperature<0) && (temperature>2))
        return;
    m_temperature = temperature;
    emit temperatureChanged();
}
void ModelSettings::setTopK(const int topK){
    if((m_topK == topK) && (topK<0) && (topK>50000))
        return;
    m_topK = topK;
    emit topKChanged();
}
void ModelSettings::setTopP(const double topP){
    if((m_topP == topP) && (topP<0) && (topP>0))
        return;
    m_topP = topP;
    emit topPChanged();
}
void ModelSettings::setMinP(const double minP){
    if((m_minP == minP) && (minP<0) && (minP>1))
        return;
    m_minP = minP;
    emit minPChanged();
}
void ModelSettings::setRepeatPenalty(const double repeatPenalty){
    if((m_repeatPenalty == repeatPenalty) && (repeatPenalty<1) && (repeatPenalty>2))
        return;
    m_repeatPenalty = repeatPenalty;
    emit repeatPenaltyChanged();
}
void ModelSettings::setPromptBatchSize(const int promptBatchSize){
    if((m_promptBatchSize == promptBatchSize) && (promptBatchSize<1) && (promptBatchSize>128))
        return;
    m_promptBatchSize = promptBatchSize;
    emit promptBatchSizeChanged();
}
void ModelSettings::setMaxTokens(const int maxTokens){
    if((m_maxTokens == maxTokens) && (maxTokens<100) && (maxTokens>4096))
        return;
    m_maxTokens = maxTokens;
    emit maxTokensChanged();
}
void ModelSettings::setRepeatPenaltyTokens(const int repeatPenaltyTokens){
    if((m_repeatPenaltyTokens == repeatPenaltyTokens) && (repeatPenaltyTokens<0) && (repeatPenaltyTokens>1))
        return;
    m_repeatPenaltyTokens = repeatPenaltyTokens;
    emit repeatPenaltyTokensChanged();
}
void ModelSettings::setContextLength(const int contextLength){
    if((m_contextLength == contextLength) && (contextLength<120) && (contextLength>4096))
        return;
    m_contextLength = contextLength;
    emit contextLengthChanged();
}
void ModelSettings::setNumberOfGPULayers(const int numberOfGPULayers){
    if((m_numberOfGPULayers == numberOfGPULayers) && (numberOfGPULayers<0) && (numberOfGPULayers>100))
        return;
    m_numberOfGPULayers = numberOfGPULayers;
    emit numberOfGPULayersChanged();
}
//*-------------------------------------------------------------------------------------* end Write Property *--------------------------------------------------------------------------------------*//
