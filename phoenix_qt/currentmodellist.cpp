#include "currentmodellist.h"

CurrentModelList::CurrentModelList(QObject *parent)
    : QAbstractListModel(parent)
{}

//*------------------------------------------------------------------------------**************************-----------------------------------------------------------------------------*//
//*------------------------------------------------------------------------------* QAbstractItemModel interface *------------------------------------------------------------------------------*//
int CurrentModelList::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return models.size();
}

QVariant CurrentModelList::data(const QModelIndex &index, int role = Qt::DisplayRole) const {
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

QHash<int, QByteArray> CurrentModelList::roleNames() const {
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

Qt::ItemFlags CurrentModelList::flags(const QModelIndex &index) const {
    if (!index.isValid())
        return Qt::NoItemFlags;
    return Qt::ItemIsEditable;
}

bool CurrentModelList::setData(const QModelIndex &index, const QVariant &value, int role) {
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

int CurrentModelList::size() const{
    return models.size();
}

void CurrentModelList::addModel( Model *model){
    const int index = models.size();
    beginInsertRows(QModelIndex(), index, index);//Tell the model that you are about to add data
    models.append(model);
    endInsertRows();
    emit sizeChanged();
}

void CurrentModelList::deleteModel( Model *model){
    const int index = models.indexOf(model);
    if(index>-1){
        beginRemoveRows(QModelIndex(), index, index);
        models.removeAll(model);
        endRemoveRows();
    }
}
