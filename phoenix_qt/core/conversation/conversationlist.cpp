#include "conversationlist.h"

#include <algorithm>

ConversationList* ConversationList::m_instance = nullptr;

ConversationList* ConversationList::instance(QObject* parent) {
    if (!m_instance) {
        m_instance = new ConversationList(parent);
    }
    return m_instance;
}

ConversationList::ConversationList(QObject* parent): QAbstractListModel(parent) {}

int ConversationList::count() const{return m_conversations.count();}

int ConversationList::rowCount(const QModelIndex &parent) const {
//     Q_UNUSED(parent)
//     return m_models.count();
    return 5;
}

QVariant ConversationList::data(const QModelIndex &index, int role = Qt::DisplayRole) const{
//     if (!index.isValid() || index.row() < 0 || index.row() >= m_models.count())
        return QVariant();

//     OfflineModel* model = m_models[index.row()];

//     switch (role) {
//     case IdRole:
//         return model->id();
//     case NameRole:
//         return model->name();
//     case InformationRole:
//         return model->information();
//     case CompanyRole:
//         return QVariant::fromValue(m_models[index.row()]->company());
//     case IsLikeRole:
//         return model->isLike();
//     case AddModelTimeRole:
//         return model->addModelTime();
//     case FileSizeRole:
//         return model->fileSize();
//     case RamRamrequiredRole:
//         return model->ramRamrequired();
//     case ParametersRole:
//         return model->parameters();
//     case QuantRole:
//         return model->quant();
//     case DownloadFinishedRole:
//         return model->downloadFinished();
//     case IsDownloadingRole:
//         return model->isDownloading();
//     case DownloadPercentRole:
//         return model->downloadPercent();
//     case ModelObjectRole:
//         return QVariant::fromValue(m_models[index.row()]);
//     default:
//         return QVariant();
//     }
}

// QHash<int, QByteArray> ConversationList::roleNames() const {
//     QHash<int, QByteArray> roles;
//     roles[IdRole] = "id";
//     roles[NameRole] = "name";
//     roles[InformationRole] = "information";
//     roles[CompanyRole] = "company";
//     roles[IsLikeRole] = "isLike";
//     roles[AddModelTimeRole] = "addModelTime";
//     roles[FileSizeRole] = "fileSize";
//     roles[RamRamrequiredRole] = "ramRamrequired";
//     roles[ParametersRole] = "parameters";
//     roles[QuantRole] = "quant";
//     roles[DownloadFinishedRole] = "downloadFinished";
//     roles[IsDownloadingRole] = "isDownloading";
//     roles[DownloadPercentRole] = "downloadPercent";
//     roles[ModelObjectRole] = "modelObject";
//     return roles;
// }

bool ConversationList::setData(const QModelIndex &index, const QVariant &value, int role) {
//     OfflineModel* model = m_models[index.row()]; // The person to edit
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
    return false;
}

void ConversationList::addConversation(const int id, const QString &title, const QString &description, const QDateTime date, const bool &stream,
                                       const QString &promptTemplate, const QString &systemPrompt, const double &temperature,
                                       const int &topK, const double &topP, const double &minP, const double &repeatPenalty,
                                       const int &promptBatchSize, const int &maxTokens, const int &repeatPenaltyTokens,
                                       const int &contextLength, const int &numberOfGPULayers)
{
    // const int index = m_models.size();
    // beginInsertRows(QModelIndex(), index, index);
    // OfflineModel* model = new OfflineModel(fileSize, ramRamrequired, fileName, url, parameters,
    //                                        quant, downloadPercent, isDownloading, downloadFinished,

    //                                        id, name, key, addModelTime, isLike, company,backend, icon, information,
    //                                        promptTemplate, systemPrompt, expireModelTime, m_instance);
    // m_models.append(model);
    // connect(model, &OfflineModel::modelChanged, this, [=]() {
    //     int row = m_models.indexOf(model);
    //     if (row != -1) {
    //         QModelIndex modelIndex = createIndex(row, 0);
    //         emit dataChanged(modelIndex, modelIndex);
    //     }
    // });
    // endInsertRows();
    // emit countChanged();
}

// Conversation* ConversationList::findConversationById(const int id){
//     auto it = std::find_if(m_models.begin(), m_models.end(), [id](OfflineModel* model) {
//         return model->id() == id;
//     });

//     return (it != m_models.end()) ? *it : nullptr;
// }

