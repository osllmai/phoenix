#include "codedeveloperlist.h"

// CodeDeveloperList::CodeDeveloperList() {}

#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

#include <QCoreApplication>

#include "./offline/offlinemodellist.h"

CodeDeveloperList* CodeDeveloperList::m_instance = nullptr;

CodeDeveloperList* CodeDeveloperList::instance(QObject* parent) {
    if (!m_instance) {
        m_instance = new CodeDeveloperList(parent);
    }
    return m_instance;
}

CodeDeveloperList::CodeDeveloperList(QObject *parent): QAbstractListModel(parent){}

void CodeDeveloperList::readDB(){
    connect(&futureWatcher, &QFutureWatcher<QList<Company*>>::finished, this, [this]() {
        beginResetModel();
        m_companys = futureWatcher.result();
        emit requestReadModel(m_companys);
        endResetModel();
        emit countChanged();
    });

    QFuture<QList<Company*>> future = QtConcurrent::run(parseJson, QCoreApplication::applicationDirPath() + "/models/company.json");
    futureWatcher.setFuture(future);
}

int CodeDeveloperList::count() const{return m_companys.count();}

int CodeDeveloperList::rowCount(const QModelIndex &parent) const{
    Q_UNUSED(parent);
    return m_companys.count();
}

QVariant CodeDeveloperList::data(const QModelIndex &index, int role) const{
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

QHash<int, QByteArray> CodeDeveloperList::roleNames() const{
    QHash<int, QByteArray> roles;
    roles[IDRole] = "id";
    roles[NameRole] = "name";
    roles[IconRole] = "icon";
    roles[BackendRole] = "backend";
    roles[CompanyObjectRole] = "companyObject";
    return roles;
}
