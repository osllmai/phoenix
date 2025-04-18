#include "offlinemodellist.h"

#include <algorithm>

#include "../../conversation/conversationlist.h"

OfflineModelList* OfflineModelList::m_instance = nullptr;

OfflineModelList* OfflineModelList::instance(QObject* parent) {
    if (!m_instance) {
        m_instance = new OfflineModelList(parent);
    }
    return m_instance;
}

OfflineModelList::OfflineModelList(QObject* parent): QAbstractListModel(parent) {}

int OfflineModelList::count() const{return m_models.count();}

int OfflineModelList::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return m_models.count();
}

QVariant OfflineModelList::data(const QModelIndex &index, int role = Qt::DisplayRole) const{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_models.count())
        return QVariant();

    OfflineModel* model = m_models[index.row()];

    switch (role) {
    case IdRole:
        return model->id();
    case NameRole:
        return model->name();
    case InformationRole:
        return model->information();
    case IconRole:
        return model->icon();
    case CompanyRole:
        return QVariant::fromValue(m_models[index.row()]->company());
    case IsLikeRole:
        return model->isLike();
    case AddModelTimeRole:
        return model->addModelTime();
    case FileSizeRole:
        return model->fileSize();
    case RamRamrequiredRole:
        return model->ramRamrequired();
    case ParametersRole:
        return model->parameters();
    case QuantRole:
        return model->quant();
    case DownloadFinishedRole:
        return model->downloadFinished();
    case IsDownloadingRole:
        return model->isDownloading();
    case DownloadPercentRole:
        return model->downloadPercent();
    case ModelObjectRole:
        return QVariant::fromValue(m_models[index.row()]);
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> OfflineModelList::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[NameRole] = "name";
    roles[InformationRole] = "information";
    roles[IconRole] = "icon";
    roles[CompanyRole] = "company";
    roles[IsLikeRole] = "isLike";
    roles[AddModelTimeRole] = "addModelTime";
    roles[FileSizeRole] = "fileSize";
    roles[RamRamrequiredRole] = "ramRamrequired";
    roles[ParametersRole] = "parameters";
    roles[QuantRole] = "quant";
    roles[DownloadFinishedRole] = "downloadFinished";
    roles[IsDownloadingRole] = "isDownloading";
    roles[DownloadPercentRole] = "downloadPercent";
    roles[ModelObjectRole] = "modelObject";
    return roles;
}

bool OfflineModelList::setData(const QModelIndex &index, const QVariant &value, int role) {
    OfflineModel* model = m_models[index.row()]; // The person to edit
    bool somethingChanged{false};

    switch (role) {
    case IsLikeRole:
        if( model->isLike()!= value.toBool()){
            model->setIsLike(value.toBool());
            somethingChanged = true;
        }
        break;
    }
    if(somethingChanged){
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}

OfflineModel* OfflineModelList::at(int index) const{
    if (index < 0 || index >= m_models.count())
        return nullptr;
    return m_models.at(index);
}

double OfflineModelList::downloadProgress() const{return m_downloadProgress;}

void OfflineModelList::likeRequest(const int id, const bool isLike){
    emit requestUpdateIsLikeModel(id, isLike);
}

void OfflineModelList::downloadRequest(const int id, QString directoryPath){
    OfflineModel* model = findModelById(id);
    if(model == nullptr) return;
    const int index = m_models.indexOf(model);

    directoryPath.remove("file:///");

    model->setKey(directoryPath+ "/" + model->fileName());
    model->setIsDownloading(true);

    Download *download = new Download(id, model->url(), model->key());
    if(downloads.size()<3){
        connect(download, &Download::downloadProgress, this, &OfflineModelList::handleDownloadProgress, Qt::QueuedConnection);
        connect(download, &Download::downloadFinished, this, &OfflineModelList::handleDownloadFinished, Qt::QueuedConnection);
        download->downloadModel();
    }
    downloads.append(download);

    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {IsDownloadingRole});
}

void OfflineModelList::handleDownloadProgress(const int id, const qint64 bytesReceived, const qint64 bytesTotal){

    OfflineModel* model = findModelById(id);
    if(model == nullptr) return;
    const int index = m_models.indexOf(model);

    model->setBytesReceived(bytesReceived);
    model->setBytesTotal(bytesTotal);

    updateDownloadProgress();

    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {DownloadPercentRole});
}

