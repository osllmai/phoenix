#include "activitylist.h"

ActivityList::ActivityList(QObject* parent): QAbstractListModel(parent) {}

int ActivityList::count() const {
    return m_activitys.count();
}

int ActivityList::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return m_activitys.count();
}

QVariant ActivityList::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_activitys.count())
        return QVariant();

    Activity* activity = m_activitys[index.row()];

    switch (role) {
    case IdRole:
        return activity->id();
    case TextRole:
        return activity->text();
    case IconRole:
        return activity->icon();
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> ActivityList::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[TextRole] = "text";
    roles[IconRole] = "icon";
    return roles;
}

void ActivityList::add(const int id, const QString &text, const QString &icon) {
    beginInsertRows(QModelIndex(), m_activitys.size(), m_activitys.size());
    Activity* activity = new Activity(id, text, icon,  this);
    m_activitys.append(activity);
    endInsertRows();
    emit countChanged();
}

void ActivityList::clear() {
    if (m_activitys.isEmpty())
        return;

    beginResetModel();

    qDeleteAll(m_activitys);
    m_activitys.clear();

    endResetModel();

    emit countChanged();
}
