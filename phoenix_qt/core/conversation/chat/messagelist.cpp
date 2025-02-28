#include "messagelist.h"
#include <algorithm>

MessageList::MessageList(QObject* parent): QAbstractListModel(parent) {}

int MessageList::count() const {
    return m_messages.count();
}

int MessageList::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return m_messages.count();
}

QVariant MessageList::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_messages.count())
        return QVariant();

    Message* message = m_messages[index.row()];

    switch (role) {
    case IdRole:
        return message->id();
    case TextRole:
        return message->text();
    case DateRole:
        return message->date();
    case IconRole:
        return message->icon();
    case IsPromptRole:
        return message->isPrompt();
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> MessageList::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[TextRole] = "text";
    roles[DateRole] = "date";
    roles[IconRole] = "icon";
    roles[IsPromptRole] = "isPrompt";
    return roles;
}

bool MessageList::setData(const QModelIndex &index, const QVariant &value, int role) {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_messages.count())
        return false;

    Message* message = m_messages[index.row()];
    bool somethingChanged = false;

    switch (role) {
    case TextRole:
        if (message->text() != value.toString()) {
            message->setText(value.toString());
            somethingChanged = true;
        }
        break;
    }

    if (somethingChanged) {
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}

void MessageList::addMessage(const int id, const QString &text, const QDateTime date, const QString &icon, const bool isPrompt) {
    beginInsertRows(QModelIndex(), m_messages.count(), m_messages.count());
    Message* message = new Message(id, text, date, icon, isPrompt, this);
    m_messages.append(message);
    endInsertRows();
    emit countChanged();
    emit requestAddMessage(id, text, date, icon, isPrompt);
}

Message* MessageList::findMessageById(const int id) {
    auto it = std::find_if(m_messages.begin(), m_messages.end(), [id](Message* message) {
        return message->id() == id;
    });
    return (it != m_messages.end()) ? *it : nullptr;
}
