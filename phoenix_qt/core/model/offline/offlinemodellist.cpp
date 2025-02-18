#include "offlinemodellist.h"

#include <algorithm>

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

void OfflineModelList::likeRequest(const int id, const bool isLike){
    emit requestUpdateIsLikeModel(id, isLike);
}

void OfflineModelList::downloadRequest(const int id, QString directoryPath){
    OfflineModel* offlineModel = findModelById(id);
    if(offlineModel == nullptr) return;
    qInfo()<< offlineModel->name()<<" - "<< offlineModel->fileSize()<<" - downloadRequest";
    offlineModel->startDownload(directoryPath);
    qInfo()<< offlineModel->name()<<" - "<< offlineModel->fileSize()<<" - downloadRequest";

}

void OfflineModelList::cancelRequest(const int id){
    OfflineModel* offlineModel = findModelById(id);
    if(offlineModel == nullptr) return;
    qInfo()<< offlineModel->name()<<" - "<< offlineModel->fileSize()<<" - cancelRequest";
    offlineModel->cancelDownload();
    qInfo()<< offlineModel->name()<<" - "<< offlineModel->fileSize()<<" - cancelRequest";

}

void OfflineModelList::deleteRequest(const int id){
    OfflineModel* offlineModel = findModelById(id);
    if(offlineModel == nullptr) return;
    qInfo()<< offlineModel->name()<<" - "<< offlineModel->fileSize()<<" - deleteRequest";
    offlineModel->removeDownload();
    qInfo()<< offlineModel->name()<<" - "<< offlineModel->fileSize()<<" - deleteRequest";
}

void OfflineModelList::addRequest(QString directoryPath){

}

void OfflineModelList::addModel(const double fileSize, const int ramRamrequired, const QString& fileName, const QString& url,
                                const QString& parameters, const QString& quant, const double downloadPercent,
                                const bool isDownloading, const bool downloadFinished,

                                const int id, const QString& name, const QString& key, QDateTime addModelTime,
                                const bool isLike, Company* company, const BackendType backend,
                                const QString& icon , const QString& information , const QString& promptTemplate ,
                                const QString& systemPrompt, QDateTime expireModelTime)
{
    const int index = m_models.size();
    beginInsertRows(QModelIndex(), index, index);
    OfflineModel* model = new OfflineModel(fileSize, ramRamrequired, fileName, url, parameters,
                                           quant, downloadPercent, isDownloading, downloadFinished,

                                           id, name, key, addModelTime, isLike, company,backend, icon, information,
                                           promptTemplate, systemPrompt, expireModelTime, m_instance);
    m_models.append(model);
    connect(model, &OfflineModel::modelChanged, this, [=]() {
        int row = m_models.indexOf(model);
        if (row != -1) {
            QModelIndex modelIndex = createIndex(row, 0);
            emit dataChanged(modelIndex, modelIndex);
        }
    });
    endInsertRows();
    emit countChanged();
}

OfflineModel* OfflineModelList::findModelById(int id) {
    auto it = std::find_if(m_models.begin(), m_models.end(), [id](OfflineModel* model) {
        return model->id() == id;
    });

    return (it != m_models.end()) ? *it : nullptr;
}

