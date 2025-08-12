#include "huggingfacemodellist.h"

HuggingfaceModelList* HuggingfaceModelList::m_instance = nullptr;

HuggingfaceModelList* HuggingfaceModelList::instance(QObject* parent) {
    if (!m_instance) {
        m_instance = new HuggingfaceModelList(parent);
    }
    return m_instance;
}

HuggingfaceModelList::HuggingfaceModelList(QObject* parent):
     QAbstractListModel(parent)
{}

int HuggingfaceModelList::count() const{return m_models.count();}

int HuggingfaceModelList::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return m_models.count();
}

QVariant HuggingfaceModelList::data(const QModelIndex &index, int role = Qt::DisplayRole) const{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_models.count())
        return QVariant();

    HuggingfaceModel* model = m_models[index.row()];

    switch (role) {
    case IdRole:
        return model->id();
    case IdModelRole:
        return model->id();
    case LikesRole:
        return model->likes();
    case DownloadsRole:
        return model->downloads();
    case PiplineTagRole:
        return model->pipelineTag();
    case TagsRole:
        return model->tags();
    case CreatedAtRole:
        return model->createdAt();
    case ModelObjectRole:
        return QVariant::fromValue(m_models[index.row()]);
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> HuggingfaceModelList::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[IdModelRole] = "idModel";
    roles[LikesRole] = "likes";
    roles[DownloadsRole] = "downloads";
    roles[PiplineTagRole] = "piplineTag";
    roles[TagsRole] = "tags";
    roles[CreatedAtRole] = "createdAt";
    roles[ModelObjectRole] = "modelObject";
    roles[ModelObjectRole] = "modelObject";
    return roles;
}

// bool HuggingfaceModelList::setData(const QModelIndex &index, const QVariant &value, int role) {
//     HuggingfaceModel* model = m_models[index.row()]; // The person to edit
//     bool somethingChanged{false};

//     switch (role) {
//     case IsLikeRole:
//         if( model->isLike()!= value.toBool()){
//             model->setIsLike(value.toBool());
//             somethingChanged = true;
//         }
//         break;
//     }
//     if(somethingChanged){
//         emit dataChanged(index, index, QVector<int>() << role);
//         return true;
//     }
//     return false;
// }
