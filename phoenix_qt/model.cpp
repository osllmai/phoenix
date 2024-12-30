#include "model.h"

#include <QFile>

Model::Model(const QJsonObject &obj, QObject *parent)
    : QObject{parent}
{}

Model::Model(int id,
             double fileSize,
             int ramRamrequired,
             const QString &name,
             const QString &information,
             const QString &fileName,
             const QString &url,
             const QString &directoryPath,
             const QString &parameters,
             const QString &quant,
             const QString &type,
             const QString &promptTemplate,
             const QString &systemPrompt,
             const QString &icon,
             double downloadPercent,
             bool isDownloading,
             bool downloadFinished,
             QObject *parent)
    : m_id(id)
    , m_fileSize(fileSize)
    , m_ramRamrequired(ramRamrequired)
    , m_name(name)
    , m_information(information)
    , m_fileName(fileName)
    , m_url(url)
    , m_directoryPath(directoryPath)
    , m_parameters(parameters)
    , m_quant(quant)
    , m_type(type)
    , m_promptTemplate(promptTemplate)
    , m_systemPrompt(systemPrompt)
    , m_icon(icon)
    , m_downloadPercent(downloadPercent)
    , m_isDownloading(isDownloading)
    , m_downloadFinished(downloadFinished)
    , QObject(parent)
{}

Model::~Model(){
    qInfo()<<"------------------------------------------------------ this model delete: "<<m_name;
}

//*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
//*----------------------------------------------------------------------------------------* Read Property  *----------------------------------------------------------------------------------------*//
int Model::id() const{
    return m_id;
}

double Model::fileSize() const{
    return m_fileSize;
}

int Model::ramRamrequired() const{
    return m_ramRamrequired;
}

QString Model::parameters() const{
    return m_parameters;
}

QString Model::quant() const{
    return m_quant;
}

QString Model::type() const{
    return m_type;
}

QString Model::promptTemplate() const{
    return m_promptTemplate;
}

QString Model::systemPrompt() const{
    return m_systemPrompt;
}

QString Model::name() const{
    return m_name;
}

QString Model::information() const{
    return m_information;
}

QString Model::fileName() const{
    return m_fileName;
}

QString Model::url() const{
    return m_url;
}

QString Model::directoryPath() const{
    return m_directoryPath;
}

QString Model::icon() const{
    return m_icon;
}

double Model::downloadPercent() const{
    return m_downloadPercent;
}

bool Model::isDownloading() const{
    return m_isDownloading;
}

bool Model::downloadFinished() const{
    return m_downloadFinished;
}
//*--------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//


//*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
//*----------------------------------------------------------------------------------------* Write Property *----------------------------------------------------------------------------------------*//
void Model::setId(const int id){
    if(m_id == id)
        return;
    m_id = id;
    emit idChanged(m_id);
}

void Model::setFileSize(const double fileSize){
    if(m_fileSize == fileSize)
        return;
    m_fileSize = fileSize;
    emit fileSizeChanged(m_fileSize);
}

void Model::setRamRamrequired(const int ramRamrequired){
    if(m_ramRamrequired == ramRamrequired)
        return;
    m_ramRamrequired = ramRamrequired;
    emit ramRamrequiredChanged(m_ramRamrequired);
}

void Model::setParameters(const QString parameters){
    if(m_parameters == parameters)
        return;
    m_parameters = parameters;
    emit parametersChanged(m_parameters);
}

void Model::setQuant(const QString quant){
    if(m_quant == quant)
        return;
    m_quant = quant;
    emit quantChanged(m_quant);
}

void Model::setType(const QString type){
    if(m_type == type)
        return;
    m_type = type;
    emit typeChanged(m_type);
}

void Model::setPromptTemplate(const QString promptTemplate){
    if(m_promptTemplate == promptTemplate)
        return;
    m_promptTemplate = promptTemplate;
    emit promptTemplateChanged(m_promptTemplate);
}

void Model::setSystemPrompt(const QString systemPrompt){
    if(m_systemPrompt == systemPrompt)
        return;
    m_systemPrompt = systemPrompt;
    emit systemPromptChanged(m_systemPrompt);
}

void Model::setIcon(const QString icon){
    if(m_icon == icon)
        return;
    m_icon = icon;
    emit iconChanged(m_icon);
}

void Model::setName(const QString name){
    if(m_name == name)
        return;
    m_name = name;
    emit nameChanged(m_name);
}

void Model::setInformation(const QString information){
    if(m_information == information)
        return;
    m_information = information;
    emit informationChanged(m_information);
}

void Model::setFileName(const QString fileName){
    if(m_fileName == fileName)
        return;
    m_fileName = fileName;
    emit fileNameChanged(m_fileName);
}

void Model::setUrl(const QString url){
    if(m_url == url)
        return;
    m_url = url;
    emit urlChanged(m_url);
}

void Model::setDirectoryPath(const QString directoryPath){
    if(m_directoryPath == directoryPath)
        return;
    m_directoryPath = directoryPath;
    emit directoryPathChanged(m_directoryPath);
}

void Model::setDownloadPercent(const double downloadPercent){
    if(m_downloadPercent == downloadPercent)
        return;
    m_downloadPercent = downloadPercent;
    emit downloadPercentChanged(m_downloadPercent);
}

void Model::setIsDownloading(const bool isDownloading){
    if(m_isDownloading == isDownloading)
        return;
    m_isDownloading = isDownloading;
    emit isDownloadingChanged(m_isDownloading);
}

void Model::setDownloadFinished(const bool downloadFinished){
    if(m_downloadFinished == downloadFinished)
        return;
    m_downloadFinished = downloadFinished;
    emit downloadFinishedChanged(m_downloadFinished);
}
//*-------------------------------------------------------------------------------------* end Write Property *--------------------------------------------------------------------------------------*//

Model::BackendType Model::backendType() const
{
    return m_backendType;
}

void Model::setBackendType(BackendType newBackendType)
{
    if (m_backendType == newBackendType)
        return;
    m_backendType = newBackendType;
    emit backendTypeChanged();
}

QString Model::apiKey() const
{
    return m_apiKey;
}

void Model::setApiKey(const QString &newApiKey)
{
    if (m_apiKey == newApiKey)
        return;
    m_apiKey = newApiKey;
    emit apiKeyChanged();
}

bool Model::isReady() const {
    switch (m_backendType) {
    case Model::BackendType::LocalModel:
        return !m_directoryPath.isEmpty() && !m_fileName.isEmpty()
               && QFile::exists(m_directoryPath + "/" + m_fileName);
    case Model::BackendType::OnlineProvider:
        return !m_apiKey.isEmpty();
    }
    return false;
}

QString Model::modelFilePath() const
{
    if (m_backendType == BackendType::LocalModel) {
        return m_directoryPath + "/" + m_fileName;
    }
    return {};
}
