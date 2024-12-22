#include "modellist.h"

#include <QtSql>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

ModelList::ModelList(QObject *parent)
    : QAbstractListModel(parent),m_currentModelList(new CurrentModelList(this)), m_downloadProgress(0)
{
    //read from database
    models = phoenix_databace::readModel();
    readModelFromJSONFile();
}

//*------------------------------------------------------------------------------**************************-----------------------------------------------------------------------------*//
//*------------------------------------------------------------------------------* QAbstractItemModel interface *------------------------------------------------------------------------------*//
int ModelList::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return models.size();
}

QVariant ModelList::data(const QModelIndex &index, int role = Qt::DisplayRole) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= models.count())
        return QVariant();

    //The index is valid
    Model* model = models[index.row()];

    switch (role) {
    case IdRole:
        return model->id();
    case FileSizeRole:
        return model->fileSize();
    case RamRamrequiredRole:
        return model->ramRamrequired();
    case ParametersRole:
        return model->parameters();
    case QuantRole:
        return model->quant();
    case TypeRole:
        return model->type();
    case PromptTemplateRole:
        return model->promptTemplate();
    case SystemPromptRole:
        return model->systemPrompt();
    case NameRole:
        return model->name();
    case InformationRole:
        return model->information();
    case FileNameRole:
        return model->fileName();
    case UrlRole:
        return model->url();
    case DirectoryPathRole:
        return model->directoryPath();
    case IconModelRole:
        return model->icon();
    case DownloadPercentRole:
        return model->downloadPercent();
    case IsDownloadingRole:
        return model->isDownloading();
    case DownloadFinishedRole:
        return model->downloadFinished();
    }

    return QVariant();
}

QHash<int, QByteArray> ModelList::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[FileSizeRole] = "fileSize";
    roles[RamRamrequiredRole] = "ramRamrequired";
    roles[ParametersRole] = "parameters";
    roles[QuantRole] = "quant";
    roles[TypeRole] = "type";
    roles[PromptTemplateRole] = "promptTemplate";
    roles[SystemPromptRole] = "systemPrompt";
    roles[NameRole] = "name";
    roles[InformationRole] = "information";
    roles[FileNameRole] = "fileName";
    roles[UrlRole] = "url";
    roles[DirectoryPathRole] = "directoryPath";
    roles[IconModelRole] = "icon";
    roles[DownloadPercentRole] = "downloadPercent";
    roles[IsDownloadingRole] = "isDownloading";
    roles[DownloadFinishedRole] = "downloadFinished";
    return roles;
}

Qt::ItemFlags ModelList::flags(const QModelIndex &index) const {
    if (!index.isValid())
        return Qt::NoItemFlags;
    return Qt::ItemIsEditable;
}

