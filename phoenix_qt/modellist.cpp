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
    auto modelsList = phoenix_databace::readModel();
    _data.reserve(modelsList.size());
    for (auto &model : modelsList) {
        _data << new DataItem{QSharedPointer<Model>{model}};
    }
    readModelFromJSONFile();
}

//*------------------------------------------------------------------------------**************************-----------------------------------------------------------------------------*//
//*------------------------------------------------------------------------------* QAbstractItemModel interface *------------------------------------------------------------------------------*//
int ModelList::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return _data.size();
}

QVariant ModelList::data(const QModelIndex &index, int role = Qt::DisplayRole) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= _data.count())
        return {};

    //The index is valid
    auto row = _data[index.row()];

    switch (static_cast<ChatlRoles>(role)) {
    case IdRole:
        if (row->type != BackendType::LocalModel)
            return {};
        return row->model->id();
    case NameRole:
        if (!row->model.isNull())
            return row->model->name();
        if (!row->provider.isNull())
            return row->provider->name;
    case InformationRole:
        if (!row->model.isNull())
            return row->model->information();
        if (!row->provider.isNull())
            return row->provider->description;
    case FileSizeRole:
        if (row->type != BackendType::LocalModel)
            return {};
        return row->model->fileSize();
    case RamRamrequiredRole:
        if (row->type != BackendType::LocalModel)
            return {};
        return row->model->ramRamrequired();
    case ParametersRole:
        if (row->type != BackendType::LocalModel)
            return {};
        return row->model->parameters();
    case QuantRole:
        if (row->type != BackendType::LocalModel)
            return {};
        return row->model->quant();
    case TypeRole:
        if (row->type != BackendType::LocalModel)
            return {};
        return row->model->type();
    case PromptTemplateRole:
        if (row->type != BackendType::LocalModel)
            return {};
        return row->model->promptTemplate();
    case SystemPromptRole:
        if (row->type != BackendType::LocalModel)
            return {};
        return row->model->systemPrompt();
    case FileNameRole:
        if (row->type != BackendType::LocalModel)
            return {};
        return row->model->fileName();
    case UrlRole:
        if (row->type != BackendType::LocalModel)
            return {};
        return row->model->url();
    case DirectoryPathRole:
        if (row->type != BackendType::LocalModel)
            return {};
        return row->model->directoryPath();
    case IconModelRole:
        if (row->type != BackendType::LocalModel)
            return {};
        return row->model->icon();
    case DownloadPercentRole:
        if (row->type != BackendType::LocalModel)
            return {};
        return row->model->downloadPercent();
    case IsDownloadingRole:
        if (row->type != BackendType::LocalModel)
            return {};
        return row->model->isDownloading();
    case DownloadFinishedRole:
        if (row->type != BackendType::LocalModel)
            return {};
        return row->model->downloadFinished();

    case BackendTypeRole:
        return QVariant::fromValue(row->type);
    }

    return {};
}

QHash<int, QByteArray> ModelList::roleNames() const
{
    // clang-format off
    return {
        {IdRole, "id"},
        {FileSizeRole, "fileSize"},
        {RamRamrequiredRole, "ramRamrequired"},
        {ParametersRole, "parameters"},
        {QuantRole, "quant"},
        {TypeRole, "type"},
        {PromptTemplateRole, "promptTemplate"},
        {SystemPromptRole, "systemPrompt"},
        {NameRole, "name"},
        {InformationRole, "information"},
        {FileNameRole, "fileName"},
        {UrlRole, "url"},
        {DirectoryPathRole, "directoryPath"},
        {IconModelRole, "icon"},
        {DownloadPercentRole, "downloadPercent"},
        {IsDownloadingRole, "isDownloading"},
        {DownloadFinishedRole, "downloadFinished"},
        {BackendTypeRole, "backendType"}
    };
    // clang-format on
}

Qt::ItemFlags ModelList::flags(const QModelIndex &index) const {
    if (!index.isValid())
        return Qt::NoItemFlags;
    return Qt::ItemIsEditable;
}

