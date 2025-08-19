#include "onlinemodellist.h"

#include <algorithm>

#include "../../conversation/conversationlist.h"

OnlineModelList::OnlineModelList(QObject *parent): QAbstractListModel(parent)
{
    connect(&m_sortWatcher, &QFutureWatcher<QList<OnlineModel*>>::finished, this, &OnlineModelList::handleSortingFinished);
}

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
    case ModelNameRole:
        return model->modelName();
    case KeyRole:
        return model->key();
    case InformationRole:
        return model->information();
    case IconModelRole:
        return model->icon();
    // case CompanyRole:
    //     return QVariant::fromValue(m_models[index.row()]->company());
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
    roles[ModelNameRole] = "modelName";
    roles[KeyRole] = "key";
    roles[InformationRole] = "information";
    roles[IconModelRole] = "icon";
    // roles[CompanyRole] = "company";
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

void OnlineModelList::finalizeSetup(){
    sortAsync(NameRole , Qt::AscendingOrder);
}

void OnlineModelList::sortAsync(int role, Qt::SortOrder order) {
    if (m_models.isEmpty()) return;

    auto modelsCopy = m_models;
    QFuture<QList<OnlineModel*>> future = QtConcurrent::run([modelsCopy, role, order]() mutable {
        QCollator collator;
        collator.setNumericMode(true);
        std::sort(modelsCopy.begin(), modelsCopy.end(), [&](OnlineModel* a, OnlineModel* b) {
            QString sa, sb;
            if (role == NameRole) {
                sa = a->name();
                sb = b->name();
            } else if (role == ModelNameRole) {
                sa = a->modelName();
                sb = b->modelName();
            }
            return (order == Qt::AscendingOrder)
                       ? (collator.compare(sa, sb) < 0)
                       : (collator.compare(sa, sb) > 0);
        });
        return modelsCopy;
    });

    m_sortWatcher.setFuture(future);
}

void OnlineModelList::handleSortingFinished() {
    beginResetModel();
    m_models = m_sortWatcher.result();
    endResetModel();
    emit sortingFinished();
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
    emit requestUpdateKeyModel(model->id(), model->key());
    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {InstallModelRole });
}

void OnlineModelList::deleteRequest(const int id){

    OnlineModel* model = findModelById(id);
    if(model == nullptr) return;
    const int index = m_models.indexOf(model);

    model->setKey("");
    model->setInstallModel(false);
    emit requestUpdateKeyModel(model->id(), "");

    ConversationList::instance(this)->setModelSelect(false);

    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {InstallModelRole});
}

void OnlineModelList::addModel(const QVariantMap &m)
{
    const int id = m.value("id", -1).toInt();
    const QString modelName = m.value("modelName").toString();
    const QString name = m.value("name").toString();
    const QString key = m.value("key").toString();
    const QDateTime addDate = QDateTime::currentDateTime();
    const bool isLike = m.value("isLike", false).toBool();
    const QString type = m.value("type").toString();
    const BackendType backend = BackendType::OnlineModel;
    const QString icon = m.value("icon").toString();;
    const QString information = m.value("description").toString();
    const QString promptTemplate = m.value("promptTemplate").toString();
    const QString systemPrompt = m.value("systemPrompt").toString();
    const QDateTime expireDate = QDateTime::currentDateTime();
    const bool recommended = m.value("recommended").toBool();

    const double inputPrice = m.value("inputPricePer1KTokens").toDouble();
    const double outputPrice = m.value("outputPricePer1KTokens").toDouble();
    const QString contextWindows = m.value("contextWindows").toString();
    const bool commercial = m.value("commercial").toBool();
    const bool pricey = m.value("pricey").toBool();
    const QString output = m.value("output").toString();
    const QString comments = m.value("comments").toString();
    const bool installModel = m.value("installModel", false).toBool();

    const int index = m_models.size();
    OnlineModel* model = new OnlineModel(id, modelName, name, key, addDate, isLike,
                                         type, backend, icon, information,
                                         promptTemplate, systemPrompt, expireDate,
                                         recommended, this, inputPrice,
                                         outputPrice, contextWindows, commercial,
                                         pricey, output, comments, installModel);

    m_models.append(model);
    connect(model, &OnlineModel::modelChanged, this, [=]() {
        int row = m_models.indexOf(model);
        if (row != -1) {
            QModelIndex modelIndex = createIndex(row, 0);
            emit dataChanged(modelIndex, modelIndex);
        }
    });
    emit countChanged();
}


OnlineModel* OnlineModelList::findModelById(int id) {
    auto it = std::find_if(m_models.begin(), m_models.end(), [id](OnlineModel* model) {
        return model->id() == id;
    });

    return (it != m_models.end()) ? *it : nullptr;
}

OnlineModel* OnlineModelList::findModelByModelName(const QString modelName) {
    // for (OnlineModel* model : m_models) {
    //     QString fullModelName =  model->company()->name() + "/" + model->modelName();
    //     if (fullModelName == modelName ) {
    //         return model;
    //     }
    // }
    return nullptr;
}

