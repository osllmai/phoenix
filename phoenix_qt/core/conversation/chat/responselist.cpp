#include "responselist.h"

ResponseList::ResponseList(QObject* parent):QAbstractListModel(parent) {}

int ResponseList::count() const {
    return m_tokens.count();
}

int ResponseList::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return m_tokens.count();
}

QVariant ResponseList::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_tokens.count())
        return QVariant();

    QString text = m_tokens[index.row()];

    switch (role) {
    case IdRole:
        return index.row();
    case TextRole:
        return text;
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> ResponseList::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[TextRole] = "text";
    return roles;
}

void ResponseList::addToken( const QString &text) {
    beginInsertRows(QModelIndex(), m_tokens.count(), m_tokens.count());
    m_tokens.append(text);
    endInsertRows();
    emit countChanged();
}