void OfflineModelList::handleDownloadFinished(const int id){

    OfflineModel* model = findModelById(id);
    if(model == nullptr) return;
    const int index = m_models.indexOf(model);

    model->setIsDownloading(false);
    model->setDownloadFinished(true);
    model->setDownloadPercent(0);

    updateDownloadProgress();
    deleteDownloadModel(id);

    requestUpdateKeyModel(model->id(), model->key());

    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {IsDownloadingRole, DownloadFinishedRole, DownloadPercentRole});
    // emit currentModelListChanged();
}

void OfflineModelList::cancelRequest(const int id){

    OfflineModel* model = findModelById(id);
    if(model == nullptr) return;
    const int index = m_models.indexOf(model);

    for(int indexSearch =0 ;indexSearch<downloads.size() && indexSearch<3 ;indexSearch++)
        if(downloads[indexSearch]->id() == id)
            downloads[indexSearch]->cancelDownload();
    model->setIsDownloading(false);
    model->setDownloadFinished(false);
    model->setDownloadPercent(0);

    updateDownloadProgress();
    deleteDownloadModel(id);
    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {DownloadFinishedRole, IsDownloadingRole, DownloadPercentRole});

}

void OfflineModelList::deleteRequest(const int id){

    OfflineModel* model = findModelById(id);
    if(model == nullptr) return;
    const int index = m_models.indexOf(model);

    model->setIsDownloading(false);
    model->setDownloadFinished(false);

    if(model->url() == ""){
        beginRemoveRows(QModelIndex(), index, index);
        m_models.removeAll(model);
        endRemoveRows();

        //delete from database
        requestDeleteModel(model->id());
        delete model;

    }else if(model->key() != ""){
        QFile file(model->key());
        if (file.exists()){
            file.remove();
        }
        requestUpdateKeyModel(model->id(), "");
    }

    ConversationList::instance(this)->setModelSelect(false);

    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {DownloadFinishedRole, IsDownloadingRole});
}

void OfflineModelList::addRequest(QString directoryPath){
    directoryPath.remove("file:///");
    QFileInfo fileInfo(directoryPath);
    QString fileName = fileInfo.baseName();
    emit requestAddModel(fileName, directoryPath);
}

void OfflineModelList::addModel(const double fileSize, const int ramRamrequired, const QString& fileName, const QString& url,
                                const QString& parameters, const QString& quant, const double downloadPercent,
                                const bool isDownloading, const bool downloadFinished,

                                const int id, const QString& modelName, const QString& name, const QString& key, QDateTime addModelTime,
                                const bool isLike, Company* company, const QString& type, const BackendType backend,
                                const QString& icon , const QString& information , const QString& promptTemplate ,
                                const QString& systemPrompt, QDateTime expireModelTime)
{
    const int index = m_models.size();
    beginInsertRows(QModelIndex(), index, index);
    OfflineModel* model = new OfflineModel(fileSize, ramRamrequired, fileName, url, parameters,
                                           quant, downloadPercent, isDownloading, downloadFinished,

                                           id, modelName, name, key, addModelTime, isLike, company, type, backend, icon, information,
                                           promptTemplate, systemPrompt, expireModelTime, m_instance);
    m_models.append(model);
    endInsertRows();
    emit countChanged();
}

OfflineModel* OfflineModelList::findModelById(int id) {
    auto it = std::find_if(m_models.begin(), m_models.end(), [id](OfflineModel* model) {
        return model->id() == id;
    });

    return (it != m_models.end()) ? *it : nullptr;
}

void OfflineModelList::updateDownloadProgress(){
    qint64 totalBytesDownload =0;
    qint64 receivedBytesDownload =0;
    for (auto &&model : m_models){
        if(model->isDownloading() && model->bytesTotal()>=0.0001 && model->bytesReceived()>=0.0001){
            totalBytesDownload += model->bytesTotal();
            receivedBytesDownload += model->bytesReceived();
        }
    }
    if(totalBytesDownload != 0)
        m_downloadProgress = static_cast<double>(receivedBytesDownload)/static_cast<double>(totalBytesDownload);
    else
        m_downloadProgress = 0;

    emit downloadProgressChanged();
}

void OfflineModelList::deleteDownloadModel(const int id){
    if(downloads.size()>3){
        connect(downloads[3], &Download::downloadProgress, this, &OfflineModelList::handleDownloadProgress, Qt::QueuedConnection);
        connect(downloads[3], &Download::downloadFinished, this, &OfflineModelList::handleDownloadFinished, Qt::QueuedConnection);
        downloads[3]->downloadModel();
    }
    for(int searchIndex = 0; searchIndex<downloads.size(); searchIndex++){
        if(downloads[searchIndex]->id() == id){
            Download *download = downloads[searchIndex];
            downloads.removeAt(searchIndex);
            delete download;
        }
    }
}

