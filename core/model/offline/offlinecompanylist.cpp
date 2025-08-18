#include "offlinecompanylist.h"

#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QtConcurrent>
#include <QCoreApplication>

#include "offlinemodellist.h"

OfflineCompanyList* OfflineCompanyList::m_instance = nullptr;

OfflineCompanyList* OfflineCompanyList::instance(QObject* parent) {
    if (!m_instance) {
        m_instance = new OfflineCompanyList(parent);
    }
    return m_instance;
}

OfflineCompanyList::OfflineCompanyList(QObject *parent): QAbstractListModel(parent)
{
    connect(&m_sortWatcher, &QFutureWatcher<QList<Company*>>::finished, this, &OfflineCompanyList::handleSortingFinished);
}

void OfflineCompanyList::readDB(){
    connect(&futureWatcher, &QFutureWatcher<QList<Company*>>::finished, this, [this]() {
        beginResetModel();
        m_companys = futureWatcher.result();
        emit requestReadModel(m_companys);
        endResetModel();
        emit countChanged();
        sortAsync(NameRole , Qt::AscendingOrder);
    });

    QFuture<QList<Company*>> future = QtConcurrent::run(parseJson, QCoreApplication::applicationDirPath() + "/models/company.json");
    futureWatcher.setFuture(future);
}

int OfflineCompanyList::count() const{return m_companys.count();}

int OfflineCompanyList::rowCount(const QModelIndex &parent) const{
    Q_UNUSED(parent);
    return m_companys.count();
}

QVariant OfflineCompanyList::data(const QModelIndex &index, int role) const{
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

QHash<int, QByteArray> OfflineCompanyList::roleNames() const{
    QHash<int, QByteArray> roles;
    roles[IDRole] = "id";
    roles[NameRole] = "name";
    roles[IconRole] = "icon";
    roles[BackendRole] = "backend";
    roles[CompanyObjectRole] = "companyObject";
    return roles;
}

void OfflineCompanyList::finalizeSetup(){
    sortAsync(NameRole , Qt::AscendingOrder);
}

void OfflineCompanyList::sortAsync(int role, Qt::SortOrder order) {
    if (m_companys.isEmpty()) return;

    auto modelsCopy = m_companys;
    QFuture<QList<Company*>> future = QtConcurrent::run([modelsCopy, role, order]() mutable {
        QCollator collator;
        collator.setNumericMode(true);
        std::sort(modelsCopy.begin(), modelsCopy.end(), [&](Company* a, Company* b) {
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

void OfflineCompanyList::handleSortingFinished() {
    beginResetModel();
    m_companys = m_sortWatcher.result();
    endResetModel();
    emit sortingFinished();
}

QList<Company*> OfflineCompanyList::parseJson(const QString &filePath) {
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

        if (obj["type"].toString() == "OfflineModel") {

            Company *company;

            company = new Company(i++, obj["name"].toString(), obj["icon"].toString(),
                                  BackendType::OfflineModel, obj["file"].toString(), nullptr);
            tempCompany.append(company);
        }
    }
    return tempCompany;
}
