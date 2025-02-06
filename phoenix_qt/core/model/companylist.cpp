#include "companylist.h"

CompanyList::CompanyList(QObject *parent): QAbstractListModel(parent){}

int CompanyList::count() const{return m_companys.count();}

int CompanyList::rowCount(const QModelIndex &parent) const{
    Q_UNUSED(parent);
    return m_companys.count();
}

QVariant CompanyList::data(const QModelIndex &index, int role) const{
    if (!index.isValid())
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

    return roles;
}

Company *CompanyList::at(int index) const{
    if (index < 0 || index >= m_companys.count())
        return nullptr;
    return m_companys.at(index);
}