bool ModelList::setData(const QModelIndex &index, const QVariant &value, int role) {
    Model* model = models[index.row()]; // The person to edit
    bool somethingChanged{false};

    switch (role) {
    case IdRole:
        if( model->id()!= value.toInt()){
            model->setId(value.toInt());
            somethingChanged = true;
        }
        break;
    case FileSizeRole:
        if( model->fileSize()!= value.toDouble()){
            model->setFileSize(value.toDouble());
            somethingChanged = true;
        }
        break;
    case RamRamrequiredRole:
        if( model->ramRamrequired()!= value.toInt()){
            model->setRamRamrequired(value.toInt());
            somethingChanged = true;
        }
        break;
    case ParametersRole:
        if( model->parameters()!= value.toString()){
            model->setParameters(value.toString());
            somethingChanged = true;
        }
        break;
    case QuantRole:
        if( model->quant()!= value.toString()){
            model->setQuant(value.toString());
            somethingChanged = true;
        }
        break;
    case TypeRole:
        if( model->type()!= value.toString()){
            model->setType(value.toString());
            somethingChanged = true;
        }
        break;
    case PromptTemplateRole:
        if( model->promptTemplate()!= value.toString()){
            model->setPromptTemplate(value.toString());
            somethingChanged = true;
        }
        break;
    case SystemPromptRole:
        if( model->systemPrompt()!= value.toString()){
            model->setSystemPrompt(value.toString());
            somethingChanged = true;
        }
        break;
    case NameRole:
        if( model->name()!= value.toString()){
            model->setName(value.toString());
            somethingChanged = true;
        }
        break;
    case InformationRole:
        if( model->information()!= value.toString()){
            model->setInformation(value.toString());
            somethingChanged = true;
        }
        break;
    case FileNameRole:
        if( model->fileName()!= value.toString()){
            model->setFileName(value.toString());
            somethingChanged = true;
        }
        break;
    case UrlRole:
        if( model->url()!= value.toString()){
            model->setUrl(value.toString());
            somethingChanged = true;
        }
        break;
    case DirectoryPathRole:
        if( model->directoryPath()!= value.toString()){
            model->setDirectoryPath(value.toString());
            somethingChanged = true;
        }
        break;
    case IconModelRole:
        if( model->icon()!= value.toString()){
            model->setIcon(value.toString());
            somethingChanged = true;
        }
        break;
    case DownloadPercentRole:
        if( model->downloadPercent()!= value.toDouble()){
            model->setDownloadPercent(value.toDouble());
            somethingChanged = true;
        }
        break;
    case IsDownloadingRole:
        if( model->isDownloading()!= value.toBool()){
            model->setIsDownloading(value.toBool());
            somethingChanged = true;
        }
        break;
    case DownloadFinishedRole:
        if( model->downloadFinished()!= value.toBool()){
            model->setDownloadFinished(value.toBool());
            somethingChanged = true;
        }
    }
    if(somethingChanged){
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}
//*---------------------------------------------------------------------------* end QAbstractItemModel interface *----------------------------------------------------------------------------*//


//*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
//*----------------------------------------------------------------------------------------* Read Property  *----------------------------------------------------------------------------------------*//
CurrentModelList *ModelList::currentModelList() const{
    return m_currentModelList;
}
double ModelList::downloadProgress() const{
    return m_downloadProgress;
}
//*--------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//


//*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
//*----------------------------------------------------------------------------------------* Write Property  *----------------------------------------------------------------------------------------*//
void ModelList::setCurrentModelList(CurrentModelList *currentModelList){
    if(m_currentModelList == currentModelList)
        return;
    m_currentModelList = currentModelList;
    emit currentModelListChanged();
}
//*-------------------------------------------------------------------------------------* end Write Property *--------------------------------------------------------------------------------------*//

void ModelList::downloadRequest(const int index , QString directoryPath){
    directoryPath.remove("file:///");

    Model *model = models[index];
    model->setDirectoryPath(directoryPath+ "/" + model->fileName());
    model->setIsDownloading(true);    

    Download *download = new Download(index);
    connect(download, &Download::downloadProgress, this, &ModelList::handleDownloadProgress, Qt::QueuedConnection);
    connect(download, &Download::downloadFinished, this, &ModelList::handleDownloadFinished, Qt::QueuedConnection);
    download->downloadModel(model->url(), model->directoryPath());
    downloads.append(download);

    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {DirectoryPathRole, IsDownloadingRole});
}

void ModelList::addModel(QString directoryPath){
    directoryPath.remove("file:///");

    QFileInfo fileInfo(directoryPath);
    QString fileName = fileInfo.baseName();
    double fileSize = (fileInfo.size()/10000000)*0.01;

    //add from database
    Model *model =phoenix_databace::insertModel(fileName, directoryPath);
    model->setDownloadFinished(true);
    model->setFileSize(fileSize);
    model->setIcon("images/userIcon.svg");
    model->setInformation("This model has been successfully added to the application by you.");
    if(model != nullptr){
        const int index = models.size();
        beginInsertRows(QModelIndex(), index, index);
        models.append(model);
        endInsertRows();
        m_currentModelList->addModel(model);
    }
    emit currentModelListChanged();
}

void ModelList::handleDownloadProgress(const int index, const qint64 bytesReceived, const qint64 bytesTotal){
    Model *model = models[index];
    qDebug()<<static_cast<double>(bytesReceived)/static_cast<double>(bytesTotal);
    model->setDownloadPercent(static_cast<double>(bytesReceived)/static_cast<double>(bytesTotal));

    updateDownloadProgress();

    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {DownloadPercentRole});
}

void ModelList::handleDownloadFinished(const int index){
    Model *model = models[index];
    model->setIsDownloading(false);
    model->setDownloadFinished(true);
    phoenix_databace::updateModelPath(model->id(),model->directoryPath());

    m_currentModelList->addModel(model);

    updateDownloadProgress();

    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {IsDownloadingRole, DownloadFinishedRole});
    emit currentModelListChanged();
}

void ModelList::cancelRequest(const int index){
    Model *model = models[index];
    for(int indexSearch =0 ;indexSearch<downloads.size();indexSearch++)
        if(downloads[indexSearch]->index() == index)
            downloads[indexSearch]->cancelDownload();
    model->setIsDownloading(false);
    model->setDownloadFinished(false);

    updateDownloadProgress();
    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {DownloadFinishedRole, IsDownloadingRole});
}

