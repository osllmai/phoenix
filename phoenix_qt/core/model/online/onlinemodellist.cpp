#include "onlinemodellist.h"

#include <algorithm>

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
    }

    return QVariant();
}

QHash<int, QByteArray> OnlineModelList::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[NameRole] = "name";
    roles[InformationRole] = "information";
    roles[IconModelRole] = "icon";
    roles[IsLikeRole] = "isLike";
    roles[AddModelTimeRole] = "addModelTime";
    roles[TypeRole] = "type";
    roles[ContextWindowsRole] = "contextWindows";
    roles[OutputRole] = "output";
    roles[CommercialRole] = "commercial";
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

void OnlineModelList::setModelList(QList<OnlineModel*> models){
    beginResetModel();
    m_models = models;
    endResetModel();
    emit countChanged();
}

bool OnlineModelList::containsId(int id) const {
    return std::any_of(m_models.begin(), m_models.end(), [id](const OnlineModel* model) {
        return model->id() == id;
    });
}
