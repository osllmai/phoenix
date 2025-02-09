#include "companylist.h"

CompanyList* CompanyList::m_instance = nullptr;

CompanyList* CompanyList::instance(QObject* parent) {
    if (!m_instance) {
        m_instance = new CompanyList(parent);
    }
    return m_instance;
}

CompanyList::CompanyList(QObject *parent): QAbstractListModel(parent){
    beginInsertRows(QModelIndex(), 0, 6);
    m_companys.append(new Company(1, "hi", "qrc:/media/image_company/Bert.svg",BackendType::OfflineModel,this));
    m_companys.append(new Company(1, "Hello", "qrc:/media/image_company/LLaMA.svg",BackendType::OnlineModel,this));
    m_companys.append(new Company(1, "OpenAI", "qrc:/media/image_company/Phi-3.svg",BackendType::OfflineModel,this));
    m_companys.append(new Company(1, "Nemati AI", "qrc:/media/image_company/qwen2.svg",BackendType::OfflineModel,this));
    m_companys.append(new Company(1, "OK", "qrc:/media/image_company/MPT.svg",BackendType::OnlineModel,this));
    m_companys.append(new Company(1, "LLAMA", "qrc:/media/image_company/Starcoder.svg",BackendType::OnlineModel,this));
    m_companys.append(new Company(1, "LO LO", "qrc:/media/image_company/Replit.svg",BackendType::OfflineModel,this));
    endInsertRows();
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
