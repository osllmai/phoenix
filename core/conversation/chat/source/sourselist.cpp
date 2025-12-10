#include "sourselist.h"

SourseList::SourseList(QObject *parent)
    : QAbstractListModel(parent)
{
}

int SourseList::count() const {
    return m_sources.count();
}

int SourseList::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return m_sources.count();
}

QVariant SourseList::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_sources.count())
        return QVariant();

    Source *src = m_sources[index.row()];

    switch (role) {
    case IdRole:
        return src->id();
    case TitelRole:
        return src->title();
    case TextRole:
        return src->text();
    case IconRole:
        return src->icon();
    case LinkRole:
        return src->link();
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> SourseList::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[TitelRole] = "titel";
    roles[TextRole] = "text";
    roles[IconRole] = "icon";
    roles[LinkRole] = "link";
    return roles;
}

void SourseList::add(int id, const QString &titel, const QString &text,
                     const QString &icon, const QString &link)
{
    beginInsertRows(QModelIndex(), m_sources.size(), m_sources.size());
    Source *src = new Source(id, titel, text, icon, link, this);
    m_sources.append(src);
    endInsertRows();
    emit countChanged();
}

void SourseList::clear() {
    if (m_sources.isEmpty())
        return;

    beginResetModel();
    qDeleteAll(m_sources);
    m_sources.clear();
    endResetModel();

    emit countChanged();
}
