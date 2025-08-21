#include "onlinecompanylist.h"

#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QtConcurrent>
#include <QCoreApplication>

#include "onlinemodellist.h"
#include "../../conversation/conversationlist.h"

OnlineCompanyList* OnlineCompanyList::m_instance = nullptr;

OnlineCompanyList* OnlineCompanyList::instance(QObject* parent) {
    if (!m_instance) {
        m_instance = new OnlineCompanyList(parent);
    }
    return m_instance;
}

OnlineCompanyList::OnlineCompanyList(QObject *parent): QAbstractListModel(parent)
{
    connect(&m_sortWatcher, &QFutureWatcher<QList<OnlineCompany*>>::finished, this, &OnlineCompanyList::handleSortingFinished);
}

int OnlineCompanyList::count() const{return m_companys.count();}

int OnlineCompanyList::rowCount(const QModelIndex &parent) const{
    Q_UNUSED(parent);
    return m_companys.count();
}

QVariant OnlineCompanyList::data(const QModelIndex &index, int role) const{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_companys.count())
        return QVariant();

    OnlineCompany* company = m_companys.at(index.row());

    switch (role) {
    case IDRole:
        return company->id();
    case NameRole:
        return company->name();
    case IconRole:
        return company->icon();
    case IsLikeRole:
        return company->isLike();
    case InstallModelRole:
        return company->installModel();
    case BackendRole:
        return static_cast<int>(company->backend());
    case CompanyObjectRole:
        return QVariant::fromValue(m_companys[index.row()]);
    case OnlineModelListRole:
        return QVariant::fromValue(company->onlineModelList());
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> OnlineCompanyList::roleNames() const{
    QHash<int, QByteArray> roles;
    roles[IDRole] = "id";
    roles[NameRole] = "name";
    roles[IconRole] = "icon";
    roles[IsLikeRole] = "isLike";
    roles[InstallModelRole] = "installModel";
    roles[BackendRole] = "backend";
    roles[CompanyObjectRole] = "companyObject";
    roles[OnlineModelListRole] = "onlineModelList";
    return roles;
}

bool OnlineCompanyList::setData(const QModelIndex &index, const QVariant &value, int role) {
    OnlineCompany* model = m_companys[index.row()];
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

void OnlineCompanyList::finalizeSetup(){
    sortAsync(NameRole , Qt::AscendingOrder);
}

void OnlineCompanyList::sortAsync(int role, Qt::SortOrder order) {
    if (m_companys.isEmpty()) return;

    auto modelsCopy = m_companys;
    QFuture<QList<OnlineCompany*>> future = QtConcurrent::run([modelsCopy, role, order]() mutable {
        QCollator collator;
        collator.setNumericMode(true);
        std::sort(modelsCopy.begin(), modelsCopy.end(), [&](OnlineCompany* a, OnlineCompany* b) {
            QString sa, sb;
            if (role == NameRole) {
                sa = a->name();
                sb = b->name();
            }
            return (order == Qt::AscendingOrder)
                       ? (collator.compare(sa, sb) < 0)
                       : (collator.compare(sa, sb) > 0);
        });
        return modelsCopy;
    });

    m_sortWatcher.setFuture(future);
}

void OnlineCompanyList::handleSortingFinished() {
    beginResetModel();
    m_companys = m_sortWatcher.result();
    endResetModel();
    emit sortingFinished();
}

void OnlineCompanyList::addProvider(const int id, const QString& name, const QString& icon, const bool isLike,
                 const BackendType backend, const QString& filePath, QString key){
    const int index = m_companys.size();
    beginInsertRows(QModelIndex(), index, index);
    bool isInstall =  true;
    if(key == "")
        isInstall = false;
    m_companys.append(new OnlineCompany(id,name,icon,isLike,backend,filePath,key, isInstall, this));
    endInsertRows();
    emit countChanged();
}

void OnlineCompanyList::likeRequest(const int id, const bool isLike){
    emit requestUpdateIsLikeModel(id, isLike);
}

void OnlineCompanyList::saveAPIKey(const int id, QString key){
    OnlineCompany* model = findCompanyById(id);
    if(model == nullptr) return;
    const int index = m_companys.indexOf(model);
    model->setKey(key);
    model->setInstallModel(true);
    emit requestUpdateKeyModel(model->id(), model->key());
    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {InstallModelRole});
}

void OnlineCompanyList::deleteRequest(const int id){

    OnlineCompany* model = findCompanyById(id);
    if(model == nullptr) return;
    const int index = m_companys.indexOf(model);

    model->setKey("");
    model->setInstallModel(false);
    emit requestUpdateKeyModel(model->id(), "");

    ConversationList::instance(this)->setModelSelect(false);

    emit dataChanged(createIndex(index, 0), createIndex(index, 0), {InstallModelRole});
}

OnlineCompany* OnlineCompanyList::findCompanyById(int id) {
    auto it = std::find_if(m_companys.begin(), m_companys.end(), [id](OnlineCompany* model) {
        return model->id() == id;
    });

    return (it != m_companys.end()) ? *it : nullptr;
}
