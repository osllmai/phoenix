#include "onlinecompanylist.h"

#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QtConcurrent>
#include <QCoreApplication>

#include "onlinemodellist.h"

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
    case BackendRole:
        return static_cast<int>(company->backend());
    case CompanyObjectRole:
        return QVariant::fromValue(m_companys[index.row()]);
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> OnlineCompanyList::roleNames() const{
    QHash<int, QByteArray> roles;
    roles[IDRole] = "id";
    roles[NameRole] = "name";
    roles[IconRole] = "icon";
    roles[BackendRole] = "backend";
    roles[CompanyObjectRole] = "companyObject";
    return roles;
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