bool ModelList::setData(const QModelIndex &index, const QVariant &value, int role) {
    auto row  =_data[index.row()];
    if (row->model.isNull())
        return false;

    auto model = row->model;
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

<<<<<<< HEAD
void ModelList::downloadRequest(const int index , QString directoryPath){

    directoryPath.remove("file:///");
=======
void ModelList::downloadRequest(int index, const QString &directoryPath)
{
    auto row  =_data[index];
    if (row->model.isNull())
        return;

    auto model = row->model;
>>>>>>> 584d027 (--wip-- [skip ci])

    model->setDirectoryPath(directoryPath+ "/" + model->fileName());
    model->setIsDownloading(true);

    Download *download = new Download(index, model->url(), model->directoryPath());
    if(downloads.size()<3){
        connect(download, &Download::downloadProgress, this, &ModelList::handleDownloadProgress, Qt::QueuedConnection);
        connect(download, &Download::downloadFinished, this, &ModelList::handleDownloadFinished, Qt::QueuedConnection);
        download->downloadModel();
    }
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
        const int index = _data.size();
        beginInsertRows(QModelIndex(), index, index);
        _data << new DataItem{QSharedPointer<Model>{model}};
        endInsertRows();
        m_currentModelList->addModel(model);
    }
    emit currentModelListChanged();

}

<<<<<<< HEAD
void ModelList::handleDownloadProgress(const int index, const qint64 bytesReceived, const qint64 bytesTotal){

    Model *model = models[index];
=======
void ModelList::handleDownloadProgress(int index, qint64 bytesReceived, qint64 bytesTotal)
{
    auto row  =_data[index];
    if (row->model.isNull())
        return;

    auto model = row->model;

>>>>>>> 584d027 (--wip-- [skip ci])
    qDebug()<<static_cast<double>(bytesReceived)/static_cast<double>(bytesTotal);
    model->setDownloadPercent(static_cast<double>(bytesReceived)/static_cast<double>(bytesTotal));

    updateDownloadProgress();

    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {DownloadPercentRole});

}

<<<<<<< HEAD
void ModelList::handleDownloadFinished(const int index){

    Model *model = models[index];
=======
void ModelList::handleDownloadFinished(int index){
    auto row  =_data[index];
    if (row->model.isNull())
        return;

    auto model = row->model;


>>>>>>> 584d027 (--wip-- [skip ci])
    model->setIsDownloading(false);
    model->setDownloadFinished(true);
    model->setDownloadPercent(0);
    phoenix_databace::updateModelPath(model->id(),model->directoryPath());

    m_currentModelList->addModel(model.data());

    updateDownloadProgress();
    deleteDownloadModel(index);

    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {IsDownloadingRole, DownloadFinishedRole, DownloadPercentRole});
    emit currentModelListChanged();

}

<<<<<<< HEAD
void ModelList::cancelRequest(const int index){

    Model *model = models[index];
    for(int indexSearch =0 ;indexSearch<downloads.size() && indexSearch<3 ;indexSearch++)
=======
void ModelList::cancelRequest(int index){
    auto row  =_data[index];
    if (row->model.isNull())
        return;

    auto model = row->model;


    for(int indexSearch =0 ;indexSearch<downloads.size();indexSearch++)
>>>>>>> 584d027 (--wip-- [skip ci])
        if(downloads[indexSearch]->index() == index)
            downloads[indexSearch]->cancelDownload();
    model->setIsDownloading(false);
    model->setDownloadFinished(false);
    model->setDownloadPercent(0);

    updateDownloadProgress();
    deleteDownloadModel(index);
    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {DownloadFinishedRole, IsDownloadingRole, DownloadPercentRole});

}

void ModelList::deleteRequest(const int index){

    Model *model = models[index];

    model->setIsDownloading(false);
    model->setDownloadFinished(false);
    m_currentModelList->deleteModel(model.data());

    if (model->url() == "") {
        beginRemoveRows(QModelIndex(), index, index);
        delete _data.takeAt(index);
        endRemoveRows();

        //delete from database
        phoenix_databace::deleteModel(model->id());
        // chat->unloadAndDeleteLater();
    } else if (model->directoryPath() != "") {
        QFile file(model->directoryPath());
        if (file.exists()){
            file.remove();
        }
        phoenix_databace::updateModelPath(model->id(),"");
    }

    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {DownloadFinishedRole, IsDownloadingRole});
    emit currentModelListChanged();

}

