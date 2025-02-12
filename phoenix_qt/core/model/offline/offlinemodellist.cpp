#include "offlinemodellist.h"

#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

OfflineModelList* OfflineModelList::m_instance = nullptr;

OfflineModelList* OfflineModelList::instance(QObject* parent) {
    if (!m_instance) {
        m_instance = new OfflineModelList(parent);
    }
    return m_instance;
}

OfflineModelList::OfflineModelList(QObject* parent) {}

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
    case IconModelRole:
        return model->icon();
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
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> OfflineModelList::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[NameRole] = "name";
    roles[InformationRole] = "information";
    roles[IconModelRole] = "icon";
    roles[IsLikeRole] = "isLike";
    roles[AddModelTimeRole] = "addModelTime";
    roles[FileSizeRole] = "fileSize";
    roles[RamRamrequiredRole] = "ramRamrequired";
    roles[ParametersRole] = "parameters";
    roles[QuantRole] = "quant";
    roles[DownloadFinishedRole] = "downloadFinished";
    roles[IsDownloadingRole] = "isDownloading";
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

void OfflineModelList::setModelList(QList<OfflineModel*> models){
    beginResetModel();
    m_models = models;
    endResetModel();
    emit countChanged();
}