void ModelList::deleteRequest(const int index){
    Model *model = models[index];
    for(int indexSearch =0 ;indexSearch<downloads.size();indexSearch++)
        if(downloads[indexSearch]->index() == model->id())
            downloads[indexSearch]->removeModel();

    model->setIsDownloading(false);
    model->setDownloadFinished(false);
    m_currentModelList->deleteModel(model);

    if(model->url() == ""){
        const int newIndex = models.indexOf(model);
        beginRemoveRows(QModelIndex(), newIndex, newIndex);
        models.removeAll(model);
        endRemoveRows();

        //delete from database
        phoenix_databace::deleteModel(model->id());
        delete model;

        // chat->unloadAndDeleteLater();
    }else if(model->directoryPath() != ""){
        QFile file(model->directoryPath());
        if (file.exists()){
            file.remove();
        }
        phoenix_databace::updateModelPath(model->id(),"");
    }

    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {DownloadFinishedRole, IsDownloadingRole});
    emit currentModelListChanged();
}


void ModelList::readModelFromJSONFile(){
    QFile file("./models.json");
    if (!file.open(QIODevice::ReadOnly)) {
        qCritical() << file.errorString();
        for(int index=models.size()-1;index>=0;index--){
            if(models[index]->downloadFinished())
                m_currentModelList->addModel(models[index]);
            else if(models[index]->url() == ""){
                deleteRequest(index);
            }
        }
        return;
    }
    QByteArray jsonData = file.readAll();
    file.close();

    QJsonParseError err;
    QJsonDocument document = QJsonDocument::fromJson(jsonData, &err);
    if (err.error != QJsonParseError::NoError) {
        qWarning() << "ERROR: Couldn't parse: " << jsonData << err.errorString();
        return;
    }

    QJsonArray jsonArray = document.array();
    for (const QJsonValue &value : jsonArray) {
        QJsonObject jsonObj = value.toObject();

        QString modelName = jsonObj["name"].toString();
        QString modelFilename = jsonObj["filename"].toString();
        double modelFilesize = jsonObj["filesize"].toString().toDouble();
        QString url = jsonObj["url"].toString();
        int ramRamrequired = jsonObj["ramrequired"].toString().toInt();
        QString parameters = jsonObj["parameters"].toString();
        QString quant = jsonObj["quant"].toString();
        QString type = jsonObj["type"].toString();
        QString description = jsonObj["description"].toString();
        QString promptTemplate = jsonObj["promptTemplate"].toString();
        QString systemPrompt = jsonObj["systemPrompt"].toString();
        QString icon = jsonObj["icon"].toString();

        bool flagExist = false;

        for(int index=0; index<models.size(); index++){
            if(models[index]->name() == modelName){
                models[index]->setFileName(modelFilename);
                models[index]->setFileSize(modelFilesize);
                models[index]->setUrl(url);
                models[index]->setRamRamrequired(ramRamrequired);
                models[index]->setParameters(parameters);
                models[index]->setQuant(quant);
                models[index]->setType(type);
                models[index]->setInformation(description);
                models[index]->setPromptTemplate(promptTemplate);
                models[index]->setSystemPrompt(systemPrompt);
                models[index]->setIcon(icon);
                flagExist = true;
            }
        }

        if(flagExist == false){
            //insert from database
            Model *model = phoenix_databace::insertModel(modelName, "");
            if(model != nullptr){
                model->setFileName(modelFilename);
                model->setFileSize(modelFilesize);
                model->setUrl(url);
                model->setRamRamrequired(ramRamrequired);
                model->setParameters(parameters);
                model->setQuant(quant);
                model->setType(type);
                model->setInformation(description);
                model->setPromptTemplate(promptTemplate);
                model->setSystemPrompt(systemPrompt);
                model->setIcon(icon);

                const int index = models.size();
                beginInsertRows(QModelIndex(), index, index);
                models.append(model);
                endInsertRows();
            }
        }
    }
    for(int index=models.size()-1;index>=0;index--){
        if(models[index]->downloadFinished()){
            if(models[index]->url() == ""){
                QFileInfo fileInfo(models[index]->directoryPath());
                models[index]->setFileSize((fileInfo.size()/10000000)*0.01);
                models[index]->setIcon("images/userIcon.svg");
                models[index]->setInformation("This model has been successfully added to the application by you.");
            }
            m_currentModelList->addModel(models[index]);
        }
        else if(models[index]->url() == ""){
            deleteRequest(index);
        }
    }
}

void ModelList::updateDownloadProgress(){
    double totalBytesDownload =0;
    double receivedBytesDownload =0;
    for(int indexModel=0; indexModel<models.size();indexModel++){
        if(models[indexModel]->isDownloading()){
            totalBytesDownload += 1;
            receivedBytesDownload += models[indexModel]->downloadPercent();
        }
    }
    if(totalBytesDownload != 0)
        m_downloadProgress = (receivedBytesDownload/totalBytesDownload)*100;
    else
        m_downloadProgress = 0;

    qInfo()<<"m_downloadProgress:  "<<m_downloadProgress;
    emit downloadProgressChanged();
}