void ModelList::loadLocalModelsFromJson(QJsonArray jsonArray)
{
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


        auto existingModelIt= std::find_if(_data.begin(),_data.end(),[&modelName](DataItem*item){
            if (item->model.isNull())
                return false;
            return item->model->name() == modelName;
        });

        if (existingModelIt == _data.end()) {
            auto model = phoenix_databace::insertModel(modelName, "");
            if (model != nullptr) {
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

                const int index = _data.size();
                beginInsertRows(QModelIndex(), index, index);
                _data << new DataItem{QSharedPointer<Model>{model}};

                endInsertRows();
            }
        } else {
            auto existingModel = (*existingModelIt)->model;

            existingModel->setFileName(modelFilename);
            existingModel->setFileSize(modelFilesize);
            existingModel->setUrl(url);
            existingModel->setRamRamrequired(ramRamrequired);
            existingModel->setParameters(parameters);
            existingModel->setQuant(quant);
            existingModel->setType(type);
            existingModel->setInformation(description);
            existingModel->setPromptTemplate(promptTemplate);
            existingModel->setSystemPrompt(systemPrompt);
            existingModel->setIcon(icon);
        }
    }

    auto index = static_cast<int>(_data.size()) - 1;

    std::for_each(_data.rbegin(), _data.rend(), [&index, this](DataItem *item){
        if (item->model.isNull())
            return;

        if (item->model->downloadFinished())
            m_currentModelList->addModel(item->model.data());
        else if (item->model->url() == "") {
            deleteRequest(index);
        }

        index--;
    });
}

void ModelList::loadOnlineProvidersFromJson(QJsonArray jsonArray) {
    for (const QJsonValue &value : jsonArray) {
        QJsonObject jsonObj = value.toObject();

        if (jsonObj == QJsonObject{})
            continue;

        auto d = new OnlineProviderData;
        d->name = jsonObj.value("name").toString();
        d->description = jsonObj.value("description").toString();

        _data << new DataItem{QSharedPointer<OnlineProviderData>{d}};
    }

}

void ModelList::readModelFromJSONFile()
{
    QFile file(qApp->applicationDirPath() + "/models.json");
    if (!file.open(QIODevice::ReadOnly)) {
        qFatal() << file.errorString();
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

    if (!document.isObject()) {
        qWarning() << "ERROR: Couldn't parse: Document's root is not json object";
        return;
    }

    auto obj = document.object();
    loadLocalModelsFromJson(obj.value("offlineModels").toArray());
    loadOnlineProvidersFromJson(obj.value("onlineModels").toArray());
}

void ModelList::updateDownloadProgress(){
    double totalBytesDownload = 0;
    double receivedBytesDownload = 0;
    for (auto &&row : _data)
        if (!row->model.isNull()) {
            totalBytesDownload += 1;
            receivedBytesDownload += row->model->downloadPercent();
        }

    if (totalBytesDownload != 0)
        m_downloadProgress = (receivedBytesDownload / totalBytesDownload) * 100;
    else
        m_downloadProgress = 0;

    qInfo() << "m_downloadProgress:  " << m_downloadProgress;
    emit downloadProgressChanged();

}

ModelList::DataItem::DataItem(QSharedPointer<OnlineProviderData> p)
    : type{ModelList::BackendType::OnlineProvider}
    , provider{p}
{}

ModelList::DataItem::DataItem(QSharedPointer<Model> m)
    : type{ModelList::BackendType::LocalModel}
    , model{m}
{}
