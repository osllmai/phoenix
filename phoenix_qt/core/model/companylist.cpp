#include "companylist.h"

#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

#include "./offline/offlinemodellist.h"

CompanyList* CompanyList::m_instance = nullptr;

CompanyList* CompanyList::instance(QObject* parent) {
    if (!m_instance) {
        m_instance = new CompanyList(parent);
    }
    return m_instance;
}

CompanyList::CompanyList(QObject *parent): QAbstractListModel(parent){
    connect(&futureWatcher, &QFutureWatcher<QList<Company*>>::finished, this, [this]() {
        beginResetModel();
        m_companys = futureWatcher.result();
        emit requestReadModel(m_companys);
        endResetModel();
        emit countChanged();
    });

    QFuture<QList<Company*>> future = QtConcurrent::run(parseJson,"./bin/company.json");
    futureWatcher.setFuture(future);
}

int CompanyList::count() const{return m_companys.count();}

int CompanyList::rowCount(const QModelIndex &parent) const{
    Q_UNUSED(parent);
    return m_companys.count();
}

QVariant CompanyList::data(const QModelIndex &index, int role) const{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_companys.count())
        return QVariant();

    Company* company = m_companys.at(index.row());

    switch (role) {
    case IDRole:
        return company->id();
    case NameRole:
        return company->name();
    case IconRole:
        return company->icon();
    case BackendRole:
        return static_cast<int>(company->backend());
    case CompanyObjectRole:
        return QVariant::fromValue(m_companys[index.row()]);
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> CompanyList::roleNames() const{
    QHash<int, QByteArray> roles;
    roles[IDRole] = "ID";
    roles[NameRole] = "name";
    roles[IconRole] = "icon";
    roles[BackendRole] = "backend";
    roles[CompanyObjectRole] = "companyObject";
    return roles;
}

QList<Company*> CompanyList::parseJson(const QString &filePath) {
    QList<Company*> tempCompany;
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Cannot open JSON file!";
        return tempCompany;
    }
    QByteArray jsonData = file.readAll();
    file.close();
    QJsonDocument doc = QJsonDocument::fromJson(jsonData);
    if (!doc.isArray()) {
        qWarning() << "Invalid JSON format!";
        return tempCompany;
    }
    int i=0;
    QJsonArray jsonArray = doc.array();
    for (const QJsonValue &value : jsonArray) {
        if (!value.isObject()) continue;
        QJsonObject obj = value.toObject();
        Company *company;
        if (obj["type"].toString() == "OfflineModel") {
            company = new Company(i++, obj["name"].toString(), obj["icon"].toString(),
                                  BackendType::OfflineModel, obj["file"].toString(), nullptr);
        } else if (obj["type"].toString() == "OnlineModel") {
            company = new Company(i++, obj["name"].toString(), obj["icon"].toString(),
                                  BackendType::OnlineModel, obj["file"].toString(), nullptr);
        }
        tempCompany.append(company);
    }
    return tempCompany;
}
