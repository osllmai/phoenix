#include "onlinemodellist.h"

#include <algorithm>

#include "../../conversation/conversationlist.h"

OnlineModelList* OnlineModelList::m_instance = nullptr;

OnlineModelList* OnlineModelList::instance(QObject* parent) {
    if (!m_instance) {
        m_instance = new OnlineModelList(parent);
    }
    return m_instance;
}

OnlineModelList::OnlineModelList(QObject *parent): QAbstractListModel(parent){}

int OnlineModelList::count() const{return m_models.count();}

int OnlineModelList::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return m_models.size();
}

QVariant OnlineModelList::data(const QModelIndex &index, int role = Qt::DisplayRole) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_models.count())
        return QVariant();

    //The index is valid
    OnlineModel* model = m_models[index.row()];

    switch (role) {
    case IdRole:
        return model->id();
    case NameRole:
        return model->name();
    case KeyRole:
        return model->key();
    case InformationRole:
        return model->information();
    case IconModelRole:
        return model->icon();
    case IsLikeRole:
        return model->isLike();
    case AddModelTimeRole:
        return model->addModelTime();
    case TypeRole:
        return model->type();
    case ContextWindowsRole:
        return model->contextWindows();
    case OutputRole:
        return model->output();
    case CommercialRole:
        return model->commercial();
    case InstallModelRole:
        return model->installModel();
    case ModelObjectRole:
        return QVariant::fromValue(m_models[index.row()]);
    }

    return QVariant();
}

QHash<int, QByteArray> OnlineModelList::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[NameRole] = "name";
    roles[KeyRole] = "key";
    roles[InformationRole] = "information";
    roles[IconModelRole] = "icon";
    roles[IsLikeRole] = "isLike";
    roles[AddModelTimeRole] = "addModelTime";
    roles[TypeRole] = "type";
    roles[ContextWindowsRole] = "contextWindows";
    roles[OutputRole] = "output";
    roles[CommercialRole] = "commercial";
    roles[InstallModelRole] = "installModel";
    roles[ModelObjectRole] = "modelObject";
    return roles;
}

bool OnlineModelList::setData(const QModelIndex &index, const QVariant &value, int role) {
    OnlineModel* model = m_models[index.row()]; // The person to edit
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

OnlineModel* OnlineModelList::at(int index) const{
    if (index < 0 || index >= m_models.count())
        return nullptr;
    return m_models.at(index);
}

void OnlineModelList::likeRequest(const int id, const bool isLike){
    emit requestUpdateIsLikeModel(id, isLike);
}

void OnlineModelList::saveAPIKey(const int id, QString key){
    OnlineModel* model = findModelById(id);
    if(model == nullptr) return;
    const int index = m_models.indexOf(model);
    model->setKey(key);
    model->setInstallModel(true);
    requestUpdateKeyModel(model->id(), model->key());
    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {InstallModelRole });
}

void OnlineModelList::deleteRequest(const int id){

    OnlineModel* model = findModelById(id);
    if(model == nullptr) return;
    const int index = m_models.indexOf(model);

    model->setKey("");
    model->setInstallModel(false);
    requestUpdateKeyModel(model->id(), "");

    ConversationList::instance(this)->setModelSelect(false);

    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {InstallModelRole});
}

void OnlineModelList::addModel(const int id, const QString& modelName, const QString& name, const QString& key, QDateTime addModelTime,
              const bool isLike, Company* company, const QString& type, const BackendType backend,
              const QString& icon , const QString& information , const QString& promptTemplate ,
              const QString& systemPrompt, QDateTime expireModelTime,

              const double inputPricePer1KTokens, const double outputPricePer1KTokens,
              const QString& contextWindows, const bool recommended, const bool commercial, const bool pricey,
              const QString& output, const QString& comments, const bool installModel)
{
    const int index = m_models.size();
    beginInsertRows(QModelIndex(), index, index);
    OnlineModel* model = new OnlineModel(id, modelName, name, key, addModelTime, isLike, company, type, backend, icon,
                                  information, promptTemplate, systemPrompt, expireModelTime, m_instance,

                                  inputPricePer1KTokens, outputPricePer1KTokens, contextWindows,
                                  recommended, commercial, pricey, output, comments, installModel);
    m_models.append(model);
    connect(model, &OnlineModel::modelChanged, this, [=]() {
        int row = m_models.indexOf(model);
        if (row != -1) {
            QModelIndex modelIndex = createIndex(row, 0);
            emit dataChanged(modelIndex, modelIndex);
        }
    });
    endInsertRows();
    emit countChanged();
}

OnlineModel* OnlineModelList::findModelById(int id) {
    auto it = std::find_if(m_models.begin(), m_models.end(), [id](OnlineModel* model) {
        return model->id() == id;
    });

    return (it != m_models.end()) ? *it : nullptr;
}
